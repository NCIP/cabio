#!/usr/bin/perl

use strict;
use ParseUtils;
use DBI;

my $o_file1 = "gene_histo.txt";
my $o_file2 = "context.sql";
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
my($gid, $clust, $libId, $keywords);
my @split_kw;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct gene_ID, CLUSTER_NUMBER, library_ID, KEYWORD from ZSTG_GENE_KW);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$gid, \$clust, \$libId, \$keywords);
while($sth->fetch()) {
        $gid=~s/\s+//g;
        $clust=~s/\s+//g;
        $libId=~s/\s+//g;
	@split_kw = ();
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

sub getDiseaseOntology() {
my($histId, $histName);
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct trim(histology_code), trim(HISTOLOGY_NAME) from HISTOLOGY_CODE where HISTOLOGY_NAME is NOT NULL and HISTOLOGY_CODE is NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$histId, \$histName);
while($sth->fetch()) {
        chomp($histId);
        chomp($histName);
        $DiseaseOnto{$histName} = $histId;
}
return \%DiseaseOnto;
}

sub getContext() {
my($contextId, $histId, $tissueId);
my %Context;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct context_CODE, histology_code, tissue_code from CONTEXT where HISTOLOGY_CODE is NOT NULL and TISSUE_CODE is NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$contextId, \$histId, \$tissueId);
while($sth->fetch()) {
        chomp($histId);
        chomp($contextId);
        chomp($tissueId);
	$Context{$histId}{$tissueId} = $contextId;
}
return \%Context;
}

sub getMaxContextId() {
my $contextId;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT max(context_CODE) from CONTEXT);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$contextId);
	while ($sth->fetch()) {
	       chomp($contextId);	
	}
return $contextId;
}

sub getOrganOntology() {
my($tissueId, $tissueName);
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct trim(tissue_code), trim(TISSUE_NAME) from TISSUE_CODE where TISSUE_NAME is NOT NULL and TISSUE_CODE is NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$tissueId, \$tissueName);
while($sth->fetch()) {
        chomp($tissueId);
        chomp($tissueName);
        $OrganOnto{$tissueName} = $tissueId;	
 #       print "Organ Id $tissueId Name: $tissueName \n";	
}
}
exit;
