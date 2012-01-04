#!/usr/bin/perl

use strict;


my $inFile = $ARGV[0];
my $outFile = $ARGV[1];


$inFile = "$ENV{'CABIO_DATA_DIR'}/mergedSNPids/$ARGV[0]";
my $outFile = "$ENV{'CABIO_DATA_DIR'}/mergedSNPids/$ARGV[1]";


open (INFILE, "<$inFile") or die "Cannot open \"$inFile\" \n\n";
open (OUTFILE, ">$outFile") or die "Cannot open \"$outFile\" \n\n";

my @RsIdsLineData; 
  			
foreach my $line (<INFILE>) {
 		chomp($line);
 		#$line =~s/\t/#/g;
 		@RsIdsLineData = split('\t', $line);	
        
		$RsIdsLineData[0] = "rs".$RsIdsLineData[0];
		$RsIdsLineData[1] = "rs".$RsIdsLineData[1];
		$RsIdsLineData[6] = "rs".$RsIdsLineData[6];		
		&trim(\@RsIdsLineData);
        print OUTFILE join("\t",@RsIdsLineData),"\n";
}

close INFILE;
close OUTFILE;


sub trim() {
	my $arrRef = shift || die "This function needs a reference to an array whose contents need to be trimmed! \n";
	foreach my $field (@$arrRef) {
		$field =~s/^\s+//g;
		$field =~s/\s+$//g;
	}
}

exit;
