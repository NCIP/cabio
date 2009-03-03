VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM database_cross_reference;

DROP SEQUENCE DBCROSSREF_ID;
CREATE SEQUENCE DBCROSSREF_ID START WITH &V_MAXROW INCREMENT BY 1;
ALTER TRIGGER SET_DBCROSSREF_ID ENABLE;

INSERT
  INTO database_cross_reference(SNP_ID, CROSS_REFERENCE_ID, TYPE, source_NAME, 
source_TYPE) SELECT DISTINCT A.ID ID, B.TSC_ID TSC_ID, 
'gov.nih.nci.cabio.domain.SNP', 'SNP', 'SNP Consortium' FROM snp_tv A, 
zstg_snp_tsc B
              WHERE A.DB_SNP_ID = B.DBSNP_RS_ID;

CREATE UNIQUE INDEX GTV_TMP ON gene_tv(CLUSTER_ID, taxon_ID)  NOLOGGING PARALLEL tablespace cabio_fut;
CREATE UNIQUE INDEX G2G_TMP ON zstg_omim2gene(OMIM_NUMBER) NOLOGGING PARALLEL tablespace cabio_fut;

INSERT
  INTO database_cross_reference(gene_ID, CROSS_REFERENCE_ID, TYPE, source_NAME, 
source_TYPE)SELECT DISTINCT C.gene_ID GENE_ID, B.OMIM_NUMBER OMIM_ID, 
'gov.nih.nci.cabio.domain.Gene', 'OMIM_ID', 'UNIgene' FROM zstg_gene2UNIGENE A, 
zstg_omim2gene B, gene_tv C
WHERE A.geneID = B.GENEID AND SUBSTR(A.UNIGENE_CLUSTER, INSTR(A.UNIGENE_CLUSTER
, '.') + 1) = C.CLUSTER_ID AND C.taxon_ID = 5;

CREATE INDEX GTV_TMP_IDX2 ON gene_tv('Hs' || CLUSTER_ID) tablespace cabio_fut;

-- see if other EC and Ensembl Ids can be used
INSERT
  INTO database_cross_reference(gene_ID, CROSS_REFERENCE_ID, TYPE, source_NAME, 
source_TYPE) SELECT DISTINCT G.gene_ID, E.EC, 'gov.nih.nci.cabio.domain.Gene', 
'EC_ID', 'Enzyme Commission' FROM gene_tv G, zstg_rna_probesets Z, ar_ec E
WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID AND Z.PROBE_SET_ID = E.PROBE_SET_ID 
AND Z.geneCHIP_ARRAY = E.GENECHIP_ARRAY UNION SELECT DISTINCT G.GENE_ID, E.EC, 
'gov.nih.nci.cabio.domain.Gene', 'EC_ID', 'Enzyme Commission' FROM gene_tv G, 
zstg_rna_probesets_tmp Z, ar_ec_tmp E
WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID AND Z.PROBE_SET_ID = E.PROBE_SET_ID 
AND Z.geneCHIP_ARRAY = E.GENECHIP_ARRAY;

INSERT
  INTO database_cross_reference(gene_ID, CROSS_REFERENCE_ID, TYPE, source_NAME, 
source_TYPE)SELECT DISTINCT G.gene_ID, E.ENSEMBL_ID, 
'gov.nih.nci.cabio.domain.Gene', 'ENSEMBL_ID', 'Ensembl' FROM gene_tv G, 
zstg_rna_probesets Z, ar_ensembl E
WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID AND Z.PROBE_SET_ID = E.PROBE_SET_ID 
AND Z.geneCHIP_ARRAY = E.GENECHIP_ARRAY UNION SELECT DISTINCT G.GENE_ID, 
E.ENSEMBL_ID, 'gov.nih.nci.cabio.domain.Gene', 'ENSEMBL_ID', 'Ensembl' FROM 
gene_tv G, zstg_rna_probesets_tmp Z, ar_ensembl_tmp E
WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID AND Z.PROBE_SET_ID = E.PROBE_SET_ID 
AND Z.geneCHIP_ARRAY = E.GENECHIP_ARRAY;

DROP INDEX GTV_TMP_IDX2;

CREATE INDEX AR_REFSEQ_IDX ON ar_refseq_protein(PROBE_SET_ID) PARALLEL
NOLOGGING tablespace cabio_fut;
CREATE INDEX AR_REFSEQ_IDX_2 ON ar_refseq_protein(REFSEQ_PROTEIN_ID) tablespace cabio_fut;

# CHANGE THIS TO USING THE OTHER REFSEQ TABLE
INSERT
INTO database_cross_reference(PROTEIN_ID, CROSS_REFERENCE_ID, TYPE, source_NAME, 
source_TYPE) SELECT DISTINCT P.PROTEIN_ID ID, R.REFSEQ_PROTEIN_ID, 
'gov.nih.nci.cabio.domain.Protein', 'REFSEQ_PROTEIN_ID', 'RefSeq' FROM 
new_protein P, ar_swissprot S, ar_refseq_protein R
WHERE S.SWISSPROT_ID = P.PRIMARY_ACCESSION AND S.PROBE_SET_ID = R.PROBE_SET_ID 
UNION SELECT DISTINCT P.PROTEIN_ID ID, R.REFSEQ_PROTEIN_ID, 
'gov.nih.nci.cabio.domain.Protein', 'REFSEQ_PROTEIN_ID', 'RefSeq' FROM 
new_protein P, ar_swissprot_tmp S, ar_refseq_protein_tmp R
WHERE S.SWISSPROT_ID = P.PRIMARY_ACCESSION AND S.PROBE_SET_ID = R.PROBE_SET_ID
;

DROP INDEX AR_REFSEQ_IDX;
DROP INDEX AR_REFSEQ_IDX_2;
COMMIT;


ALTER TRIGGER SET_DBCROSSREF_ID DISABLE;
DROP INDEX GTV_TMP;
DROP INDEX G2G_TMP;

@$LOAD/indexes/database_cross_reference.cols.sql;
@$LOAD/indexes/database_cross_reference.lower.sql;
@$LOAD/constraints/database_cross_reference.enable.sql;
@$LOAD/triggers/database_cross_reference.enable.sql;

ANALYZE TABLE database_cross_reference COMPUTE STATISTICS;

EXIT;
