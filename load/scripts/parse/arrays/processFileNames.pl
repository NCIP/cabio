#!/usr/bin/perl 
#
# This script processes array annotation filenames. It accomplishes the following:
#
# * Creates links in the output directory to files in the input directory. 
#   Links do not have netaffx version ("na28") or the genome version ("hg18") 
#   in their filenames.
#
# * Propagates only the latest netaffx versions of files. For example, if the 
#   input directory contains:
#       HG-U133_Plus_2.na27.annot.csv
#       HG-U133_Plus_2.na28.annot.csv
#   then only the second file will be linked from the output directory as:
#       HG-U133_Plus_2.annot.csv
#
# * Creates an array versions datafile with the latest version for each array,
#   which is later loaded into a staging table for population in the Microarray 
#   object.
#
# Author: Konrad Rokicki
# Date: 04/08/2009
#

use strict;
use ParseUtils;
use File::Path;

my $VERSION_FILE = 'microarray_versions.txt';

my %SUBDIRS = (

    'HG-U133_Plus_2' => 'HG-U133_Plus2',
    
    'HG-U133A' => 'HG-U133A',
    'HG-U133A_2' => 'HG-U133A',
    'HT_HG-U133A' => 'HG-U133A',
    
    'Mapping50K_Hind240' => 'HuMapping',
    'Mapping50K_Xba240' => 'HuMapping',
    'Mapping250K_Sty' => 'HuMapping',
    'Mapping250K_Nsp' => 'HuMapping',
    
    'HG_U95A' => 'HG-U95',
    'HG_U95Av2' => 'HG-U95',
    'HG_U95B' => 'HG-U95',
    'HG_U95C' => 'HG-U95',
    'HG_U95D' => 'HG-U95',
    
    'HT_HG-U133B' => 'U133B',
    'HG-U133B' => 'U133B',
    
    'Hu6800' => 'Hu6800',
    
    'HuEx-1_0-st-v2' => 'HuEx10ST'
);

print "Processing Affymetrix array annotation files\n";

my $indir = getFullDataPath("arrays/Affymetrix");
print "**Input directory: $indir\n";

my %fileVersions = ();
foreach my $file (glob("$indir/*.csv")) {
    print $file,"\n";
    # parse the affymetrix filename
    my ($prefix,$version,$suffix,$annot) 
        = ($file =~ /\/([^\/]+?)\.na(\d+)\.?([^\/]+)?\.csv/);
    
    # remove human genome version from the suffix
    $suffix =~ s/hg\d+\.//;

    $fileVersions{"$prefix||$suffix"}{$version} = $file;
}

my %arrayVersions = ();
foreach my $key (keys %fileVersions) {

    # determine latest version
    my @filevers = sort keys %{$fileVersions{$key}};
    my $latest = $filevers[$#filevers];
    my ($prefix,$suffix) = split /\|\|/, $key;
    $arrayVersions{$prefix} =  $latest;
    
    # determine output directory
    my $subdir = $SUBDIRS{$prefix} || "unknown";
    my $outdir = "$indir/$subdir";
    mkpath $outdir;
    
    # create symbolic link
    my $from = $fileVersions{$key}{$latest};
    my $to = "$outdir/$prefix.$suffix.csv";
    print "Linking $from <- $subdir/$prefix.$suffix.csv\n";
    `ln -sf $from $to`;
}

print "Creating array annotation versions datafile\n";

my ($indir,$outdir) = getFullDataPaths("arrays");
print "Input directory: $indir\n";
print "Output directory: $outdir\n";

print "Creating $VERSION_FILE\n";

open(OUT, ">$outdir/$VERSION_FILE") or die "Cannot open output file: $!\n";
foreach my $key (keys %arrayVersions) {
    print OUT "$key|$arrayVersions{$key}\n";   
}

close OUT;


