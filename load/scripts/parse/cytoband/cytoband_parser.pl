#!/usr/bin/perl

use strict;
use ParseUtils;
use DBI;

my $in_file = $ARGV[0];
my $o_file = $ARGV[1];
my $taxonId = $ARGV[2];

my ($indir,$outdir) = getFullDataPaths('cytoband');
my $input_file = "$indir/$in_file";
my $out_file = "$outdir/$o_file";

my $parsedLineCount=0;
my $LineCount=0;
my $incompleteDataCount=0;
my($chrom, $start, $end, $cytoname, $stain, $chrNo, $chrId);	
my $chrHash = &getChromosomes($taxonId); 
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
open (BADFILE,">>cytoband_parser.bad") || die "Cannot open cytoband_parser.bad \n\n";
open (LOGFILE,">>cytoband_parser.log") || die "Cannot open cytoband_parser.log \n\n";

while (<INFILE>) {
	$LineCount++;
	chomp($_);
        $_ =~s/\t/#/g; 
        $_ =~s/\./_/g; 
        ($chrom, $start, $end, $cytoname, $stain) = split('#');	
        $chrNo = $chrom;
	$chrNo =~s/chr//g;
                       
	$chrId =$chrHash->{$chrNo}; 
		
	if ((!$chrom) || ($start eq '') || ($end eq '') || (!$cytoname) || (!$stain) || ($chrNo eq '')){
	$incompleteDataCount++;
	print BADFILE "$_\n";	
	print "$_\n";	
	}
        else { 
	$parsedLineCount++;
	$cytoname =~s/_/\./g;
        print OUTFILE "$chrom	$start	$end	$cytoname	$stain	$chrNo	$chrId	".$chrNo.$cytoname."	\n";
		} 
}

print LOGFILE "Data Source: Cytoband Data in $input_file\n";
print LOGFILE "Number of records in raw data: $LineCount\n";
print LOGFILE "Number of records written to $out_file: $parsedLineCount\n";
print LOGFILE "Number of incomplete/bad records in $input_file: $incompleteDataCount\n";
print LOGFILE "\n\n\n";

close INFILE;
close OUTFILE;
close LOGFILE;
close BADFILE;

exit;
