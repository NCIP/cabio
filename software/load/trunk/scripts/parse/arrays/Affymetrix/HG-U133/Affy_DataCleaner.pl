#!/usr/bin/perl

use strict;
use ParseUtils;

my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";

foreach my $line (<INFILE>) {
    $line =~ s/---//g;
    print OUTFILE "$line";
}

close INFILE;
close OUTFILE;

exit;
