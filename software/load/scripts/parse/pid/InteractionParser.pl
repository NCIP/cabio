#!/usr/bin/perl
use XML::TreePP;
use Data::Dumper;
use ParseUtils;

chomp($ARGV[0]);
chomp($ARGV[1]);

my ($indir, $outdir) = getFullDataPaths("pid/$ARGV[0]");
my ($inFile) = "$indir/$ARGV[1]";

my $tpp = XML::TreePP->new();
$tpp->set( force_array => ['Reference','Condition', 'Evidence', 'Label', 'InteractionComponent', 'PTMTerm']);
my $tree = $tpp->parsefile($inFile);

$Data::Dumper::Pair='=>';
$Data::Dumper::Indent=1;
my $text = Dumper ($tree);
#print $text;

my $counter = 0;
my ($iid, $sid, $allReferences, $allEvidences, $allInteractionComponents, $allInteractions, $roletype, $interactidref);
$allInteractions =  $tree->{InteractionList}->{Interaction};

open fhandle1,">$outdir/Interactions.txt";
open fhandle2,">$outdir/InteractionEvidences.txt";
open fhandle3,">$outdir/InteractionComponentLabels.txt";
open fhandle4,">$outdir/InteractionReferences.txt";
open fhandle5,">$outdir/InteractionComponentConditions.txt";
open fhandle6,">$outdir/InteractionComponentPTMTerms.txt";

foreach my $interaction (@$allInteractions) {
  $counter++;
  $iid = $interaction->{"-id"};
  $sid = $interaction->{Source}->{"-id"};
  print fhandle1 $interaction->{"-interaction_type"},"|",$interaction->{"-id"},"|",$interaction->{Abstraction}->{"-pathway_idref"},"|",$interaction->{Abstraction}->{"-pathway_name"},"|",$interaction->{Abstraction}->{"-external_pathway_id"},"|",$interaction->{Source}->{"-id"},"|",$interaction->{Source}->{"#text"},"\n"; 

   $allEvidences = $interaction->{EvidenceList}->{Evidence};
    foreach my $ref (@$allEvidences) {
          print fhandle2 $iid,"|",$sid,"|",$ref->{"#text"},"|",$ref->{"-value"},"\n";	
	}

   $allReferences = $interaction->{ReferenceList}->{Reference};
    foreach my $ref (@$allReferences) {
          print fhandle4 $iid,"|",$sid,"|",$ref->{"#text"},"|",$ref->{"-pmid"},"\n";	
	}

        $allConditions = $interaction->{Condition};
	foreach my $condition (@$allConditions) {
          print fhandle5 $iid."|".$sid."|".$condition->{"-condition_type"}."|".$condition->{"#text"}."\n";
        }

   $allInteractionComponents = $interaction->{InteractionComponentList}->{InteractionComponent}; 
    foreach my $ref (@$allInteractionComponents) {
         $moleculeidref = $ref->{"-molecule_idref"};
       
         $interactioncomponent = $iid."|".$sid."|".$ref->{"-molecule_idref"}."|".$ref->{"-role_type"};

         $allLabels = $ref->{Label};
	foreach my $label (@$allLabels) {
          print fhandle3 $interactioncomponent."|".$label->{"-label_type"}."|".$label->{"-value"}."\n";
        }
         
        $allPTMTerms = $ref->{PTMExpression}->{PTMTerm};
	foreach my $PTMTerm (@$allPTMTerms) {
          print fhandle6 $interactioncomponent."|".$PTMTerm->{"-protein"}."|".$PTMTerm->{"-position"}."|".$PTMTerm->{"-aa"}."|".$PTMTerm->{"-modification"}."\n";
  }
  }
 #print "$counter\n";
}
