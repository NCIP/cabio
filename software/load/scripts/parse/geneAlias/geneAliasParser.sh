#!/bin/sh
echo "Parsing Gene Alias \n"
perl geneAliasParser.pl gene_info geneAlias.out
perl hgncAlias.pl
perl hgncParser.pl hgncGeneAlias.txt hgncgeneAlias.out
echo "Finished parsing Gene Alias \n"

