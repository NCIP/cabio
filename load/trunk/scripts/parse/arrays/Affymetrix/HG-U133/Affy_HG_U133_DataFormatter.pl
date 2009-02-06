#!/usr/bin/perl

use strict;
use ParseUtils;

my $probe_set_id;
my $general_id;
my @go_array;

my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";
my $log_file = "$outdir/$ARGV[2]";
my (@LineArr, $genechipname);
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
open (LOGFILE, ">$log_file") or die "Cannot open \"$out_file\" \n\n";
  			
foreach my $line (<INFILE>) {
     chomp $line;
     @LineArr = split("#", $line);
     $genechipname = $LineArr[1];	 
    if ($LineArr[0] =~ /\/\/\/---/) {
        # print "The following line do not contain any data. \n";
        print LOGFILE "$line \n";
    }
    elsif ($LineArr[0] =~ /\s+\/\/\/\s+/) {
        @go_array = split("\/\/\/", $LineArr[0]);
        my $i = 0;
        foreach my $new_line(@go_array) {
            while ($i < $#go_array) {
                $i = $i + 1;
                $go_array[$i] =~ s/^\s+//;
                $go_array[$i] =~ s/\s+$//;
                print OUTFILE "$go_array[0]|$go_array[$i]|$genechipname\n";
            }
        }
    }
    elsif ($LineArr[0] =~ /\/\/\//) {
        (my $probe_set_id, my $general_id) = ($LineArr[0] =~ /^(.+)\/\/\/(.+)/);
        $general_id =~ s/\s+$//;
        print OUTFILE "$probe_set_id|$general_id|$genechipname\n"
    }
}

close INFILE;
close OUTFILE;
close LOGFILE;

exit;
