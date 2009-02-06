#!/usr/bin/perl

use strict;
use ParseUtils;

my $probe_set_id;
my $chromosome;
my $start;
my $end;
my $direction;
my @go_array;
my ($genechipname, @LineArr);
my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133_Plus2');
my $input_file = "$outdir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
#open (BAD, ">interproBad");  			
#open (GOOD, ">interproGood");
<INFILE>; # strip header
print "Indir is $indir Outdir is $outdir \n";  			
foreach (<INFILE>) {
        @LineArr = split("#", $_);
	$genechipname = $LineArr[1];	
	chomp($genechipname);
	$_ = $LineArr[0];
	chomp;
	my ($probeId, $interpro) = (/^(.*?)\/\/\/\s*(.*)\s*/);	
	my @domains = split /\s*\/\/\/\s*/,$interpro;
	
	for my $domain (@domains) {	
		my ($accession, $desc, $score) = split /\s*\/\/\s*/,$domain;
		$accession =~ s/---//;
		$desc =~ s/---//;
		$score =~ s/---//;
		if ($accession || $desc) {
			print OUTFILE "$probeId|$accession|$desc|$score|$genechipname\n";
#	           print GOOD "$_ &&&&& $probeId &&&&& $interpro \n"; 
		}else {
#	           print BAD "$_ &&&&& $probeId &&&&& $interpro \n"; 
               }
	}
}

close INFILE;
close OUTFILE;
#close BAD;
#close GOOD;
exit;
