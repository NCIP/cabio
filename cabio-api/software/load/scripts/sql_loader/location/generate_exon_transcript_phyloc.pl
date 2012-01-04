#!/usr/bin/perl

use strict;
use ParseUtils;
use DBI;

my $o_file1 = "phylocExon.txt";
my $o_file2 = "phylocTranscript.txt";

my ($indir,$outdir) = getFullDataPaths('exon');
my $out_file1 = "$outdir/$o_file1";
my ($indir,$outdir) = getFullDataPaths('transcript');
my $out_file2 = "$outdir/$o_file2";
print "Getting exon phyloc \n";
my $exonPhyLocHash = &getExonLoc(); 
print "Getting transcript phyloc  \n";
my $transcriptPhyLoc = &getXscriptPhyloc(); 
print "Finished getting all the relevant data \n";
open (FILE1,">$out_file1") || die "Cannot open $out_file1 \n\n";
open (FILE2,">$out_file2") || die "Cannot open $out_file2 \n\n";
my ($acNumber, $st, $cytName);

foreach my $ky (keys %$transcriptPhyLoc) {
   print FILE2 "$ky|$transcriptPhyLoc->{$ky}\n";
}
close FILE2;

foreach my $ky (keys %$exonPhyLocHash) {
   print FILE1 "$ky|$exonPhyLocHash->{$ky}\n";
}
close FILE1;

sub getExonLoc() {
my($exonrepid, $chrid, $startloc, $endloc);
my %exonPhyLocHash;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq( select r.ID exon_reporter_ID, c.chromosome_ID, z.START_LOCATION, z.STOP_LOCATION from zstg_exon_affy z, exon_reporter r, CHROMOSOME c where z.PROBE_SET_ID = r.NAME and SUBSTR(z.SEQNAME,4) = c.CHROMOSOME_NUMBER (+) and c.taxon_ID = 5);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$exonrepid, \$chrid, \$startloc, \$endloc);
while($sth->fetch()) {
        $exonrepid=~s/\s+//g;
        $chrid=~s/\s+//g;
        $startloc=~s/\s+//g;
        $endloc=~s/\s+//g;
        $exonPhyLocHash{$exonrepid."|".$chrid."|".$startloc} = $exonrepid."|".$chrid."|".$startloc."|".$endloc;
}
return \%exonPhyLocHash;
}


sub getXscriptPhyloc() {
my($transcriptId, $chrid, $startloc, $endloc);
my %transcriptPhyLoc;
my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
my $sql = qq(select t.ID transcript_ID, c.chromosome_ID, z.START_LOCATION, z.STOP_LOCATION from zstg_exon_trans_affy z, TRANSCRIPT t, CHROMOSOME c where z.TRANSCRIPT_CLUSTER_ID = t.MANUFACTURER_ID and SUBSTR(z.SEQNAME,4) = c.CHROMOSOME_NUMBER(+) and c.taxon_ID = 5);
my $sth = $dbh->prepare($sql);
$sth->execute();
$sth->bind_columns(\$transcriptId, \$chrid, \$startloc, \$endloc);
while($sth->fetch()) {
        $transcriptId=~s/\s+//g;
        $chrid=~s/\s+//g;
        $startloc=~s/\s+//g;
        $endloc=~s/\s+//g;
        $transcriptPhyLoc{$transcriptId."|".$chrid."|".$startloc} = $transcriptId."|".$chrid."|".$startloc."|".$endloc;
}
return \%transcriptPhyLoc;
}

close INFILE;

exit;
