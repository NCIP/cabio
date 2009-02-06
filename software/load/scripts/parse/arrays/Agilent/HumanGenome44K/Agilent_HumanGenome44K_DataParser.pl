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

my ($indir,$outdir) = getFullDataPaths('arrays/Agilent/HumanGenome44K');
my $input_file = "$indir/$input_file_name";
my $acc_file = "$outdir/accessions.dat";
my $phyloc_file = "$outdir/phyloc.dat";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (PHYLOCFILE, ">$phyloc_file") or die "Cannot open \"$phyloc_file\" \n\n";

<INFILE>; # skip header
my $physicalLocation;
my $cytoloc;
my @chrPhyLoc;
my ($startPhyloc, $endPhyloc);
my ($startCytloc, $endCytloc);
foreach my $line (<INFILE>) {

	chomp $line;
	$line =~s/\s+$//g;
    my @data = split("#", $line);
    my $probeId = $data[0];
    $physicalLocation = $data[12];
    if($#data == 13) {
    $cytoloc = $data[13];
    ($startCytloc, $endCytloc) = split('\|', $cytoloc);
    $startCytloc = $endCytloc;	
     }			 
    $physicalLocation =~s/^chr//g;
    @chrPhyLoc = split (':', $physicalLocation);
    ($startPhyloc, $endPhyloc) = split('-', $chrPhyLoc[1]);		 
    print PHYLOCFILE join("#",@data);
	if ($#data == 12) {
	print  PHYLOCFILE "#";
	}
    print PHYLOCFILE "#",$chrPhyLoc[0],"#",$startPhyloc,"#",$endPhyloc,"#",$startCytloc,"#",$endCytloc,"\n";

    @chrPhyLoc = ();
}

close INFILE;
close PHYLOCFILE;

exit;

