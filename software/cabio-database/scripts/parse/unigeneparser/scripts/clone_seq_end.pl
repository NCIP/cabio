#!/usr/bin/perl
# script for generating clone_seq_end.dat
# Author: Sue Pan
# Date: 08/29/2012

use strict;
use ParseUtils;

my ($indir, $outdir)=getFullDataPaths("ncbi_unigene");
my $cluster_file_human="$indir/Hs.data";
my $cluster_file_mouse="$indir/Mm.data";
my $clone_file="$indir/clone.dat";
my $seq_file="$indir/sequence.dat";
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

#generate clone_seq_end.dat from the Hs.data and Mm.data file
print "Writing $out_file\n";
open(OUT, ">$out_file") or die;

open (IN, $cluster_file_human) or die;
while (<IN>) {
  chomp;
  #parse SEQUENCE lines with END= && SEQTYPE=EST only
  if ((my ($line)=(/^SEQUENCE +(.+)/)) && /END=/ && /SEQTYPE=EST/) {
     my @fields=split(/; /, $line);
     my ($acc, $seq_id, $clone_name, $lid, $clone_id, $end);
     for my $field (@fields) {
       if ($field=~/^ACC=(.+)\.(\d+)$/) { 
         $acc=$1;
         next;
       }
       if ($field=~/^CLONE=(.+)/) {
         $clone_name=$1;
         next;
       }
       if ($field=~/^LID=(.+)/) {
         $lid=$1;
         next;
       }
       if ($field=~/^END=(.+)/) {
         $end=$1;
         next;
       }
     }
     # assign unknown clone
     if (!defined $clone_name) {
        $clone_name="unknown"; 
     }
     my $clone_id=$clone_map{"$clone_name/$lid"};
     my $seq_id=$seq_map{$acc};

     print OUT "$clone_id%|$seq_id%|$end%|\n";
  }
}
close IN;

open (IN, $cluster_file_mouse) or die;
while (<IN>) {
  chomp;
  #parse SEQUENCE lines with END= && SEQTYPE=EST only
  if ((my ($line)=(/^SEQUENCE +(.+)/)) && /END=/ && /SEQTYPE=EST/) {
     my @fields=split(/; /, $line);
     my ($acc, $seq_id, $clone_name, $lid, $clone_id, $end);
     for my $field (@fields) {
       if ($field=~/^ACC=(.+)\.(\d+)$/) {
         $acc=$1;
         next;
       }
       if ($field=~/^CLONE=(.+)/) {
         $clone_name=$1;
         next;
       }
       if ($field=~/^LID=(.+)/) {
         $lid=$1;
         next;
       }
       if ($field=~/^END=(.+)/) {
         $end=$1;
         next;
       }
     }
     # assign unknown clone
     if (!defined $clone_name) {
        $clone_name="unknown";
     }
     my $clone_id=$clone_map{"$clone_name/$lid"};
     my $seq_id=$seq_map{$acc};
 
     print OUT "$clone_id%|$seq_id%|$end%|\n";
  }
}
close IN;

close OUT; 
