#!/usr/bin/perl -w

use strict;
use ParseUtils;

# find the file in source directory with the latest update time (mtime)

my ($indir,$outdir) = getFullDataPaths('image_clone');

#open source directory
opendir(INDIR,$indir) or die "Couldn't open directory $indir ($!)\n";
#list of files in source_directory
my @files = readdir(INDIR);
closedir(INDIR);

#open target directory
opendir(OUTDIR,"$outdir") or die "Couldn't open directory $outdir ($!)\n";
#list of files in source_directory
my @outdir_files = readdir(OUTDIR);
closedir(OUTDIR);

shift @files;
shift @files;

#shift @outdir_files;
#shift @outdir_files;

# print "@files\n";
# print "@outdir_files \n";

#sort to find newest file
my @timesort = sort { -M "$indir/$b" <=> -M "$indir/$a" } @files;
my $newest_file = $timesort[-1];

my $cp = "cp $indir/$newest_file $outdir";
system ($cp);

my @go_array;
my @go_array_01;

my $input_file = "$outdir/$newest_file";
my $out_file = "$outdir/cumulative_arrayed_plates.out";
my $log_file = "IMAGE_CLONE_parser.log";
my $bad_file = "IMAGE_CLONE_parser.bad";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
open (LOGFILE, ">$log_file") or die "Cannot open \"$log_file\" \n\n";
open (BADFILE, ">$bad_file") or die "Cannot open \"$bad_file\" \n\n";
#QA deliverables
my $parsedRecords=0;            
my $badRecords=0;            
my $rawData=0;

foreach my $line (<INFILE>) {
$rawData++;
    if ($line =~ /[A-Z]{1,}\d{1,}/) {
        @go_array = split("\t", $line);
        if ($line =~ /[A-Z]{1,}\d{1,}\s{1,}[A-Z]{1,}\d{1,}/) {
            $go_array[7] =~ s/\s{1,}/,/g;
            @go_array_01 = split("\,", $go_array[7]);
            my $i = -1;
            foreach my $new_line(@go_array_01) {
                while ($i < $#go_array_01) {
                    $i = $i + 1;
                    $go_array_01[$i] =~ s/^\s+//;
                    $go_array_01[$i] =~ s/\s+$//;
                    print OUTFILE "$go_array[0]|$go_array[5]|$go_array[6]|$go_array_01[$i]\n";
                }
            }
        }
        else {
            print OUTFILE "$go_array[0]|$go_array[5]|$go_array[6]|$go_array[7]";
        }
        $parsedRecords++; 
    }
    elsif ($line =~ /[A-Z]{1,}/) {
        @go_array = split("\t", $line);
        my $i = 0;            
        print OUTFILE "$go_array[0]|$go_array[5]|$go_array[6]\n";
        $parsedRecords++; 
    }
    else {
     $badRecords++;
     print BADFILE $line; 
    }	
}
print LOGFILE "Data Source: IMAGE Consortium Clone Data\n";
print LOGFILE "Number of records in $input_file: $parsedRecords\n";
print LOGFILE "Number of records written to $out_file: $parsedRecords\n";
print LOGFILE "Number of skipped records: $badRecords\n";
close INFILE;
close OUTFILE;
close BADFILE;
close LOGFILE;
exit(0);
