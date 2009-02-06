#!/usr/bin/perl

use strict;
use ParseUtils;

my $probe_set_id;
my $chromosome;
my $start;
my $end;
my $direction;
my @go_array;

my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];
my $assembly;
my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133_Plus2');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";
my @chrArr = ();
my @LineArr = ();
my $genechipname;
my $chrHash = &getChromosomes(5); 
my $chrId;
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
foreach my $line(<INFILE>) {
	chomp($line);
    if ($line =~ /\s+\/\/\/\s+/) {
        @LineArr = split("#", $line);
        $genechipname = $LineArr[1]; 
        @go_array = split("\/\/\/", $LineArr[0]);
        foreach my $new_line(@go_array) {
            if ($new_line =~ /^\s{0,}chr\S{1,}/) {
                (my $chromosome, my $start, my $end, my $direction) = 
                    ($new_line =~ /^\s{0,}chr(\S+):(\d+)-(\d+)\s\((\S{1})\)/);
		    if( ($chromosome =~/_/)&&(!(exists($chrHash->{$chromosome}))) ) {
		       @chrArr = split('_',$chromosome);
			 $assembly = $chromosome;
			 $chrId = "";
		    } else {
			 $chrArr[0] = $chromosome;
			 $assembly = 'reference';
			 $chrId = $chrHash->{$chromosome};
			}
                print OUTFILE "$go_array[0]|$chromosome|$start|$end|$direction|$chrArr[0]|$assembly|$genechipname|$chrId\n";    		
                @chrArr = ();
	    }
        }
    }
    elsif ($line =~ /\s+\/\/\s+/) {
        @LineArr = split("#", $line);
        $genechipname = $LineArr[1]; 
        @chrArr = ();
        (my $probe_set_id, my $chromosome, my $start, my $end, my $direction) = ($LineArr[0] =~ /^(.+)\/\/\/chr(\S+):(\d+)-(\d+)\s\((\S{1})\)/);
		    if( ($chromosome =~/_/)&&(!(exists($chrHash->{$chromosome}))) ) {
		       @chrArr = split('_',$chromosome);
			 $assembly = $chromosome;
			  $chrId = "";
		    } else {
			$chrArr[0] = $chromosome;
			 $assembly = 'reference';
			 $chrId = $chrHash->{$chromosome};
			}
	    print OUTFILE "$probe_set_id|$chromosome|$start|$end|$direction|$chrArr[0]|$assembly|$genechipname|$chrId\n";
            @chrArr = ();
	}
}

close INFILE;
close OUTFILE;

exit;
