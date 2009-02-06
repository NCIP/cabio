#!/usr/bin/perl
use ParseUtils;

#Unique ID      Primer1 Primer2 Size(bp)        Name    chr     Accession       Orga

my ($indir,$outdir) = getFullDataPaths('marker');
die "No input file specified" unless length($ARGV[0])> 0; 
print "INPUT FILE IS $ARGV[0]\n";
my $infile = $indir."/".$ARGV[0];
my $outfile = $outdir."/".$ARGV[0].".out";
my @data;

open (FH, "<$infile") || die "Error opening file $infile \n";
open (OUT_FH, ">$outfile") || die "Error opening file $outfile \n";
open (DISCARD, ">$outfile.discard") || die "Error opening file $outfile".".discard \n";

while (<FH>) {
 chomp($_);
 @data = split("	",$_);
 if ( ($data[7] =~/^Homo/) || ($data[7] =~/^Mus /) )  {
 print OUT_FH "$data[0]|$data[4]|$data[5]|$data[7]\n";
    } else {
 print DISCARD "$data[0]|$data[4]|$data[5]|$data[7]\n";
	}	
@data = (); 
}

close OUT_FH;
close FH;
close DISCARD;
