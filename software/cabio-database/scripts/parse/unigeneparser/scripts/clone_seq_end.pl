#!/usr/bin/perl
# script for generating clone_seq_end.dat
# Author: Sue Pan
# Date: 08/29/2012

use strict;
use ParseUtils;

my ($indir, $outdir)=getFullDataPaths("ncbi_unigene");
my $clone_file="$indir/clone.dat";
my $seq_file="$indir/sequence.dat";
my $clone_seq_end_tmp_file="$indir/clone_seq_end_tmp.dat";
my $out_file="$indir/clone_seq_end.dat";

#generate clone hash
print "Reading $clone_file\n";
my %clone_map=();
open(IN, $clone_file) or die;
while(<IN>) {
   my @fields=split/%\|/; 
   $clone_map{"$fields[2]/$fields[3]"}=$fields[1];
}
close IN;

#generate sequence hash
print "Reading $seq_file\n";
my %seq_map=();
open(IN, $seq_file) or die;
while (<IN>) {
  my @fields=split/%\|/;  
  $seq_map{$fields[1]}=$fields[0];
}
close IN;

#generate clone_seq_end.dat from the tmp file
print "Writing $out_file\n";
open(OUT, ">$out_file") or die;
open(IN, $clone_seq_end_tmp_file) or die;
while (<IN>) {
   my @fields=split/%\|/;
   chomp(@fields);
   my $clone_id=$clone_map{$fields[0]};
   # trim out the version number from the accession
   my ($seq_acc, $seq_version)=($fields[1]=~/^(.+)\.(\d+)$/s); 
   my $seq_id=$seq_map{$seq_acc};
   my $end=$fields[2];
   print OUT "$clone_id%|$seq_id%|$end%|\n";
}
close IN;
close OUT; 
#unlink $clone_seq_end_tmp_file;
