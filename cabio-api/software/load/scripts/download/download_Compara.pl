#!/usr/bin/perl
#
# Ensembl Compara database dump for constrained regions.
#
# Author: Konrad Rokicki
# Date: 04/16/2009
#

use strict;
use DBI;
use File::Path;
use Data::Dumper;

# Ensure output goes out immediately to STDOUT
$| = 1;

################################################################################
# Output Files
################################################################################

my $outdir = $ARGV[0];

print "Creating directory $outdir\n";
mkpath $outdir;

my $outfile_methods = "$outdir/methods.txt";
my $outfile_species = "$outdir/species.txt";
my $outfile_regions = "$outdir/regions.txt";

################################################################################
# Compara Database Parameters
################################################################################

my $host = 'ensembldb.ensembl.org';
my $port = '5306';
my $username = 'anonymous';
my $password = '';
my $db_prefix = "ensembl_compara_";

################################################################################
# Connect to the latest Compara MySQL Database
################################################################################

# we have to connect to a known database to get the list of databases before we can pick the latest

my $database = $db_prefix.'53'; 
print "Connecting to Ensembl schema: $database\n";
my $dbh = DBI->connect("DBI:mysql:database=$database;host=$host;port=$port", 
    $username, $password) || die "Could not connect to DB: $DBI::errstr";

# reconnect to latest database

my $latest = get_latest_compara_schema($dbh);

if ($latest ne $database) {    
    print "Reconnecting to latest Ensembl database: $latest\n";
    $dbh = DBI->connect("DBI:mysql:database=$latest;host=$host;port=$port",
        $username, $password) || die "Could not connect to DB: $DBI::errstr";
}

################################################################################
# Alignment/analysis Methods
################################################################################

my @mlssids = ();

my $sth = $dbh->prepare(q{
    SELECT mlss.method_link_species_set_id mlssid, mlss.name name, m.class class
    FROM method_link m, method_link_species_set mlss
    WHERE m.method_link_id = mlss.method_link_id
    AND upper(type) = "GERP_CONSTRAINED_ELEMENT";
});

open (OUT, ">$outfile_methods") or die "Can't open output file $outfile_methods\n";
print OUT "Method_Id\tMethod_Name\tMethod_Class\n";

$sth->execute();
while (my ($mlssid, $name, $class) = $sth->fetchrow_array()) {
    print OUT "$mlssid\t$name\t$class\n";
    push @mlssids, $mlssid;
}

close OUT;

$sth->finish();

################################################################################
# Species Set for each Method
################################################################################

$sth = $dbh->prepare(q{
    SELECT g.genome_db_id, g.name scientific_name, t_common.name common_name, g.assembly
    FROM method_link_species_set mlss
         join species_set ss on (mlss.species_set_id = ss.species_set_id)
         join genome_db g on (ss.genome_db_id = g.genome_db_id)
         left join ncbi_taxa_name t_common on (g.taxon_id = t_common.taxon_id)
    WHERE mlss.method_link_species_set_id = ?
    AND lower(t_common.name_class) = 'genbank common name'
});

open (OUT, ">$outfile_species") or die "Can't open output file $outfile_species\n";
print OUT "Method_Id\tScientific_Name\tCommon_Name\tAssembly\n";

################################################################################
# Constrained Regions each Method
################################################################################

my $sth2 = $dbh->prepare(q{
    SELECT name chromosome, dnafrag_start, dnafrag_end, p_value, score, constrained_element_id ensembl_ce_id
    FROM dnafrag d join constrained_element c on (c.dnafrag_id = d.dnafrag_id)
    AND d.genome_db_id = ?
    AND method_link_species_set_id = ?
    AND d.coord_system_name = 'chromosome'
});

open (OUT2, ">$outfile_regions") or die "Can't open output file $outfile_regions\n";
print OUT2 "Method_Id\tChromosome\tStart\tEnd\tScore\tPvalue\n";

################################################################################
# Execute "Species Set" and "Constrained Regions"
################################################################################

for my $mlssid (@mlssids) {
    
    print "Processing method $mlssid\n";

    # We pull the id of the human genome which is actually used in each method.
    # This is safer than joining to genome_db where name='Homo sapiens' in the 
    # case of future human genome versions being added.
    my $humanGenomeId;

    # get species used by the method
    print "  Fetching species... ";
    
    $sth->bind_param(1, $mlssid);
    $sth->execute();
   
    my $c = 0;
    while (my ($gdbid, $sci_name, $common_name, $assembly) = $sth->fetchrow_array()) {
        print OUT "$mlssid\t$sci_name\t$common_name\t$assembly\n";
        $humanGenomeId = $gdbid if ($common_name eq 'human');
        $c++;
    }
    print "wrote $c species\n";

    # get constrained regions
    print "  Fetching regions (this may take a while)... ";

    $sth2->bind_param(1, $humanGenomeId);
    $sth2->bind_param(2, $mlssid);
    $sth2->execute();
 
    $c = 0;
    while (my ($chrom, $start, $end, $pval, $score, $ceid) = $sth2->fetchrow_array()) {
        print OUT2 "$mlssid\t$chrom\t$start\t$end\t$score\t$pval\n";
        $c++;
    }
    print "wrote $c regions\n";
}

close OUT;
close OUT2;

$sth->finish();

$dbh->disconnect();
exit;


sub get_latest_compara_schema {

    my $dbh = shift;

    my $sth = $dbh->prepare(q{show databases}) or
        die "Unable to prepare show databases: ". $dbh->errstr."\n";

    $sth->execute or
        die "Unable to exec show databases: ". $dbh->errstr."\n";

    my @dbs = ();
    while (my ($dbname) = $sth->fetchrow_array()) {
        if ($dbname =~ /^$db_prefix/) {
            $dbname =~ s/^$db_prefix//;
            push @dbs, $dbname;
        }
    } 

    $sth->finish;
    @dbs = sort { $a <=> $b } @dbs;
    return $db_prefix.$dbs[$#dbs];
}


