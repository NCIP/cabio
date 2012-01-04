#!/usr/bin/perl
use strict;
use ParseUtils;
use DBI;

my ($chrInContig, $chrNumberInLineBeingInserted);
my ($indir,$outdir) = getFullDataPaths('unigene2gene');

my $input_file = "$indir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";
my @data;
my @symArr;
my ($geneId, $symbol, $synonyms, @synArray);
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
open (BADFILE,">geneAlias_parser.bad") || die "Cannot open geneAlias_parser.bad \n\n";
open (LOGFILE,">geneAlias_parser.log") || die "Cannot open geneAlias_parser.log \n\n";
print OUTFILE "geneId|symb|synonyms|ENTREZ\n";
while (<INFILE>) {
 #print "$_ \n";
 if($_ !~/^#/) {
 chomp;
 @data = split("\t",$_);
 $geneId = $data[1];
 $symbol = $data[2];
 $synonyms = $data[4];
 
 if($symbol =~/\|/) {
 @symArr = split(/\|/,$symbol);
 } else {
  $symArr[0] = $symbol;
 }	

 if($synonyms =~/\|/) {
 @synArray = split(/\|/,$synonyms);
   foreach (@synArray) {
    foreach my $symb (@symArr) {
   	print OUTFILE "$geneId|$symb|$_|ENTREZ\n";
    }	
   }
 @synArray=(); 
 @symArr = (); 
} elsif ($synonyms ne "-") {
    foreach my $symb (@symArr) {
   	print OUTFILE "$geneId|$symb|$synonyms|ENTREZ\n";
    }	
 }

 }
 @data=();
}
