#!/usr/bin/perl

use strict;
use ParseUtils;
use DBI;

my $o_file1 = "phylocEST.txt";
my $o_file2 = "phylocMRNA.txt";
my $o_file3 = "phylocCytoband.txt";
my $o_file4 = "phylocGene.txt";
my $o_file5 = "phylocMarker.txt";
my $o_file6 = "snpCytoPhyloc.txt";
my $o_file7 = "geneCytoPhyloc.txt";
my $o_file8 = "cytobandCytoPhyloc.txt";

my ($chrstart);

my ($indir,$outdir) = getFullDataPaths('relative_clone');
my $out_file1 = "$outdir/$o_file1";
my $out_file2 = "$outdir/$o_file2";
my ($indir,$outdir) = getFullDataPaths('cytoband');
my $out_file3 = "$outdir/$o_file3";
my ($indir,$outdir) = getFullDataPaths('ncbi_unigene');
my $out_file4 = "$outdir/$o_file4";
my ($indir,$outdir) = getFullDataPaths('marker');
my $out_file5 = "$outdir/$o_file5";
my ($indir,$outdir) = getFullDataPaths('snp');
my $out_file6 = "$outdir/$o_file6";
my ($indir,$outdir) = getFullDataPaths('ncbi_unigene');
my $out_file7 = "$outdir/$o_file7";
my ($indir,$outdir) = getFullDataPaths('cytoband');
my $out_file8 = "$outdir/$o_file8";
print "Getting acc Nos from nas \n";
my $accessionNumberHash = &getAccessionNumber(); 
print "Getting Cytoband \n";
my $cytobandHash = &getCytoband(); 
print "Getting mRNA data \n";
my $mRNAHash = &getMRNA(); 
print "Getting EST data \n";
my $estHash = &getEST(); 
print "Getting Cytoband data \n";
my $cytoLocHash = &getCytobandLocation(); 
print "Getting Gene data \n";
my $geneHash = &getGene(); 
print "Getting Marker data \n";
my $markerHash = &getMarker(); 
print "Getting SNP Cytogenetic Loc \n";
my $snpCytoHash = &getSnpCyto(); 
print "Getting Gene Cytogenetic Loc \n";
my $geneCytoHash = &getGeneCyto(); 
print "Getting Cytoband cytogenetic loc \n";
my $cytoCytoHash = &getcytoCyto(); 
print "Finished getting all the relevant data \n";
open (FILE1,">$out_file1") || die "Cannot open $out_file1 \n\n";
open (FILE2,">$out_file2") || die "Cannot open $out_file2 \n\n";
open (FILE3,">$out_file3") || die "Cannot open $out_file3 \n\n";
open (FILE4,">$out_file4") || die "Cannot open $out_file4 \n\n";
open (FILE5,">$out_file5") || die "Cannot open $out_file5 \n\n";
open (FILE6,">$out_file6") || die "Cannot open $out_file6 \n\n";
open (FILE7,">$out_file7") || die "Cannot open $out_file7 \n\n";
open (FILE8,">$out_file8") || die "Cannot open $out_file8 \n\n";
my ($acNumber, $st, $cytName);

foreach my $ky (keys %$geneHash) {
   print FILE4 "$ky#$geneHash->{$ky}\n";
}
close FILE4;

print "clone4 \n";
foreach my $ky (keys %$markerHash) {
   print FILE5 "$ky|$markerHash->{$ky}\n";
}
close FILE5;
print "clone5 \n";

foreach my $ky (keys %$snpCytoHash) {
   print FILE6 "$ky|$snpCytoHash->{$ky}\n";
}
close FILE6;
print "clone6 \n";

foreach my $ky (keys %$geneCytoHash) {
   print FILE7 "$ky|$geneCytoHash->{$ky}\n";
}
close FILE7;

print "clone7 \n";
foreach my $ky (keys %$cytoCytoHash) {
   print FILE8 "$ky|$cytoCytoHash->{$ky}\n";
}
close FILE8;

print "clone8 \n";
foreach my $accNo (keys %$mRNAHash) {
  ($acNumber, $st, $chrstart) = split (/\|/, $accNo);
  if (exists($accessionNumberHash->{$acNumber})) {
#   print "$accNo|$mRNAHash->{$accNo}\n";
   print FILE2 "$acNumber|$accessionNumberHash->{$acNumber}|$mRNAHash->{$accNo}\n";
  }
}
close FILE2;

print "clone2 \n";
foreach my $accNo (keys %$estHash) {
  ($acNumber, $st, $chrstart) = split (/\|/, $accNo);
  if (exists ($accessionNumberHash->{$acNumber})) {
#   print "$accNo|$estHash->{$accNo}\n";
   print FILE1 "$acNumber|$accessionNumberHash->{$acNumber}|$estHash->{$accNo}\n";
  }
}
close FILE1;

print "clone1 \n";
foreach my $cytoname (keys %$cytoLocHash) {
 ($cytName, $st) = split (/\|/, $cytoname);
 if (exists($cytobandHash->{$cytName})) {
  print FILE3 "$cytName|$cytobandHash->{$cytName}|$cytoLocHash->{$cytoname}\n";
 }
}
close FILE3;

print "clone3 \n";

sub getAccessionNumber() {
my($no, $id, $taxId);
my %accNoHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct ACCESSION_NUMBER, ID from nucleic_acid_sequence);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$no, \$id);
while($sth->fetch()) {
        $no=~s/\s+//g;
        $id=~s/\s+//g;
        $accNoHash{$no} = $id;
}
return \%accNoHash;
}


sub getGene() {
my($symbol, $clustId, $id, $taxId, $chrId, $fullName, $chrStart, $chrStop, $ftype, $glabel);
my %geneHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
#my $sql = qq(
#select distinct c.taxon_ID, c.gene_ID, c.SYMBOL, c.chromosome_ID, a.CHR_START, a.CHR_STOP, 'clusterid', a.FEATURE_TYPE, decode(a.GROUP_LABEL, 'Primary Assembly', 'GRCh37', a.GROUP_LABEL ) group_lable from zstg_seqgene a,  gene_tv c   where substr(a.FEATURE_ID, instr(a.FEATURE_ID,':')+1) = to_char(c.entrez_id) and a.chromosome not like '%|%'
#);
my $sql = qq(
select distinct c.taxon_ID, c.gene_ID, c.SYMBOL, ch.chromosome_ID, a.CHR_START, a.CHR_STOP,
 'clusterid', a.FEATURE_TYPE,
  decode(a.GROUP_LABEL, 'Primary Assembly', 'GRCh37', a.GROUP_LABEL ) group_lable
   from zstg_seqgene a,  gene_tv c, chromosome ch   where
    substr(a.FEATURE_ID, instr(a.FEATURE_ID,':')+1) = to_char(c.entrez_id) 
	and a.chromosome not like '%|%' and ch.chromosome_number = a.chromosome
	 and ch.TAXON_ID=a.TAX_ID
);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$taxId, \$id, \$symbol, \$chrId, \$chrStart, \$chrStop, \$clustId, \$ftype, \$glabel);
while($sth->fetch()) {
        $id=~s/\s+//g;
        $symbol=~s/\s+//g;
        $clustId=~s/\s+//g;
        $taxId=~s/\s+//g;
        $chrId=~s/\s+//g;
        $chrStart=~s/\s+//g;
        $chrStop=~s/\s+//g;
	$ftype=~s/\s+//g;
	$glabel=~s/\s+//g;
        $geneHash{$id."#".$symbol."#".$chrStart."#".$ftype."#".$glabel} = $id."#".$symbol."#".$clustId."#".$taxId."#".$chrId."#".$chrStart."#".$chrStop."#".$ftype."#".$glabel;
}
return \%geneHash;
}

sub getMarker() {
my($taxId, $id, $chrId, $UniSTSId, $chrStart, $chrStop, $chrId, $ftype, $glabel);
my %markerHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(
select distinct c.ID, d.taxon_ID, d.chromosome_ID, c.marker_ID, a.CHR_START, a.CHR_STOP, a.FEATURE_TYPE, decode(a.GROUP_LABEL, 'Primary_Assembly', 'GRCh37', a.GROUP_LABEL ) group_lable from zstg_seqsts a, marker c, chromosome d where substr(a.FEATURE_ID, instr(a.FEATURE_ID,':')+1) = to_char(c.MARKER_ID) and decode(instr(a.chromosome,'_'),0,a.chromosome,substr(a.chromosome,0,instr(a.chromosome,'_')-1)) = d.chromosome_number and a.TAX_ID = d.TAXON_ID and c.TYPE = 'UNISTS' and a.chromosome not like '%|%'

);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$id, \$taxId, \$chrId, \$UniSTSId, \$chrStart, \$chrStop, \$ftype, \$glabel);
while($sth->fetch()) {
        $id=~s/\s+//g;
        $chrId=~s/\s+//g;
        $chrStart=~s/\s+//g;
        $chrStop=~s/\s+//g;
	$ftype=~s/\s+//g;
	$glabel=~s/\s+//g;
        chomp($UniSTSId);
        $markerHash{$id."|".$taxId."|".$chrId."|".$chrStart} = $id."|".$chrId."|".$chrStart."|".$chrStop."|".$UniSTSId."|".$ftype."|".$glabel;
}
return \%markerHash;
}

sub getSnpCyto() {
my($snpid, $startcytoId, $endcytoId, $chrId);
my %snpCytoHash;

my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT DISTINCT A.ID,E.ID,E.ID,A.chromosome_ID FROM   snp_tv A, zstg_snpcytoids E WHERE  lower(A.DB_SNP_ID) = lower(E.DBSNP_RS_ID));
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$snpid, \$startcytoId, \$endcytoId, \$chrId);
while($sth->fetch()) {
        $snpid=~s/\s+//g;
        $startcytoId=~s/\s+//g;
        $endcytoId=~s/\s+//g;
        $chrId=~s/\s+//g;
        $snpCytoHash{$snpid."|".$startcytoId} = $snpid."|".$chrId."|".$startcytoId."|".$endcytoId;
}
return \%snpCytoHash;
}

sub getGeneCyto() {
my($geneid, $startcytoId, $endcytoId, $chrId);
my %geneCytoHash;

my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct a.gene_id, c.id START_cytoband_LOC_ID,d.id as END_CYTOBAND_LOC_ID,  a.chromosome_id from zstg_gene a, zstg_startcytoids c, zstg_endcytoids d where a.start_cytoband = c.start_cytoband(+) and a.gene_id = c.gene_id(+) and a.chromosome_id = c.chromosome_id(+) and a.end_cytoband = d.end_cytoband(+) and a.gene_id = d.gene_id(+) and c.gene_id = d.gene_id and a.chromosome_id = d.chromosome_id(+));
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$geneid, \$startcytoId, \$endcytoId, \$chrId);
while($sth->fetch()) {
        $geneid=~s/\s+//g;
        $startcytoId=~s/\s+//g;
        $endcytoId=~s/\s+//g;
        $chrId=~s/\s+//g;
        $geneCytoHash{$geneid."|".$startcytoId."|".$chrId} = $geneid."|".$chrId."|".$startcytoId."|".$endcytoId;
}
return \%geneCytoHash;
}

sub getcytoCyto() {
my($startcytoId, $endcytoId, $chrId);
my %cytoCytoHash;

my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct a.chromosome_id chromosome_id, b.id start_cytoband_loc_id, b.id end_cytoband_loc_id from zstg_human_cytoband a, cytoband b where lower(a.cytoband) = lower(b.name) UNION SELECT distinct a.chromosome_id chromosome_id, b.id start_cytoband_loc_id, b.id end_cytoband_loc_id from zstg_mouse_cytoband a, cytoband b where lower(a.cytoband) = lower(b.name));
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$chrId, \$startcytoId, \$endcytoId);
while($sth->fetch()) {
        $chrId=~s/\s+//g;
        $startcytoId=~s/\s+//g;
        $endcytoId=~s/\s+//g;
        $cytoCytoHash{$endcytoId."|".$startcytoId."|".$chrId} = $chrId."|".$startcytoId."|".$endcytoId;
}
return \%cytoCytoHash;
}


sub getCytoband() {
my($name, $id, $phylocId);
my %cytobHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct ID, NAME,physical_location_ID from cytoband where PHYSICAL_LOCATION_ID is NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$id, \$name, \$phylocId);
while($sth->fetch()) {
        $name=~s/\s+//g;
        $id=~s/\s+//g;
        $phylocId=~s/\s+//g;
        $cytobHash{$name}=$id."|".$phylocId;
}
return \%cytobHash;
}

sub getEST() {
my($chrId, $start, $stop, $accNo, $ftype);
my %ESTHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT DISTINCT QNAME, chromosome_ID, TSTART, TEND, 'EST' as FEATURE_TYPE from zstg_human_est where CHROMOSOME_ID <> 'null' );
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$accNo,\$chrId, \$start,\$stop, \$ftype);
while($sth->fetch()) {
        $accNo=~s/\s+//g;
        $chrId=~s/\s+//g;
        $ftype=~s/\s+//g;
        $ESTHash{$accNo."|".$start."|".$chrId} = $start."|".$stop."|".$chrId."|".$ftype;
}


my $sql = qq(SELECT DISTINCT QNAME, chromosome_ID, TSTART, TEND, 'EST' as FEATURE_TYPE from zstg_mouse_est where CHROMOSOME_ID <> 'null');
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$accNo,\$chrId, \$start,\$stop, \$ftype);
while($sth->fetch()) {
        $accNo=~s/\s+//g;
        $chrId=~s/\s+//g;
        $ftype=~s/\s+//g;
        $ESTHash{$accNo."|".$start."|".$chrId} = $start."|".$stop."|".$chrId."|".$ftype;
}

return \%ESTHash;
}

sub getMRNA() {
my($chrId, $start, $stop, $accNo, $ftype);
my %MRNAHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT DISTINCT QNAME, chromosome_ID, TSTART, TEND, 'MRNA' as FEATURE_TYPE from zstg_human_mrna where CHROMOSOME_ID <> 'null' );
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$accNo,\$chrId, \$start,\$stop, \$ftype);
while($sth->fetch()) {
        $accNo=~s/\s+//g;
        $chrId=~s/\s+//g;
        $ftype=~s/\s+//g;
        $MRNAHash{$accNo."|".$start."|".$chrId} = $start."|".$stop."|".$chrId."|".$ftype;
}


my $sql = qq(SELECT DISTINCT QNAME, chromosome_ID, TSTART, TEND, 'MRNA' as FEATURE_TYPE from zstg_mouse_mrna where CHROMOSOME_ID <> 'null' );
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$accNo,\$chrId, \$start,\$stop, \$ftype);
while($sth->fetch()) {
        $accNo=~s/\s+//g;
        $chrId=~s/\s+//g;
        $ftype=~s/\s+//g;
        $MRNAHash{$accNo."|".$start."|".$chrId} = $start."|".$stop."|".$chrId."|".$ftype;
}

return \%MRNAHash;
}


sub getCytobandLocation() {
my($name, $start, $stop, $chrId);
my %CytoLocationHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(SELECT distinct cytoband, CHROMSTART,CHROMEND, chromosome_id from zstg_human_cytoband where chromosome_ID is NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$name, \$start,\$stop, \$chrId);
while($sth->fetch()) {
        $name=~s/\s+//g;
        $start=~s/\s+//g;
        $stop=~s/\s+//g;
        $chrId=~s/\s+//g;
        $CytoLocationHash{$name."|".$start} = $start."|".$stop."|".$chrId;
}


my $sql = qq(SELECT distinct cytoband, CHROMSTART, CHROMEND, chromosome_id from zstg_mouse_cytoband where chromosome_ID is NOT NULL);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$name, \$start,\$stop, \$chrId);
while($sth->fetch()) {
        $name=~s/\s+//g;
        $start=~s/\s+//g;
        $stop=~s/\s+//g;
        $chrId=~s/\s+//g;
        $CytoLocationHash{$name."|".$start} = $start."|".$stop."|".$chrId;
}

return \%CytoLocationHash;
}


print "before \n";
close INFILE;
close OUTFILE;
print "after \n";

exit;
