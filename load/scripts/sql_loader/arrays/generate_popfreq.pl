#!/usr/bin/perl

use strict;
use ParseUtils;
use DBI;

my $o_file1 = "popFreq.txt";

my ($indir,$outdir) = getFullDataPaths('population_frequency');
my $out_file1 = "$outdir/$o_file1";
print "Getting population frequency \n";
my $popFreqHash = &getPopFreq(); 
print "Finished getting all the relevant data \n";
open (FILE1,">$out_file1") || die "Cannot open $out_file1 \n\n";
my ($acNumber, $st, $cytName);

foreach my $ky (keys %$popFreqHash) {
   print FILE1 "$ky|$popFreqHash->{$ky}\n";
}
close FILE1;
exit;

sub getPopFreq() {
my($prbsetid, $ethnicity, $alleleAF, $alleleBF, $hetero, $alleleA, $alleleB, $dbSNPId, $snpId, $strandVsDbsnp);
my %popFreq;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(select distinct zpf.PROBE_SET_ID, zpf.ETHNICITY, zpf.ALLELE_A_FREQUENCY, zpf.ALLELE_B_FREQUENCY, zpf.HETEROZYGOUS_FREQUENCY, snp.ALLELE_A, snp.ALLELE_B, zsa.DBSNP_RS_ID, snp.ID SNP_ID, zsa.STRAND_VS_DBSNP from zstg_pop_frequency zpf, zstg_snp_affy zsa, snp_tv snp where zpf.PROBE_SET_ID = zsa.PROBE_SET_ID and zsa.DBSNP_RS_ID = snp.DB_SNP_ID);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$prbsetid, \$ethnicity, \$alleleAF, \$alleleBF, \$hetero, \$alleleA, \$alleleB, \$dbSNPId, \$snpId, \$strandVsDbsnp);
while($sth->fetch()) {
        $prbsetid=~s/\s+//g;
        $ethnicity=~s/\s+//g;
        $alleleAF=~s/\s+//g;
        $alleleBF=~s/\s+//g;
        $hetero=~s/\s+//g;
        $alleleA=~s/\s+//g;
        $alleleB=~s/\s+//g;
        $dbSNPId=~s/\s+//g;
        $snpId=~s/\s+//g;
        $strandVsDbsnp=~s/\s+//g;
        if($strandVsDbsnp eq 'same') {
           if($alleleAF > $alleleBF) {
         $popFreq{$prbsetid."|".$ethnicity."|".$alleleAF} = $prbsetid."|".$ethnicity."|".$alleleAF."|".$alleleBF."|".$hetero."|".$alleleA."|".$alleleB."|".$dbSNPId."|".$snpId."|".$strandVsDbsnp;	
         } else {
         $popFreq{$prbsetid."|".$ethnicity."|".$alleleBF} = $prbsetid."|".$ethnicity."|".$alleleBF."|".$alleleAF."|".$hetero."|".$alleleB."|".$alleleA."|".$dbSNPId."|".$snpId."|".$strandVsDbsnp;	
        }  
      }else {
           if($alleleAF > $alleleBF) {
         $popFreq{$prbsetid."|".$ethnicity."|".$alleleAF} = $prbsetid."|".$ethnicity."|".$alleleAF."|".$alleleBF."|".$hetero."|".$alleleB."|".$alleleA."|".$dbSNPId."|".$snpId."|".$strandVsDbsnp;	
         } else {
         $popFreq{$prbsetid."|".$ethnicity."|".$alleleBF} = $prbsetid."|".$ethnicity."|".$alleleBF."|".$alleleAF."|".$hetero."|".$alleleA."|".$alleleB."|".$dbSNPId."|".$snpId."|".$strandVsDbsnp;	
        }  
     } 
}
return \%popFreq;
}


close INFILE;

exit;
