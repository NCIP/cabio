#!/usr/bin/perl
use XML::TreePP;
use Data::Dumper;
use ParseUtils;

chomp($ARGV[0]);
chomp($ARGV[1]);

my ($indir, $outdir) = getFullDataPaths("pid/$ARGV[0]");
my ($inFile) = "$indir/$ARGV[1]";

my $tpp = XML::TreePP->new();
$tpp->set( force_array => ['Curator', 'Reference', 'PathwayComponent']);
my $tree = $tpp->parsefile($inFile);


$Data::Dumper::Pair='=>';
$Data::Dumper::Indent=1;
my $text = Dumper ($tree);
#print $text;

my $counter = 0;
my ($iid, $sid, $allReferences, $allCurators, $allPathwayComponents, $allPathways, $roletype, $interactidref);
$allPathways =  $tree->{PathwayList}->{Pathway};

open fhandle1,">$outdir/Pathways.txt";
open fhandle4,">$outdir/PathwayReferences.txt";
open fhandle2,">$outdir/PathwayCurators.txt";
open fhandle3,">$outdir/PathwayReviewers.txt";
open fhandle5,">$outdir/PathwayComponent.txt";

foreach my $pathway (@$allPathways) {
  $counter++;
  $iid = $pathway->{"-id"};
  $sid = $pathway->{Source}->{"-id"};
  print fhandle1 $pathway->{Organism},"|",$pathway->{"-id"},"|",$pathway->{"-subnet"},"|",$pathway->{LongName},"|",$pathway->{ShortName},"|",$pathway->{Source}->{"-id"},"\n"; 

   $allCurators = $pathway->{CuratorList}->{Curator};
    foreach my $ref (@$allCurators) {
          print fhandle2 $iid,"|",$sid,"|",$ref,"\n";	
	}

   $allReviewers = $pathway->{ReviewerList}->{Reviewer};
    foreach my $ref (@$allReviewers) {
          print fhandle3 $iid,"|",$sid,"|",$ref,"\n";	
	}

   $allReferences = $pathway->{ReferenceList}->{Reference};
    foreach my $ref (@$allReferences) {
          print fhandle4 $iid,"|",$sid,"|",$ref->{"#text"},"|",$ref->{"-pmid"},"\n";	
	}

   $allPathwayComponents = $pathway->{PathwayComponentList}->{PathwayComponent}; 
    foreach my $ref (@$allPathwayComponents) {
         $interactidref = $ref->{"-interaction_idref"};
       
         $pathwaycomponent = $iid."|".$sid."|".$interactidref;

         print fhandle5 $pathwaycomponent,"\n";	
       }
}
