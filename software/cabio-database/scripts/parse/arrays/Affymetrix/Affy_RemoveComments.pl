#!/usr/bin/perl

use strict;
use ParseUtils;

my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];
my $directory = "arrays/Affymetrix/$ARGV[2]";

print "$directory\n";
my ($indir,$outdir) = getFullDataPaths($directory);
my $input_file = "$indir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";
print "$out_file\n";
open (INFILE, "<$input_file") or die "Cannot open infile \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open outfile \"$out_file\" \n\n";

foreach (<INFILE>) {
    print OUTFILE unless (/^#/);
}

close INFILE;
close OUTFILE;

exit;
