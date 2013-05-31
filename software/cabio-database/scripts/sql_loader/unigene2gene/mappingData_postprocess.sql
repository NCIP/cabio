/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexes/zstg_gene2unigene.cols.sql;
@$LOAD/indexes/zstg_omim2gene.cols.sql;
@$LOAD/indexes/zstg_gene2accession.cols.sql;
@$LOAD/indexes/zstg_genealias.cols.sql;
@$LOAD/indexes/zstg_gene2refseq.cols.sql;
@$LOAD/indexes/zstg_gene2go.cols.sql;
@$LOAD/indexes/zstg_seqgene.cols.sql;
@$LOAD/indexes/zstg_seqsts.cols.sql;


@$LOAD/constraints/zstg_gene2unigene.enable.sql;
@$LOAD/constraints/zstg_omim2gene.enable.sql;
@$LOAD/constraints/zstg_gene2accession.enable.sql;
@$LOAD/constraints/zstg_genealias.enable.sql;
@$LOAD/constraints/zstg_gene2refseq.enable.sql;
@$LOAD/constraints/zstg_gene2go.enable.sql;
@$LOAD/constraints/zstg_seqgene.enable.sql;
@$LOAD/constraints/zstg_seqsts.enable.sql;

@$LOAD/triggers/zstg_gene2unigene.enable.sql;
@$LOAD/triggers/zstg_omim2gene.enable.sql;
@$LOAD/triggers/zstg_gene2accession.enable.sql;
@$LOAD/triggers/zstg_genealias.enable.sql;
@$LOAD/triggers/zstg_gene2refseq.enable.sql;
@$LOAD/triggers/zstg_gene2go.enable.sql;
@$LOAD/triggers/zstg_seqgene.enable.sql;
@$LOAD/triggers/zstg_seqsts.enable.sql;

ANALYZE TABLE zstg_gene2UNIGENE COMPUTE STATISTICS;
ANALYZE TABLE zstg_omim2gene COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene2ACCESSION COMPUTE STATISTICS;
ANALYZE TABLE zstg_geneALIAS COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene2refseq COMPUTE STATISTICS;
ANALYZE TABLE zstg_gene2go COMPUTE STATISTICS;
ANALYZE TABLE zstg_seqgene COMPUTE STATISTICS;
ANALYZE TABLE zstg_seqsts COMPUTE STATISTICS;

-- Add Hugo Symbol to Gene
UPDATE gene_tv G SET HUGO_SYMBOL = (SELECT DISTINCT SYMBOL
                                  FROM zstg_geneALIAS A, zstg_gene_identifiers B
     WHERE A.LOCUSLINKID = B.IDENTIFIER AND B.data_source = 2 AND G.gene_ID = 
                                           B.gene_ID AND A.TYPE = 'HUGO');

COMMIT;
-- update 
update zstg_gene2unigene set taxon=DECODE(substr(unigene_cluster,0,instr(unigene_cluster, '.')-1), 'Hs', 5, 'Mm', 6)
where unigene_cluster like 'Mm%' or unigene_cluster like 'Hs%';
update zstg_gene2unigene set ucluster=substr(unigene_cluster,instr(unigene_cluster, '.')+1);
commit;

EXIT;
