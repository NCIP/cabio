#!/usr/bin/perl
use strict;
use ParseUtils;
use DBI;

#HGNC:24462      CLECL1  C-type lectin-like 1    DCAL1   12p13.31        160365

my ($indir,$outdir) = getFullDataPaths('unigene2gene');

my $input_file = "$indir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";
my @data;
my ($geneId, $symbol, $synonyms, @synArray);
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
open (BADFILE,">geneAlias_parser.bad") || die "Cannot open geneAlias_parser.bad \n\n";
open (LOGFILE,">geneAlias_parser.log") || die "Cannot open geneAlias_parser.log \n\n";
while (<INFILE>) {
 if($_ !~/^#/) {
 chomp;
 @data = split("\t",$_);
 $geneId = $data[5];
 $symbol = $data[1];
 $synonyms = $data[3];
 if($synonyms =~/,/) {
 @synArray = split(",",$synonyms);
   foreach (@synArray) {
   chomp;
   print OUTFILE "$geneId|$symbol|$_|HUGO\n";
   }
 @synArray=();  
} else {
#	if($_ =~/^HGNC:1628/) {
#		print "Shud come here $geneId|$symbol|$synonyms|HUGO\n";
#	}
   print OUTFILE "$geneId|$symbol|$synonyms|HUGO\n";
 }

 }
 @data=();
}
