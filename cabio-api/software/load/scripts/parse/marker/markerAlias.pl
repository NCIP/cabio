#!/usr/bin/perl
use ParseUtils;

my ($indir,$outdir) = getFullDataPaths('marker');
die "No input file specified" unless length($ARGV[0])> 0; 
print "iNPUT FILE IS $ARGV[0]\n";
my $infile = $indir."/".$ARGV[0];
my $outfile = $outdir."/".$ARGV[0];
my ($unistsId, @alias);
open (FH, "<$infile") || die "Error opening file $infile \n";
open (OUT_FH, ">$outfile") || die "Error opening file $outfile \n";
while (<FH>) {
 chomp($_);
($unistsId, $aliasString) = split ("	", $_);
@alias = split(";", $aliasString);
foreach (@alias) {
 print OUT_FH "$unistsId|$_\n";
 }
@alias = (); 
}
close OUT_FH;
close FH;
