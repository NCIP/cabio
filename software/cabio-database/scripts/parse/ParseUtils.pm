package ParseUtils;
#
# Common utilities for data parse scripts.
#
# Author: Konrad Rokicki
# Date: 03/05/2007
#

use strict;
use base 'Exporter';
use File::Path;
use DBI;

our @EXPORT    = qw(getFullDataPath getFullDataPaths getChromosomes testingSomething);
our @EXPORT_OK = qw($dataDir);

our $dataDir = $ENV{'CABIO_DATA_DIR'};

INIT {
    die "The CABIO_DATA_DIR environment variable is not set." unless ($dataDir);
}

#
# Prepends the absolute CABIO_DATA_DIR to the given path fragment.
#
sub getFullDataPath {
    my $path = shift;
    return "$dataDir/$path";
}

#
# Prepends the absolute CABIO_DATA_DIR as well
# as CABIO_DATA_DIR/temp to the given path fragment.
#
# Returns both absolute paths.
#
sub getFullDataPaths {
    my $path = shift;
    my $indir = "$dataDir/$path";
    my $outdir = "$dataDir/temp/$path";
    mkpath $outdir;
    return ($indir,$outdir);
}

sub getChromosomes() {
    my($no, $id, $taxId);
    my %chrHash;
    $taxId = shift || die "Function requires TaxonId\n";
    my $dbh = DBI->connect($ENV{'DBI_DRIVER'}, $ENV{'SCHEMA'}, $ENV{'SCHEMA_PWD'}) || die  "Error ".DBI->errstr;
    my $sql = qq(SELECT chromosome_number, chromosome_id from chromosome where taxon_id = $taxId);
    my $sth = $dbh->prepare($sql);
    $sth->execute();
    $sth->bind_columns(\$no, \$id);
    while($sth->fetch()) {
        $no=~s/\s+//g;
        $id=~s/\s+//g;
        $chrHash{$no} = $id;
    }
    return \%chrHash;
}

sub testingSomething() {
    return 1;
}

1;
