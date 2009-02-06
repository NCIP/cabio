#!/usr/bin/perl
# 
# Parse the Agilent GeneList file and extract the Accession information 
# for loading into the ZSTG_CGH_ACCESSIONS table.
#
# Author: Konrad Rokicki
# Date: 04/17/2007
#

use strict;
use ParseUtils;

my $input_file_name = $ARGV[0];

my ($indir,$outdir) = getFullDataPaths('arrays/Agilent/aCGH244K');
my $input_file = "$indir/$input_file_name";
my $acc_file = "$outdir/accessions.dat";
my $phyloc_file = "$outdir/phyloc.dat";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (ACCFILE, ">$acc_file") or die "Cannot open \"$acc_file\" \n\n";
open (PHYLOCFILE, ">$phyloc_file") or die "Cannot open \"$phyloc_file\" \n\n";

<INFILE>; # skip header
my $physicalLocation;
my @chrPhyLoc;
my ($startPhyloc, $endPhyloc);
foreach my $line (<INFILE>) {

	chomp $line;
	$line =~s/\s+$//g;
    my @data = split("\t", $line);
    my $probeId = $data[0];
    $physicalLocation = $data[1];
    $physicalLocation =~s/^chr//g;
    @chrPhyLoc = split (':', $physicalLocation);
    ($startPhyloc, $endPhyloc) = split('-', $chrPhyLoc[1]);		 
    print PHYLOCFILE join("%|",@data, $chrPhyLoc[0],$startPhyloc,$endPhyloc),"\n";
    my @tokens = split("\\|", $data[4]);
    # process accessions
    my $source = '';
    my $i = 0;
    foreach my $token (@tokens) {
    	if (!$source) {
    		$source = $token;
    	}
    	else {	
	    	print ACCFILE "$probeId|$i|$source|$token\n";
	    	$source = '';
	    	$i++;
    	}
    }

   @chrPhyLoc = ();
}

close INFILE;
close ACCFILE;
close PHYLOCFILE;

exit;

