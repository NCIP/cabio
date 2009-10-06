package LexEVSUtils;
#
# Common utilities for accessing LexEVS.
#
# Author: Konrad Rokicki
# Date: 09/29/2009
#

use strict;
use base 'Exporter';
use LWP::Simple;
use XML::Twig::XPath;

our @EXPORT    = qw(queryEVS getLatestNcitVersion evsLookup);
our @EXPORT_OK = qw($EVSAPI_URL);

our $DEBUG = 0;
our $EVSAPI_URL = "http://lexevsapi.nci.nih.gov/lexevsapi50";
our $MATCH_ON_ALIASES = 0;

INIT {
    print "Loading LexEVSUtils...\n";
    print "  EVSAPI_URL = $EVSAPI_URL\n";
    print "  MATCH_ON_ALIASES = $MATCH_ON_ALIASES\n";
    print "  DEBUG = $DEBUG\n";
    print "Done.\n";
}

#
# Queries the LexEVS REST API and returns a parsed XML::Twig object.
#
sub queryEVS {

    my ($url) = @_;
    
    my $xml = get $url;
    print "$url\n" if $DEBUG;
    
    if ($xml =~ /caCORE HTTP Servlet Error/) {
        print "Error contacting EVS at URL:\n$url\n\nServer returned:\n$xml";
        return "";
    }
   
    my $twig = XML::Twig::XPath->new(); 
    $twig->parse($xml);
    return $twig;
}


#
# Returns the first NCI Thesaurus version it finds, or the empty string if there is 
# no NCI Thesaurus defined.
#
sub getNcitVersion {

    my $url = $EVSAPI_URL.'/GetXML?query=CodingScheme&CodingScheme[@_codingSchemeName=NCI_Thesaurus]';
    my $twig = queryEVS($url);
    my @classNodes = $twig->findnodes("/xlink:httpQuery/queryResponse/class");

    for my $classNode (@classNodes) {
        my $version = $classNode->findvalue('field[@name="_representsVersion"]');
        
        return $version if ($version ne "");
    }
    return "";
}

#
# Parses EVS synonyms (presentations with type "FULL_SYN") and returns a 
# hash of them (the hash values are counts of the number of time each synonym
# appears). 
#
sub parseSynonyms {

    my @synClassNodes = @_;
    my %synonyms = ();
    
    for my $classNode (@synClassNodes) {
        my $propertyName = $classNode->findvalue('field[@name="_propertyName"]');
        my $name = $classNode->findvalue('field[@name="_value"]/class[1]/field[@name="_content"]');
        if ($propertyName eq "FULL_SYN") {
            $synonyms{$name}++;
        }
    }
    
    return keys %synonyms;
}

#
# Lookup a term in the NCI Thesaurus and return a matching EVS concept code.
#
# The matching algorithm proceeds as follows:
# 1) Search for term in EVS across all presentations (i.e. synonyms in EVS)
# 2) If there are no matches and MATCH_ON_ALIASES is true then this method is
#    called recursively for each alias in synHash until an EVS Id is returned.
# 3) If there is a match on preferred name, return that.
# 4) If there are other matches then we need to choose the best one:
#    a) Matches with preferred names in the synHash are considered "reciprocal" 
#       matches and are immediately returned without checking other matches.
#    b) All other matches are added to a list in a prioritized order and 
#       a "best match" is chosen from the list to return.
#
# Arguments:
# @term the search term to find a matching concept for
# @synHash scalar reference to a hash with keys that are potential synonyms to 
#          match on if the term can't be found  
# @indent default indent for debug statements
#
sub evsLookup {

    my ($term,$synHash,$indent) = @_;
    $term =~ tr|[]/&=|     |; 
    
    # Title case because the REST API cannot do case-insensitive queries, 
    # and most preferred names in EVS are in title case
    $term =~ s/(\S+)/\u\L$1/g;
    
    my $url = $EVSAPI_URL.'/GetXML?query=Concept,Presentation,Text&Text[@_content='
        .$term.']&codingSchemeName=NCI_Thesaurus';#&codingSchemeVersion='.$NCIT_VERSION; 
    my $twig = queryEVS($url);
    my @classNodes = $twig->findnodes("/xlink:httpQuery/queryResponse/class");
    
    unless (@classNodes) {
        return "" unless ($MATCH_ON_ALIASES);
        return "" unless ($synHash);
        my @aliases = keys %$synHash;
        if (@aliases) {
            print $indent."No matches on $term, testing aliases...\n";
            for my $alias (@aliases) {
                print $indent."  Trying alias '$alias'...\n";
                my $evsId = evsLookup($alias, {}, $indent." "x4);
                if ($evsId) {
                    return $evsId;
                }
            }
        }
        return "";
    }
    
    # EVS concepts which have the term as a synonym
    my @synMatches = ();
    
    for my $classNode (@classNodes) {
        my $name = $classNode->findvalue('field[@name="_entityDescription"]/class[1]/field[@name="_content"]');
        my $evsId = $classNode->findvalue('field[@name="_entityCode"]');
        
        if (lc($name) eq lc($term)) {
            print $indent."Found concept with preferred name $term\n";
            return $evsId;
        }
        
        my @propnodes = $classNode->findnodes('field[@name="_propertyList"]//field[@name="_propertyName"]');
        my %props = ();
        for my $propnode (@propnodes) {
            $props{$propnode->text}++;
        }
        
        my @synClassNodes = $classNode->findnodes('field[@name="_presentationList"]/class');
        my @synonyms = parseSynonyms(@synClassNodes);
        
        for my $synonym (@synonyms) {
            if (lc($synonym) eq lc($term)) {
                print $indent."Found concept with synonym $term ($evsId:$name)\n";
                if ($synHash->{lc($name)}) {
                    print $indent."Confirmed reciprocal match: $name is a drug alias for $term.\n";
                    return $evsId;
                }
                if ($props{'Chemical_Formula'} || $props{'CAS_Registry'} || $props{'USDA_ID'}) {
                    # prioritize this concept at the front of the list because it's much more likely to be a drug
                    unshift @synMatches, $evsId;
                }
                else {
                    push @synMatches, $evsId;
                }
            }
        }
    }
    
    my $numSyns = scalar @synMatches;
    
    if ($numSyns > 0) {
        if ($numSyns > 1) {
            print $indent."Warning, more than 1 potential match for $term: ".
                join(", ",@synMatches)."\n";
        }
        print $indent."Returning synonym match ".$synMatches[0]."\n";
        return $synMatches[0];
    }
}

1;
