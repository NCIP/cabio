#!/usr/bin/perl
use XML::TreePP;
use Data::Dumper;
use ParseUtils;

chomp($ARGV[0]);
chomp($ARGV[1]);

my ($indir, $outdir) = getFullDataPaths("pid/$ARGV[0]");
my ($inFile) = "$indir/$ARGV[1]";

my $src;

if ($ARGV[0] eq 'Reactome') {
  $src = 7;
}
elsif ($ARGV[0] eq 'NCI_Nature') {
  $src = 5;
} else {
 $src = 3;
}

my $tpp = XML::TreePP->new();
$tpp->set( force_array => ['Label', 'Name', 'ComplexComponent', 'PTMTerm', 'Part', 'Member']);
my $tree = $tpp->parsefile($inFile);

$Data::Dumper::Pair='=>';
$Data::Dumper::Indent=1;
my $text = Dumper ($tree);
#print $text;

my $counter = 0;
my ($iid, $mtype, $allComplexComponents, $allNames, $allMoleculeComponents, $allMolecules, $roletype, $interactidref);
$allMolecules =  $tree->{MoleculeList}->{Molecule};

open fhandle2,">$outdir/MoleculeNames.txt";
open fhandle3,">$outdir/MoleculeFamilies.txt";
open fhandle4,">$outdir/MoleculeParts.txt";
open fhandle5,">$outdir/MoleculeComponentLabels.txt";
open fhandle6,">$outdir/MoleculeComponentPTMTerms.txt";

foreach my $molecule (@$allMolecules) {
  $counter++;
  $iid = $molecule->{"-id"};
  $mtype = $molecule->{"-molecule_type"};

   $allNames = $molecule->{Name};
    foreach my $ref (@$allNames) {
          print fhandle2 $iid,"|",$mtype,"|",$src,"|",$ref->{"-name_type"},"|",$ref->{"-long_name_type"},"|",$ref->{"-value"},"\n";	
	}

   $allFamilies = $molecule->{FamilyMemberList}->{Member};
    foreach my $ref (@$allFamilies) {
          print fhandle3 $iid,"|",$mtype,"|",$src,"|",$ref->{"-family_molecule_idref"},"|",$ref->{"-member_molecule_idref"},"\n";	
	}

   $allParts = $molecule->{Part};
    foreach my $ref (@$allParts) {
          print fhandle4 $iid,"|",$mtype,"|",$src,"|",$ref->{"-whole_molecule_idref"},"|",$ref->{"-part_molecule_idref"},"|",$ref->{"-start"},"|",$ref->{"-end"},"\n";	
	}

   $allComplexComponents = $molecule->{ComplexComponentList}->{ComplexComponent}; 
    foreach my $ref (@$allComplexComponents) {
         $moleculeidref = $ref->{"-molecule_idref"};
       
         $moleculecomponent = $iid."|".$mtype."|".$ref->{"-molecule_idref"}."|".$src;

         $allLabels = $ref->{Label};
	foreach my $label (@$allLabels) {
          print fhandle5 $moleculecomponent."|".$label->{"-label_type"}."|".$label->{"-value"}."\n";
        }
       
 	$allPTMTerms = $ref->{PTMExpression}->{PTMTerm};
        foreach my $PTMTerm (@$allPTMTerms) {
          print fhandle6 $moleculecomponent."|".$PTMTerm->{"-protein"}."|".$PTMTerm->{"-position"}."|".$PTMTerm->{"-aa"}."|".$PTMTerm->{"-modification"}."\n";
  			}
  		}
}
