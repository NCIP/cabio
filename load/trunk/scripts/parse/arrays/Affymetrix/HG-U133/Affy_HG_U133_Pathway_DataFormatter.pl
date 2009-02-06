#!/usr/bin/perl

use strict;
use ParseUtils;

my $probe_set_id;
my $reference;
my $pathway;
my @go_array;
my ($genechipname, @LineArr);
my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";

foreach my $line(<INFILE>) {
        @LineArr = split("#", $line);
	$genechipname = $LineArr[1];
	chomp($genechipname);
	$line = $LineArr[0];
    if ($line =~ /\s+\/\/\/\s+/) {
        @go_array = split("\/\/\/", $line);
        foreach my $new_line(@go_array) {
            if ($new_line =~ /\/\//) {
                (my $pathway, my $reference) = ($new_line =~ /^\s{0,}(.+)\s+\/\/\s+(.+)\s{0,}$/);
                $pathway =~ s/\s+$//;
                print OUTFILE "$go_array[0]|$pathway|$reference|$genechipname\n";     		
            }
        }
    }
    elsif ($line =~ /^(.+)\/\/\/(.+)\/\/\s+(.+)/) {
        (my $probe_set_id, my $pathway, $reference) = 
            ($line =~ /^(.+)\/\/\/(.+)\/\/\s+(.+)/);
        $pathway =~ s/\s+$//;
    print OUTFILE "$probe_set_id|$pathway|$reference|$genechipname\n";
    }
}

close INFILE;
close OUTFILE;

exit;
