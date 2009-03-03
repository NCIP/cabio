#!/usr/bin/perl
# 
# Parse the Affymetrix Exon files.
#
# Author: Konrad Rokicki
# Date: 06/13/2007
#

use strict;
use ParseUtils;

my $prefix = $ARGV[0];
my $arrayName = $ARGV[1];

my ($indir,$outdir) = getFullDataPaths("arrays/Affymetrix/$arrayName");
my $probeset_infile = "$indir/$prefix.probeset.csv";
my $transcript_infile = "$indir/$prefix.transcript.csv";
my $probeset_outfile = "$outdir/$prefix.probeset.dat";
my $transcript_outfile = "$outdir/$prefix.transcript.dat";
my $gene_outfile = "$outdir/$prefix.genes.dat";

removeComments($probeset_infile, $probeset_outfile);
removeComments($transcript_infile, $transcript_outfile);
processGenes($transcript_infile, $gene_outfile);

exit;


sub removeComments {
    my $infile = shift;
    my $outfile = shift;
    
	open (INFILE, "<$infile") or die "Cannot open \"$infile\" \n\n";
	open (OUTFILE, ">$outfile") or die "Cannot open \"$outfile\" \n\n";

	while (<INFILE>) {
		s/"---"/""/g;
		unless (/^#/) {
			print OUTFILE;
		}
	}

	close INFILE;
	close OUTFILE;
}

sub processGenes {
    my $infile = shift;
    my $outfile = shift;
    
	open (INFILE, "<$infile") or die "Cannot open \"$infile\" \n\n";
	open (OUTFILE, ">$outfile") or die "Cannot open \"$outfile\" \n\n";

	while (<INFILE>) {
		my @values = split /","/;
		my $transcriptId = $values[0];
		$transcriptId =~ s/^"//;
		my @genes = split /\/\/\//,$values[10];
		my %genes = ();
		
		for my $gene (@genes) {
			my @gv = split /\/\//,$gene;
			my $clusterId = trim($gv[1]);
			$genes{$clusterId}++;
		}

		for my $clusterId (sort keys %genes) {
			print OUTFILE "$transcriptId|$clusterId\n" if ($clusterId);
		}
	}

	close INFILE;
	close OUTFILE;
}

#
# Trim the given string
#
sub trim {
    my $string = shift;
    $string =~ s/^\s+//;
    $string =~ s/\s+$//;
	return $string;
}

