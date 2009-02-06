#!/usr/bin/perl

use strict;
use ParseUtils;

my $probe_set_id;
my $go_accession_number;
my $description;
my $evidence;
my @go_array;
my $genechipname;
my @LineArr;
my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133_Plus2');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";

foreach my $line(<INFILE>) {
    @LineArr = split("#", $line);
    $genechipname = $LineArr[1];	
	chomp($genechipname);
    if ($LineArr[0] =~ /\s+\/\/\/\s+/) {
        @go_array = split("\/\/\/", $LineArr[0]);
        foreach my $new_line(@go_array) {
            if ($new_line =~ /^\s{0,}(\d{1,})\s+\/\//) {
                (my $go_accession_number, my $description, my $evidence) = 
                    ($new_line =~ /^\s{0,}(\d{1,})\s+\/\/\s+(.+)\s+\/\/\s+(.+)/);
                $evidence =~ s/\s+$//;
                print OUTFILE "$go_array[0]|$go_accession_number|$description|$evidence|$genechipname\n"     		
            }
        }
    }
    elsif ($LineArr[0] =~ /\s+\/\/\s+/) {
        (my $probe_set_id, my $go_accession_number, my $description, my $evidence) = 
            ($LineArr[0] =~ /^(\d{1,}_\S{1,})\/\/\/(\d{1,})\s+\/\/\s+(.+)\s+\/\/\s+(.+)/);
        $evidence =~ s/\s+$//;
		if($go_accession_number !='') {
        print OUTFILE "$probe_set_id|$go_accession_number|$description|$evidence|$genechipname\n"
    		}
	}
}

close INFILE;
close OUTFILE;

exit;
