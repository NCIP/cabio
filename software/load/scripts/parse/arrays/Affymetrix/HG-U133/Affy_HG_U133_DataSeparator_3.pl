#!/usr/bin/perl 

use strict;
use ParseUtils;

my $input_file_name = $ARGV[0];

my ($indir,$outdir) = getFullDataPaths('arrays/Affymetrix/HG-U133A');
my $input_file = "$indir/$input_file_name";
my $out_file01 = "$outdir/RNA_probesets_out_3.txt";
my $out_file02 = "$outdir/representative_public_ID_file_out_3.txt";
my $out_file03 = "$outdir/unigene_ID_file_out_3.txt";
my $out_file04 = "$outdir/alignments_file_out_3.txt";
my $out_file05 = "$outdir/gene_title_file_out_3.txt";
my $out_file06 = "$outdir/gene_symbol_file_out_3.txt";
my $out_file07 = "$outdir/chromosomal_location_file_out_3.txt";
my $out_file08 = "$outdir/entrez_gene_file_out_3.txt";
my $out_file09 = "$outdir/swissprot_file_out_3.txt";
my $out_file10 = "$outdir/EC_out_3.txt";
my $out_file11 = "$outdir/OMIM_file_out_3.txt";
my $out_file12 = "$outdir/refseq_protein_id_file_out_3.txt";
my $out_file13 = "$outdir/refseq_transcript_id_file_out_3.txt";
my $out_file14 = "$outdir/go_biological_process_file_out_3.txt";
my $out_file15 = "$outdir/go_cellular_component_file_out_3.txt";
my $out_file16 = "$outdir/go_molecular_function_file_out_3.txt";
my $out_file17 = "$outdir/pathway_file_out_3.txt";
my $out_file18 = "$outdir/interpro_file_out_3.txt";
my $out_file19 = "$outdir/ensembl_out_3.txt";

open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE01, ">$out_file01") or die "Cannot open \"$out_file01\" \n\n";
open (OUTFILE02, ">$out_file02") or die "Cannot open \"$out_file02\" \n\n";
open (OUTFILE03, ">$out_file03") or die "Cannot open \"$out_file03\" \n\n";
open (OUTFILE04, ">$out_file04") or die "Cannot open \"$out_file04\" \n\n";
open (OUTFILE05, ">$out_file05") or die "Cannot open \"$out_file05\" \n\n";
open (OUTFILE06, ">$out_file06") or die "Cannot open \"$out_file06\" \n\n";
open (OUTFILE07, ">$out_file07") or die "Cannot open \"$out_file07\" \n\n";
open (OUTFILE08, ">$out_file08") or die "Cannot open \"$out_file08\" \n\n";
open (OUTFILE09, ">$out_file09") or die "Cannot open \"$out_file09\" \n\n";
open (OUTFILE10, ">$out_file10") or die "Cannot open \"$out_file10\" \n\n";
open (OUTFILE11, ">$out_file11") or die "Cannot open \"$out_file11\" \n\n";
open (OUTFILE12, ">$out_file12") or die "Cannot open \"$out_file12\" \n\n";
open (OUTFILE13, ">$out_file13") or die "Cannot open \"$out_file13\" \n\n";
open (OUTFILE14, ">$out_file14") or die "Cannot open \"$out_file14\" \n\n";
open (OUTFILE15, ">$out_file15") or die "Cannot open \"$out_file15\" \n\n";
open (OUTFILE16, ">$out_file16") or die "Cannot open \"$out_file16\" \n\n";
open (OUTFILE17, ">$out_file17") or die "Cannot open \"$out_file17\" \n\n";
open (OUTFILE18, ">$out_file18") or die "Cannot open \"$out_file18\" \n\n";
open (OUTFILE19, ">$out_file19") or die "Cannot open \"$out_file19\" \n\n";

foreach my $line (<INFILE>) {
	chomp $line;
    my @data = split("\"\,\"", $line);
    $data[0] =~ s/\"//;
    print OUTFILE01 "$data[0]|$data[1]|$data[2]|$data[3]\n";
    print OUTFILE02 "$data[0]///$data[8]#$data[1]\n";
    print OUTFILE03 "$data[0]///$data[10]#$data[1]\n";
    print OUTFILE04 "$data[0]///$data[12]#$data[1]\n";
    print OUTFILE05 "$data[0]///$data[13]#$data[1]\n";
    print OUTFILE06 "$data[0]///$data[14]#$data[1]\n";
    print OUTFILE07 "$data[0]///$data[15]#$data[1]\n";
    print OUTFILE08 "$data[0]///$data[18]#$data[1]\n";
    print OUTFILE09 "$data[0]///$data[19]#$data[1]\n";
    print OUTFILE11 "$data[0]///$data[21]#$data[1]\n";
    print OUTFILE12 "$data[0]///$data[22]#$data[1]\n";
    print OUTFILE13 "$data[0]///$data[23]#$data[1]\n";
    print OUTFILE14 "$data[0]///$data[30]#$data[1]\n";
    print OUTFILE15 "$data[0]///$data[31]#$data[1]\n";
    print OUTFILE16 "$data[0]///$data[32]#$data[1]\n";
    print OUTFILE17 "$data[0]///$data[33]#$data[1]\n";
    print OUTFILE18 "$data[0]///$data[34]#$data[1]\n";
    
    # Ensembl 
	$data[17] =~ s/---//g;
    my @ensembles = split /\s*\/\/\/\s*/,$data[17];
    for my $ensemble (@ensembles) {
    	print OUTFILE19 "$data[0]|$ensemble|$data[1]\n" if ($ensemble);
    }
    
    # EC 
	$data[20] =~ s/---//g;
    my @ecs = split /\s*\/\/\/\s*/,$data[20];
    for my $ec (@ecs) {
    	print OUTFILE10 "$data[0]|$ec|$data[1]\n" if ($ec);
    }
    
    
}

close INFILE;
close OUTFILE01;
close OUTFILE02;
close OUTFILE03;
close OUTFILE04;
close OUTFILE05;
close OUTFILE06;
close OUTFILE07;
close OUTFILE08;
close OUTFILE09;
close OUTFILE10;
close OUTFILE11;
close OUTFILE12;
close OUTFILE13;
close OUTFILE14;
close OUTFILE15;
close OUTFILE16;
close OUTFILE17;
close OUTFILE18;

exit;
