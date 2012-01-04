#!/usr/bin/perl
use strict;
use ParseUtils;

my ($indir, $outdir) = getFullDataPaths('cgdc');
chomp($ARGV[0]);

my ($inFile) = "$indir/$ARGV[0]";
my ($outFile) = "$indir/$ARGV[1]";
open (INFILE, "<$inFile") || die "Error opening $inFile \n";
open (OUTFILE,">$outFile") || die "Error opening $outFile \n";
my ($startTag, $endTag, $foundStart, $foundEnd, $tag);
$startTag ="";
$endTag ="";
$foundStart = 0;
$foundEnd = 0;
my $counter=0;
my @arr;
while(<INFILE>) {
 chomp $_;
 $_ =~s/^\s+//g;
 $_ =~s/\s+$//g;
 $_ =~s/[^ -~]//g;

 if($_ =~/<([A-Za-z]+)>/) {
 $startTag = $1;
 $startTag =~s/^\s+//g;
 $startTag =~s/\s+$//g;
 push(@arr, $1);
 }
 if($_ =~/<\/([A-Za-z]+)>/) {
 $endTag = $1;
 $endTag =~s/^\s+//g;
 $endTag =~s/\s+$//g;
 $foundEnd = 1;
 $tag = $arr[$#arr];
 } 
 if($tag ne $endTag) {
 print OUTFILE "<",$endTag,"/>\n";
 }
 else{
 print OUTFILE "$_\n";
 my $tmp;
 if($foundEnd) { 
 $tmp = pop(@arr);
 }
 if ($foundEnd) {
 $foundEnd = 0;
 }
 }
 $counter++;
}
