#!/usr/bin/perl
use strict;
use ParseUtils;
use DBI;

my $rs_ID;
my $species_name;
my $allele_a;
my $allele_b;
my $validated_status;
my %multilocs;
my ($location, $locationInContig);
my $id;
my $input_file_name = $ARGV[0];
my $out_file_name = $ARGV[1];
my $chromosome_number = $ARGV[2];

my ($lineBeingInserted, $line);
my ($chrInContig, $chrNumberInLineBeingInserted);
my ($indir,$outdir) = getFullDataPaths('NCBI_SNP');
my $assemblySrc;
my $ambiguousChrAssignmentinRefContig;	
my($celeraContig, $refContig);
my ($refContigCount, $celeraContigCount, $chrInRefContig, $chrInCelContig);
my $input_file = "$indir/$ARGV[0]";
my $out_file = "$outdir/$ARGV[1]";
my $ref_file = "$outdir/$ARGV[1].ref";
my $phyloc_file = "$outdir/$ARGV[1].phyloc";
my ($chrTmp,$assemblyTmp, $locTmp);
my $rsLineCount=0;
my $parsedLineCount=0;
my $incompleteRsIdsCount=0;
my $InvalidAlleleDataCount=0;
my $invalidCtgCount=0;
my $chromosomeFile=$input_file_name;
my $refLine = "http://www.ncbi.nlm.nih.gov/projects/SNP/snp_ref.cgi?searchType=adhoc_search&type=rs&rs=";
$chromosomeFile =~s/\.txt//g;
my $chrHash = &getChromosomes(5); 
my ($rsIdPresent, $allelePresent, $valPresent, $ctgPresent);
$/ = "\n\n";
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (OUTFILE, ">$out_file") or die "Cannot open \"$out_file\" \n\n";
open (REFFILE, ">$ref_file") or die "Cannot open \"$ref_file\" \n\n";
open (PHYLOCFILE, ">$phyloc_file") or die "Cannot open \"$phyloc_file\" \n\n";
open (BADFILE,">NCBI_SNP_parser.bad") || die "Cannot open NCBI_SNP_parser.bad \n\n";
open (LOGFILE,">>NCBI_SNP_parser.log") || die "Cannot open NCBI_SNP_parser.log \n\n";

if($chromosome_number ne '1') {
open (fhandle, "<idHandle.txt") || die "error opening tmp.txt \n";
while (<fhandle>) {
 $id = $_;
 chomp($id);
 $id =~s/\s+//g;
}
close fhandle;
} else {
	$id = 1;
}
print "Finished reading file $id\n";
while (<INFILE>) {

    if (/^rs/) {
	$rsLineCount++;
        my @block = split "\n";
	$refContigCount=0;
	$celeraContigCount=0;
      	$refContig="";
	$celeraContig ="";
	$chrInRefContig = "";
	$chrInCelContig = "";
	$ambiguousChrAssignmentinRefContig = 0;	
          $rsIdPresent=0;   
          $allelePresent=0;   
          $valPresent=0;   
          $ctgPresent=0;   
	 foreach $line(@block) {
          if ($line =~ /^rs/) {
                ($rs_ID, $species_name) = ($line =~ /^(rs\d+)\s*\|\s*(\S+)/);
           	$rsIdPresent=1; 
	    }
            elsif ($line =~ /^SNP/) {
                ($allele_a, $allele_b) = ($line =~ /^SNP.+\=\'(\S)\/(\S)\'/);
		# if allele_a and allele_b span multiple characters
		# then these are going to be null (and they should not be)
		# trap them as bad records in log file
	       	if((!$allele_a) || (!$allele_b)) { 
		$InvalidAlleleDataCount++;
		 } else {	
	       	$allelePresent=1; 
           	} 
 	    }
            elsif ($line =~ /^VAL/) {
                ($validated_status) = ($line =~ /^VAL.+ed\=(\S+)/);
		if($validated_status) {
           	$valPresent=1; 
                } 
	    }
	    elsif($line =~ /^CTG.+chr\=\S+.*/) {
                ($assemblySrc, $chrInContig, $locationInContig) = ($line =~ /^CTG\s*\|\s*assembly\=(\S+)\s*\|\s*chr\=(\S+)\s*\|\s*chr-pos\=(\d+)\s*\|/);
     		$chrInContig =~s/\s+//g; 
		$chromosome_number=~s/\s+//g;	
		
	         if($assemblySrc =~/GRCh37/gi){
		$lineBeingInserted = $line;	
		} 
		 if($assemblySrc && $chrInContig && $locationInContig) {
		$multilocs{$assemblySrc."|".$chrInContig."|".$locationInContig} = $chrInContig."|".$locationInContig."|".$locationInContig."|".$assemblySrc;
		}	
	   $ctgPresent = 1; 
	   }
        }
	
	 if($lineBeingInserted) { 
        chomp($lineBeingInserted); 	
	($chrNumberInLineBeingInserted, $location) = ($lineBeingInserted =~/^CTG.+chr\=(\S+)\s*\|\s*chr-pos\=(\S*)\s*\|/);
	$chrNumberInLineBeingInserted =~s/\s+//g; 
	$chromosome_number =~s/\s+//g;

        if($chrNumberInLineBeingInserted =~/^$chromosome_number$/) { 
	$parsedLineCount++;
        print OUTFILE "$rs_ID,$species_name,$validated_status,$chromosome_number,$location,$allele_a,$allele_b,$chrHash->{$chromosome_number},$assemblySrc,$id,\n";
        print REFFILE "$rs_ID,$refLine"."$rs_ID,$refLine"."$rs_ID,\n";
	        foreach my $ky (keys %multilocs) {
		($chrTmp, $locTmp, $locTmp, $assemblyTmp) = split(/\|/, $multilocs{$ky});
		if($locTmp !~/\d+/){ $locTmp = '';} 
		 print PHYLOCFILE "$rs_ID,$chrHash->{$chrTmp},$locTmp,$locTmp,$assemblyTmp,$id,\n";
		}
	%multilocs = (); 
   	$lineBeingInserted = "";	
	$id++;
		}	
	} 
           # if All fields are not present, put this information in LOG and in BAD file
	  elsif((!$rsIdPresent) || (!$allelePresent) || (!$valPresent) || (!$ctgPresent)){
	  $incompleteRsIdsCount++;
	  print BADFILE "Record available in file for chromosome $chromosome_number \n";	
	  print BADFILE join("\n",@block),"\n";	
		}	
	}  
}
open (fhandle, ">idHandle.txt") || die "error opening id handle file \n";
print fhandle "$id\n";
close fhandle;
print "Finished writing to file \n";
print LOGFILE "Data Source: NCBI SNP Data for $chromosomeFile\n";
print LOGFILE "Number of recrods in raw data for chromosome $chromosome_number: $rsLineCount\n";
#Valid SNP Records may include those with invalid allele or contig data
print LOGFILE "Number of records written to $out_file_name: $parsedLineCount\n";
print LOGFILE "Number of records written to $ref_file: $parsedLineCount\n";
print LOGFILE "Number of records written to $phyloc_file: $parsedLineCount\n";
print LOGFILE "Number of incomplete/bad records in $input_file_name: $incompleteRsIdsCount\n";
print LOGFILE "Number of invalid allele data in $input_file_name: $InvalidAlleleDataCount\n";
print LOGFILE "Number of invalid contig Data in $input_file_name: $invalidCtgCount\n";
print LOGFILE "\n\n\n";

close INFILE;
close OUTFILE;
close LOGFILE;
close BADFILE;
close REFFILE;
close PHYLOCFILE;

exit;
