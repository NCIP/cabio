#!/usr/bin/perl
#
# Script for parsing drugcards.txt from the Drug Databank and generating
# flat files suitable for loading into caBIO staging tables.
#
# Author: Konrad Rokicki
# Date: 05/05/2009
#

use strict;
use Data::Dumper;
use ParseUtils;

my ($indir,$outdir) = getFullDataPaths("drugbank");

my $infile = "$indir/drugcards.txt";
my $outfile_drugs = "$outdir/out_drugs.txt";
my $outfile_targets = "$outdir/out_targets.txt";
my $outfile_drugtargets = "$outdir/out_drug_targets.txt";
my $outfile_drugaliases = "$outdir/out_drug_aliases.txt";

open(IN,$infile) or die;

print "Parsing $infile\n";

my @drugs = ();
my %texts = ();
my $currdrug = "";
my $currtext = "";

while (<IN>) {

    if (my ($drug) = (/^#BEGIN_DRUGCARD (.+)/)) {
        $currdrug = $drug;
        $currtext = "";
        next;
    }

    if (/^#END_DRUGCARD/) {
        push @drugs, $currdrug;
        $texts{$currdrug} = $currtext;
#        last if ($#drugs > 20);
        next;
    }

    $currtext .= $_;
}

my %allprops = ();

my %drugs = ();
my %drugtargets = ();
my %drugenzymes = ();

my @cols_drug = ();
my @cols_target = ();
my @cols_enzyme = ();
my %cols_drug = ();
my %cols_target = ();
my %cols_enzyme = ();

for my $drugId (@drugs) {

    #print "Processing $drugId\n";

    my $text = $texts{$drugId};

    $text =~ s/^\s*#\s*//s;
    $text =~ s/\s+$//s;

    my (@props) = split /\n# /,$text;

    my %targets = ();
    my %enzymes = ();

    for my $prop (@props) {

        my ($key,$value) = ($prop =~ /^(.+?):\n(.*)$/s);
        chomp $value;

        my ($targetName,$targetKey) = ($key =~ /^(Drug_Target_\d+)_(\w+)/);
        my ($enzymeName,$enzymeKey) = ($key =~ /^(Phase_\d+_Metabolizing_Enzyme_\d+)_(\w+)/);

        if ($targetName) {
            unless (exists $cols_target{$targetKey}) {
                $cols_target{$targetKey}++;
                push @cols_target, $targetKey;
            }
            $targets{$targetName}{$targetKey} = $value;
        }
        elsif ($enzymeName) {
            unless (exists $cols_enzyme{$enzymeKey}) {
                $cols_enzyme{$enzymeKey}++;
                push @cols_enzyme, $enzymeKey;
            }
            $enzymes{$enzymeName}{$enzymeKey} = $value;
        }
        else {
            unless (exists $cols_drug{$key}) {
                $cols_drug{$key}++;
                push @cols_drug, $key;
            }
            $drugs{$drugId}{$key} = $value;
        }

    }

    for my $targetName (keys %targets) {
    
        my $id = $targets{$targetName}{"ID"};
        if (exists $drugtargets{$id}) {
            # check to make sure all the target's attributes are the same
            for my $targetKey (keys %{$targets{$targetName}}) {
                if ($targetKey ne "Drug_References") {
                    if ($drugtargets{$id}{$targetKey} ne $targets{$targetName}{$targetKey}) {
                        print "Warning: $targetKey redefined for drug target with ID $id.\n";
                    }
                }
            }
            # link drug/target
            push @{$drugtargets{$id}{'drugs'}}, $drugId;
        }
        else {
            # determine species of the target based on the SwissProt name
            my $species = '';
            my $swissprot = $targets{$targetName}{'SwissProt_Name'};
            if ($swissprot =~ /_HUMAN$/) {
                $species = 'Hs';
            }
            elsif ($swissprot =~ /_MOUSE$/) {
                $species = 'Mm';
            }
            $targets{$targetName}{'Species_Abbr'} = $species;

            # skip non-human, non-mouse targets
            next unless ($species);

            # register the target
            $drugtargets{$id} = $targets{$targetName};
            delete $drugtargets{$id}{"Drug_References"};
            $drugtargets{$id}{'drugs'} = [$drugId];
        }
    }
}

print "Number of drugs: ".scalar(keys %drugs)."\n";
print "Number of targets: ".scalar(keys %drugtargets)."\n";

close IN;

# Print drugs

@cols_drug = qw(Generic_Name Absorption Biotransformation CAS_Registry_Number Chemical_Formula Half_Life Indication Chemical_IUPAC_Name Mechanism_Of_Action Molecular_Weight_Avg Pharmacology Protein_Binding PubChem_Compound_ID PubChem_Substance_ID Smiles_String_canonical Toxicity);

open (OUT, ">$outfile_drugs") or die "Can't open output file $outfile_drugs\n";
open (OUT_ALIAS, ">$outfile_drugaliases") or die "Can't open output file $outfile_drugaliases\n";

print OUT "Drug_Id";
for my $key (@cols_drug) {
    print OUT "\t$key";
}
print OUT "\n";

print OUT_ALIAS "Drug_Id\tAlias_Type\tAlias_Name\n";

for my $drugId (@drugs) {

    for my $name (split /\n/,$drugs{$drugId}{'Synonyms'}) {
        $name = clean($name);
        print OUT_ALIAS "$drugId\tSynonym\t$name\n" if $name; 
    }

    for my $name (split /\n/,$drugs{$drugId}{'Brand_Names'}) {
        $name = clean($name);
        print OUT_ALIAS "$drugId\tTrade Name\t$name\n" if $name;
    }

    print OUT $drugId;
    for my $key (@cols_drug) {
        my $val = clean($drugs{$drugId}{$key});
        print "Warning: $key contains large value\n" if (length($val) > 5000);
        print OUT "\t$val";
    }
    print OUT "\n";
}

close OUT;
close OUT_ALIAS;

print "Wrote $outfile_drugs\n";
print "Wrote $outfile_drugaliases\n";

# Print targets

@cols_target = qw(Species_Abbr Gene_Name GenAtlas_ID GeneCard_ID SwissProt_ID HGNC_ID);

open (OUT_T, ">$outfile_targets") or die "Can't open output file $outfile_targets\n";
open (OUT_DT, ">$outfile_drugtargets") or die "Can't open output file $outfile_drugtargets\n";

print OUT_T "Target_Id";
for my $key (@cols_target) {
    print OUT_T "\t$key";
}
print OUT_T "\n";

print OUT_DT "Target_Id\tDrug_Id\n";

for my $targetId (keys %drugtargets) {

    for my $drugId (@{$drugtargets{$targetId}{'drugs'}}) {
        print OUT_DT "$targetId\t$drugId\n";
    }

    print OUT_T $targetId;
    for my $key (@cols_target) {
        my $val = clean($drugtargets{$targetId}{$key});
        print "Warning: $key contains large value\n" if (length($val) > 5000);
        print OUT_T "\t$val";
    }
    print OUT_T "\n";
}

close OUT_T;
close OUT_DT;

print "Wrote $outfile_targets\n";
print "Wrote $outfile_drugtargets\n";


sub clean {
    my $val = shift;
    $val =~ tr/\n\r\t/   /;
    $val =~ s/\s+/ /;
    $val = "" if ($val eq "Not Available");
    return $val;
}


