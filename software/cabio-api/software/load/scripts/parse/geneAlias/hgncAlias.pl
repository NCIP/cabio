#!/usr/bin/perl -w
use strict;
use LWP::Simple;
use ParseUtils;
my ($indir,$outdir) = getFullDataPaths('unigene2gene');
open INFILE, ">$indir/hgncGeneAlias.txt" || die  "Error opening hgncGeneAlias.txt \n";
my $url = "http://www.genenames.org/cgi-bin/hgnc_downloads.cgi?".
    "title=HGNC%20output%20data&hgnc_dbtag=on&col=gd_hgnc_id&col=gd_app_sym&col=gd_app_name&".
    "col=gd_aliases&col=gd_pub_chrom_map&col=md_eg_id&status=Approved&status_opt=2&".
    "level=pri&=on&where=&order_by=gd_app_sym_sort&limit=&".
    "format=text&submit=submit&.cgifields=&.cgifields=level&.cgifields=status&".
    ".cgifields=chr&.cgifields=hgnc_dbtag";
my $page = get($url);
print INFILE $page;
close INFILE;
