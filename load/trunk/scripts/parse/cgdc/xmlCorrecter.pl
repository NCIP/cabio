#!/usr/bin/perl
use strict;
use ParseUtils;

my ($indir, $outdir) = getFullDataPaths('cgdc');
chomp($ARGV[0]);

my ($inFile) = "$indir/$ARGV[0]";
my ($outFile) = "$indir/$ARGV[1]";
open (INFILE, "<:utf8", "$inFile") || die "Error opening $inFile \n";
open (OUTFILE,">:utf8", "$outFile") || die "Error opening $outFile \n";
my ($startTag, $endTag, $foundStart, $foundEnd, $tag);
$startTag ="";
$endTag ="";
$foundStart = 0;
$foundEnd = 0;
my @arr;
while(<INFILE>) {
 chomp $_;
 $_ =~s/^\s+//g;
 $_ =~s/\s+$//g;

 if($_ =~/<([A-Za-z]+)>/) {
 $startTag = $1;
 $startTag =~s/^\s+//g;
 $startTag =~s/\s+$//g;
# print "FOUND START TAG $startTag $_\n";
 push(@arr, $1);
 }
 if($_ =~/<\/([A-Za-z]+)>/) {
 $endTag = $1;
 $endTag =~s/^\s+//g;
 $endTag =~s/\s+$//g;
 $foundEnd = 1;
 $tag = $arr[$#arr];
# print "FOUND END TAG $endTag **$tag** $_\n";
 } 
 if($tag ne $endTag) {
# print "DIDNT MATCH DIDNT MATCH \n";
 print OUTFILE "<",$endTag,"/>\n";
 #print "<",$endTag,"/>\n"; 
 }
 else{
 print OUTFILE "$_\n";
 my $tmp;
 if($foundEnd) { 
 $tmp = pop(@arr);
 }
 #print "$_ ";
  if ($foundEnd) {
 # print "popped out $tmp";
 $foundEnd = 0;
  }
 #print "\n";

 }
}
