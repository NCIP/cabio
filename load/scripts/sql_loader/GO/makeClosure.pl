#!/usr/bin/perl

use strict;
use ParseUtils;
use DBI;

my $o_file1 = "gene_histo.txt";
my ($Diseases, $Organs, $Context);
my %DiseaseOnto;
my %OrganOnto;
my ($foundHisto, $foundTissue, $maxContextId);
my ($indir,$outdir) = getFullDataPaths('histo');
my $out_file1 = $outdir."/".$o_file1;
print "Getting  DiseaseOntology\n";
open (FILE1,">$out_file1") || die "Cannot open $out_file1 \n\n";
open (FILE2,">$o_file2") || die "Cannot open $o_file2 \n\n";
$Diseases = &getDiseaseOntology();
print "Getting  OrganOntology\n";
$Organs = &getOrganOntology();
print "Getting  Context\n";
$Context = &getContext();
$maxContextId = &getMaxContextId();
&getGeneKeywords($Diseases, $Organs, $Context); 

close FILE1;
print FILE2 "EXIT;\n";
close FILE2;
sub getGeneKeywords() {
my($goid, $clust, $libId, $keywords);
my @go_id;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct go_id fom go_ontology);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$goid);
while($sth->fetch()) {
        $goid=~s/\s+//g;
	push(@split)
	@split_kw = split(',',$keywords);
	$foundHisto = "";
	$foundTissue = "";
	foreach $_ (@split_kw) {
	chomp($_);
	$_=~s/^\s+//g;
	$_=~s/\s+$//g;
	if (exists($DiseaseOnto{$_}))
	{
	 $foundHisto = $DiseaseOnto{$_};
        }  
	if(exists($OrganOnto{$_})) {
	 $foundTissue = $OrganOnto{$_};
        } 
	}
	chomp($foundHisto);
	chomp($foundTissue);

	if (($foundTissue !="") && ($foundHisto !="")) {
	if(exists($Context->{$foundHisto}{$foundTissue})) {
	print FILE1 "$gid|$Context->{$foundHisto}->{$foundTissue}\n";
		} else {
		print FILE2 "INSERT INTO context(CONTEXT_CODE, histology_code, tissue_code) VALUES(".++$maxContextId.",".$foundHisto.",".$foundTissue.");\n";
	print FILE1 "$gid|$maxContextId\n";
	$Context->{$foundHisto}->{$foundTissue} = 1;	
		}
	}
        } 
}

sub getParents() {
my($parentId, $existingParents, $child);
$child = shift || die "Child whose parents are needed \n";
$existingParents = shift || die "No parameter $!\n";
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct parent_id from go_relationship where child_id = $child);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$parentId, \$histName);
while($sth->fetch()) {
        chomp($parentId);
        $DiseaseOnto{$histName} = $histId;
}
return \%DiseaseOnto;
}

exit;
