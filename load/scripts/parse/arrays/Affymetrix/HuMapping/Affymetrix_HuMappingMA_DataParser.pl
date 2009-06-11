#!/usr/bin/perl
# 
# Parse a Affymetrix Mapping file and extract the Associated Gene information 
# for loading into the SNP_ASSOCIATED_GENE table.
#
# Author: Konrad Rokicki
# Date: 03/05/2007
#

use strict;
use ParseUtils;

my $input_file_name = $ARGV[0];
my $prefix = $input_file_name;
$prefix =~ s/\.annot\.csv$//;
my $arrayName = $ARGV[1]; 

my ($indir,$outdir) = getFullDataPaths("arrays/Affymetrix/$arrayName");
print "Indir is $indir and outdir is $outdir \n";
my $input_file = "$indir/$input_file_name";
my $pre_file = "$outdir/annotations_$prefix.dat";
my $sag_file = "$outdir/associated_gene_$prefix.dat";
my $pop_file = "$outdir/population_freq_$prefix.dat";
my $gm_file = "$outdir/genetic_map_$prefix.dat";
my $ms_file = "$outdir/microsatellite_$prefix.dat";
my $phylocfile = "$outdir/phyloc_$prefix.dat";

my $genomeVersion;
my $dbsnpVersion;

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (PREFILE, ">$pre_file") or die "Cannot open \"$pre_file\" \n\n";
open (SAGFILE, ">$sag_file") or die "Cannot open \"$sag_file\" \n\n";
open (POPFILE, ">$pop_file") or die "Cannot open \"$pop_file\" \n\n";
open (GMFILE, ">$gm_file") or die "Cannot open \"$gm_file\" \n\n";
open (MSFILE, ">$ms_file") or die "Cannot open \"$ms_file\" \n\n";
open (PHYLOCFILE, ">$phylocfile") or die "Cannot open \"$phylocfile\" \n\n";

foreach my $line (<INFILE>) {


	if($line =~/^\#\%genome-version-ncbi=(.*)$/) {
	 $genomeVersion = $1;
	}	
	if($line =~/^\#\%dbsnp-version=(.*)$/) {
	 $dbsnpVersion = $1;
	}	

    next unless ($line =~ /^\"?SNP/);

    my @data = split("\"\,\"", $line);

    my $probeId = $data[0];
    $probeId =~ s/\"//;
    
    # create prefixed data file
    $line =~ s/---\,/\,/g;
    print PREFILE "$genomeVersion,$dbsnpVersion,$prefix,$line";
#    print "$prefix,$line";


# Extract fields 3,4,7 for Chromosome, PhysicalPostion, Cytoband

    print PHYLOCFILE "$prefix,$probeId,$data[3],$data[4],$data[7]\n";
    # process gene associations
	$data[11] =~ s/---//g;
    if ($data[11]) {
	    my @associations = split("\/\/\/", $data[11]);
	    foreach my $association (@associations) {
	        my @fields = trim(split("\/\/", $association));
	        my ($accession, $relationship, $distance, $unigeneId, 
	            $geneSymbol, $ncbiGeneId, $geneDescription) = @fields;
	        my $out = "$probeId|$accession|$relationship|$distance|$unigeneId|$geneSymbol|$geneDescription\n";
	        print SAGFILE $out;
	    }
	}
	
    # process population frequency
    my %freq = processFreq($data[15]);
    my %hzyg = processHzyg($data[16]);
    my %eths = map { $_ => 1 } keys %freq, keys %hzyg;
    
    foreach my $eth (keys %eths) {
        print POPFILE "$probeId|$eth|$freq{$eth}|$hzyg{$eth}\n";
    }

	# process genetic map
	$data[12] =~ s/---//g;
	if ($data[12]) {
	    my @geneticmap = trim(split("\/\/\/", $data[12]));
		
		# deCODE
	    my ($distance, $markerId1, $markerId2, $markerName1, $markerName2) 
	    	= trim(split("\/\/", $geneticmap[0]));
		print GMFILE "$probeId|$distance|$markerId1||$markerId2||||deCODE\n";
		
		# Marshfield 
	    my ($distance, $markerId1, $markerId2, $markerName1, $markerName2) 
	    	= trim(split("\/\/", $geneticmap[1]));
		print GMFILE "$probeId|$distance|$markerId1|$markerName1|$markerId2|$markerName2|||Marshfield\n";
		
		# SLM1
	    my ($distance, $markerId1, $markerId2, $TSCid1, $TSCid2) 
	    	= trim(split("\/\/", $geneticmap[2]));
		print GMFILE "$probeId|$distance|$markerId1||$markerId2||$TSCid1|$TSCid2|SLM1\n";
	}
	
	# process microsatellite
	$data[13] =~ s/---//g;
	if ($data[13]) {
	    my @microsatellite = trim(split("\/\/\/", $data[13]));
		for my $ms (@microsatellite) {
	    	my ($marker, $position, $msdist) = trim(split("\/\/", $ms));
	        if ($marker && $position) {
				print MSFILE "$probeId|$msdist|$marker|$position\n";
			}
		}
	}
}

close INFILE;
close OUTFILE;

exit;

#
# Process a population frequency entry which may have
# data for more than one ethnicity.
#
sub processFreq {
    my $freq = shift;
    my @eths = split("\/\/\/",$freq);
    my %out = ();
    for my $eths (@eths) {
        my @fields = trim(split("\/\/", $eths));
        $out{$fields[2]} = "$fields[0]|$fields[1]"
    }
    return %out;
}

#
# Process a population frequency entry which may have
# data for more than one ethnicity.
#
sub processHzyg {
    my $freq = shift;
    my @eths = split("\/\/\/",$freq);
    my %out = ();
    for my $eths (@eths) {
        my @fields = trim(split("\/\/", $eths));
        $out{$fields[1]} = "$fields[0]"
    }
    return %out;
}

#
# Trim all the strings in the given array
#
sub trim {
    for my $string (@_) {
        $string =~ s/^\s+//;
        $string =~ s/\s+$//;
    }
	return @_;
}


