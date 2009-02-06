#!/usr/bin/perl

# The perl script parses the Uniprot data for human and mouse
# maps it to existing caBIO gene ids
# and parses all the attributes for the protein object.

use strict;
use warnings;
use ParseUtils;

my ($indir,$outdir) = getFullDataPaths('protein');

my $input_file = "$indir/uniprot_sprot.dat";
my $uniprot_records = "$outdir/new_protein.dat";
my $protein_priAcc_secAcc = "$outdir/protein_secondary_accession.dat";
my $protein_alias ="$outdir/protein_alias.dat";
my $protein_taxon = "$outdir/protein_taxon.dat";
my $protein_keywords ="$outdir/protein_keywords.dat";
my $protein_sequence ="$outdir/protein_sequence.dat";
my $protein_embl_ids ="$outdir/protein_embl.dat";
my $protein_copyright = "$outdir/protein_copyright.dat";
my $badfile = "UNIPROT_parser.bad"; 
my $logfile = "UNIPROT_parser.log"; 
my $provData = "$outdir/Protein_ProvData.dat";
my $refline = "http://www.pir.uniprot.org/cgi-bin/upEntry?id=";

my @acc_num;
my %uniprot;
my $j = 0;
my $i = 0;

my $taxon;
my @accessions;
my $primaryAccession;
my $primaryKey = 1;
my $copyrightStatement = '';
my @secondaryAccessions;
my $alias;
my @keywords;
my $primaryName;
my $sequence_value;
my $length;
my $molecularWeightDaltons;
my $chargeAtpH7;
my $masstochargeratioatpH7;
my $checksum;
my @secondaryName;
my $flag;
my @id_line;

my $status =0;
my $key ;
my @embl;


$/ = "\n\/\/\n";

# QA deliverables
my $noRecordsInRawFile=0;
my $invalidUniprotId=0; 
my $humanProteinRecords=0;
my $mouseProteinRecords=0;
my $invalidEmblIdCount=0; 
my $keyWordsCounter=0;
my $invalidLengthValue=0; 
my $invalidMolDaltonWt=0; 
my $recProteinTaxon=0;
my $invalidAliasEntry=0; 
my $recProteinKeywords=0;
my $recProteinEmbl=0;
my $recProteinSequence=0;
my $recProteinAliasCount=0;
my $recNewProtein=0;
my $badRecord=0;
my $nonHumanMouseTaxon=0;
my $invalidProteinEmbl=0;
my $invalidProteinKywrds=0;
open (INFILE, "<$input_file") or die "Cannot open \"$input_file\" \n\n";
open (UNIPROT_RECORDS, ">$uniprot_records") or die "Cannot open \"$uniprot_records\" \n\n";
open (PROTEIN_PRIACC_SECACC, ">$protein_priAcc_secAcc") or die "Cannot open \"$protein_priAcc_secAcc\" \n\n";
open (PROTEIN_ALIAS, ">$protein_alias") or die "Cannot open \"$protein_alias\" \n\n";
open (PROTEIN_TAXON, ">$protein_taxon") or die "Cannot open \"$protein_taxon\" \n\n";
open (PROTEIN_KEYWORDS, ">$protein_keywords") or die "Cannot open \"$protein_keywords\" \n\n";
open (PROTEIN_SEQUENCE, ">$protein_sequence") or die "Cannot open \"$protein_sequence\" \n\n";
open (PROTEIN_EMBL, ">$protein_embl_ids") or die "Cannot open \"$protein_embl_ids\" \n\n";
open (PROTEIN_COPYRIGHT, ">$protein_copyright") or die "Cannot open \"$protein_copyright\" \n\n";
open (PROTEIN_LOG, ">$logfile") or die "Cannot open \"$logfile\" \n\n";
open (PROTEIN_BAD, ">$badfile") or die "Cannot open \"$badfile\" \n\n";
open (PROVDATA,">$provData") or  die "Cannot open \"$provData\" \n\n";
while (<INFILE>) {

    my @block = split("\n", $_);

    $noRecordsInRawFile++;
    foreach my $line(@block) {

        $flag ='false';
        $line =~s/\s+$//g;
        # Gets the Uniprot ID for each protein
        if ($line =~ /^ID/ ){
            my @acc_line = split(" ",$line);
            my $acc = $acc_line[1];
            $acc =~ s/;//g;
            $uniprot{uniProtCode} =$acc;
            $i= $i+1;
       	    if($acc eq '') {
           	$invalidUniprotId++; 
            }		 
        }

        # Gets the Uniprot accessions for each uniprot protein
        if ($line =~ /^AC/ ){
            @id_line = split(" ",$line);
            shift(@id_line);
            push(@accessions,@id_line);
            # accession's semicolon is not removed until below 
        }

        # Gets the taxon for the Uniprot protein
        # Only human and mouse data are parsed

        if ($line =~ /^OX/ ){

            my @taxon_line = split(" ",$line);
            shift(@taxon_line);
            $taxon_line[0] =~ s/NCBI_TaxID=//g;


            foreach(@taxon_line) {
                my $taxon_id = $_;

                $taxon_id =~ s/;|,//g;
                #print "$taxon_id\t";
                if( ($taxon_id eq 9606) | ($taxon_id eq 10090)) {
                    $flag ='true';
                    if($taxon_id == 9606){
                        $taxon = 5;
                        $humanProteinRecords++;
			}
                    else{
                        $taxon = 6;
                        $mouseProteinRecords++;
                    }
                } else {
		  $nonHumanMouseTaxon++;	
		}
            }
        }

        # Gets the alias names for uniprot protein

        if ($line =~ /^DE/ ){

            my $alias_line = $line;
            $alias_line=~ s/^DE//;
            $alias_line=~ s/^\s\s//;
            $alias .=$alias_line;
            # adds alias line to alias		
        }

        # Get the associated embl ids for each protein
        if ($line =~ /^DR   EMBL;/ ){
            my @embl_id_line = split(" ",$line);
            my $embl_id =$embl_id_line[2];
            $embl_id =~ s/;//g;
            push(@embl,$embl_id);
           if($embl_id eq '') {
	  	$invalidEmblIdCount++; 
	   }		
      }

        # Get the associated keywords for each protein
        if ($line =~ /^KW/ ){
            my @keyword_line = split(";", $line);
            $keyword_line[0] =~ s/^KW//;
            push(@keywords,@keyword_line);
	    $keyWordsCounter += scalar(@keyword_line);
        }

        # Get the length of amino acids, the molecular
        # weight of the protein
        # Checksum for the protein

        if ($line =~ /^SQ/ ){

            my @seq_line = split("; ", $line);

            foreach (@seq_line){
                my $value =$_;
                if($value =~ /^SQ/){
                    my @seq = split(" ", $value);
                    $length = $seq[2];
                    #$length =~ /\s(0-9)*\s/g;
                    #print "$length\n";
               	    if( ($length eq '') || ($length =~/\D+/)) {
		   		$invalidLengthValue++; 
		     } 
	        }
                elsif($value =~ /MW$/){
                    my @mol = split(" ", $value);
                    $molecularWeightDaltons = $mol[0];
                    #print "$molecularWeightDaltons\n";
               	    if( ($mol[0] eq '') || ($mol[0] =~/\D+/)) {
		   		$invalidMolDaltonWt++; 
		     } 
                }
                else{
                    my @check = split(" ", $value);
                    $checksum = $check[0]
                }

            }

        }

        # Get the value of the sequence
        if ($line =~ /^\s\s/ ){
                my $seq_value_line =$line;
                $seq_value_line =~ s/(\s)*//g;
                $sequence_value .=$seq_value_line;
        }

        # Writes all the attributes to respective files for human and
        # mouse proteins.

        if ($flag eq 'true'){

            $status = 1;
            $key = $primaryKey;

            print UNIPROT_RECORDS "$primaryKey\t";
            print PROTEIN_COPYRIGHT "$primaryKey\t";

            print PROTEIN_TAXON "$primaryKey\t";
	    print PROTEIN_TAXON "$taxon\n";

	    $recProteinTaxon++;

            $primaryAccession = $accessions[0];
            $primaryAccession =~ s/;/ /g;

            print UNIPROT_RECORDS "$primaryAccession\t";
            print UNIPROT_RECORDS "$uniprot{uniProtCode}\t";

	    #removes the field "AC" from the accessions		
            shift(@accessions);

            foreach (@accessions) {
                $_ =~ s/;/ /g;
                print PROTEIN_PRIACC_SECACC "$primaryKey\t";
                print PROTEIN_PRIACC_SECACC "$_\n";
            }
	#### clean up alias field to split into separate alias ##
            # replaces [Includes: with (			
            $alias =~ s/\[Includes: /\(/;
            # removes portions that are of the type [Contains: () at the end			
            $alias =~ s/\[Contains: (.)*$//;
            # substitutes semicolons with (			
            $alias =~ s/;\s/ \(/g ;
            $alias =~ s/\]$|\].$//g;
       #### split into separate aliases ###
            my @alias_line = split(/ \(/,$alias);

	    # gets primary name as first alias entry  
            $primaryName = shift(@alias_line);
            $primaryName =~ s/^\s*//;
            $primaryName =~ s/\.$//;

            foreach (@alias_line) {

                $alias = $_;
                $alias =~ s/^\s*//;
                $alias =~ s/\)$// ;
                $alias =~ s/\)\.// ;
		$alias =~s/AltName: Full=//;
		$alias =~s/AltName: //;
		$alias =~s/Short=//;
                if(length($alias) >=1){
		    	
		    $recProteinAliasCount++;
                    print PROTEIN_ALIAS "$primaryKey\t";
                    print PROTEIN_ALIAS  "$alias\t\n";
                } else {
                   $invalidAliasEntry++; 
                }
            }

            $primaryKey++;
        }
    #end of block
    }

    if ($status == 1){

        print UNIPROT_RECORDS "$primaryName\n";
        print PROVDATA "$primaryKey\t$refline".$primaryAccession."\t$refline".$primaryAccession."\t\n";
        $recNewProtein++;
        foreach(@keywords){
	    $recProteinKeywords++;
            print PROTEIN_KEYWORDS "$key\t";
            my $keyword = $_;
            $keyword =~ s/^\s\s//;
            $keyword =~ s/\.$//;
            print PROTEIN_KEYWORDS "$keyword\n";
		if(!$_)
      		{
		$invalidProteinKywrds++;	
		}  
	
        }

        print PROTEIN_SEQUENCE "$molecularWeightDaltons\t";
        print PROTEIN_SEQUENCE "$checksum\t";
        print PROTEIN_SEQUENCE "$key\t";
        print PROTEIN_SEQUENCE "$sequence_value\t";
        print PROTEIN_SEQUENCE "$length\n";
        $recProteinSequence++;

        foreach(@embl){
		$recProteinEmbl++;
                print PROTEIN_EMBL "$key\t";
                print PROTEIN_EMBL "$_\n";
		if(!$_)
      		{
		$invalidProteinEmbl++;	
		}  
	}
   } else {
  	print PROTEIN_BAD join("\n",@block),"\n"; 
      	$badRecord++; 
   } 

    $key = '';
    @accessions = ();
    $alias ='';
    $taxon = '';
    $copyrightStatement = '';
    $status =0;
    @keywords =();
    $molecularWeightDaltons = '';
    $length ='';
    $checksum ='';
    $sequence_value ='';
    @embl =();

#end of while
}

print  PROTEIN_LOG "Data Source: Uniprot Protein Data\n";
print  PROTEIN_LOG "Number of records in $input_file: $noRecordsInRawFile\n";
print  PROTEIN_LOG "Number of human protein records: $humanProteinRecords\n";
print  PROTEIN_LOG "Number of mouse protein records: $mouseProteinRecords\n";
print  PROTEIN_LOG "Number of other protein records: $nonHumanMouseTaxon\n";
print  PROTEIN_LOG "Number of skipped protein records: $badRecord\n";
print  PROTEIN_LOG "Number of invalid length fields: $invalidLengthValue\n";
print  PROTEIN_LOG "Number of invalid protein-alias fields: $invalidAliasEntry\n";
print  PROTEIN_LOG "Number of invalid protein-embl fields: $invalidProteinEmbl\n";
print  PROTEIN_LOG "Number of invalid protein-keyword fields: $invalidProteinKywrds\n";
print  PROTEIN_LOG "Number of invalid molecular-weight fields: $invalidMolDaltonWt\n";
print  PROTEIN_LOG "Number of records written to $uniprot_records: $recNewProtein\n";
print  PROTEIN_LOG "Number of records written to $provData: $recNewProtein\n";
print  PROTEIN_LOG "Number of records written to $protein_taxon: $recProteinTaxon\n";
print  PROTEIN_LOG "Number of records written to $protein_keywords: $recProteinKeywords\n";
print  PROTEIN_LOG "Number of records written to $protein_sequence: $recProteinSequence\n";
print  PROTEIN_LOG "Number of records written to $protein_embl_ids: $recProteinEmbl\n";
print  PROTEIN_LOG "Number of records written to $protein_alias: $recProteinAliasCount\n";
close INFILE;
close UNIPROT_RECORDS;
close PROTEIN_PRIACC_SECACC;
close PROTEIN_ALIAS;
close PROTEIN_TAXON;
close PROTEIN_SEQUENCE;
close PROTEIN_EMBL;
close PROTEIN_LOG;
close PROTEIN_BAD;
close PROVDATA;
exit;
