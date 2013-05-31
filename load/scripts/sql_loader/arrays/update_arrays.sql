/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- truncate tables

@truncate_tables;
@index_scripts;
@constraint_scripts;
@disable_constraints;
@drop_indexes;
-- drop indexes for loading

-- (re)create sequences

DROP SEQUENCE microarray_SEQ;
DROP SEQUENCE REPORTER_SEQ;
DROP SEQUENCE REL_LOCATION_SEQ;
DROP SEQUENCE protein_domain_SEQ;
DROP SEQUENCE FINAL_REP_SEQ;
DROP SEQUENCE exon_ID_SEQ;
DROP SEQUENCE XSCRIPT_ID_SEQ;
CREATE SEQUENCE microarray_SEQ;
CREATE SEQUENCE REPORTER_SEQ;
CREATE SEQUENCE REL_LOCATION_SEQ;
CREATE SEQUENCE protein_domain_SEQ;
CREATE SEQUENCE FINAL_REP_SEQ;
CREATE SEQUENCE exon_ID_SEQ;
CREATE SEQUENCE XSCRIPT_ID_SEQ;

ALTER TRIGGER SET_exon_ID ENABLE;
ALTER TRIGGER SET_XSCRIPT_ID ENABLE;
ALTER TRIGGER SET_PROTEIN_SEQ_ID ENABLE;
ALTER TRIGGER SET_EXPR_REP_ID ENABLE;
ALTER TRIGGER SET_SNP_REP_ID ENABLE;
ALTER TRIGGER SET_marker_REL_LOC_ID ENABLE; 
ALTER TRIGGER SET_gene_REL_LOC_ID ENABLE; 

-- create indexes on staging tables
-- done with array sql loader load
-- if you add an index here, remember to drop it in truncate_table_arrays.sql
-- Affy HGU-133 and HG-U133 Plus 2 arrays

INSERT
INTO microarray (ID, ARRAY_NAME, ANNOTATION_DATE, GENOME_VERSION, PLATFORM, TYPE
,
  DESCRIPTION, ACCESSION, LSID) SELECT microarray_SEQ.NEXTVAL, geneCHIP_ARRAY,
ANNO_DATE, GEN_VER, PLATFORM, TYPE, DESCRIPTION, ACCESSION, LSID FROM (SELECT 
DISTINCT DECODE(geneCHIP_ARRAY, 'Human Genome U133 Plus 2.0 Array',
'HG-U133_Plus_2') AS geneCHIP_ARRAY, TO_DATE(ANNOTATION_DATE, 'MON DD, YYYY') AS 
ANNO_DATE, replace(substr(genome_version, instr(genome_version, '(')+1), ')') AS GEN_VER, 'Affymetrix' AS PLATFORM, 'oligo' AS TYPE,
'Human Genome U133 Plus 2.0 Array' AS DESCRIPTION, 'GPL570' AS ACCESSION,
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HG-U133_Plus_2' AS LSID FROM 
zstg_rna_probesets Z
                                                             WHERE ROWNUM = 1);

COMMIT;

delete from zstg_rna_probesets_tmp where genechip_array = 'GeneChip Array';
delete from zstg_rna_probesets_tmp x where x.GENECHIP_ARRAY = 'please see the bundled README file.';
commit;

INSERT
INTO microarray (ID, ARRAY_NAME, ANNOTATION_DATE, GENOME_VERSION, PLATFORM, TYPE
,
  DESCRIPTION, ACCESSION, LSID) SELECT microarray_SEQ.NEXTVAL, geneCHIP_ARRAY,
ANNO_DATE, GEN_VER, PLATFORM, TYPE, DESCRIPTION, ACCESSION, LSID FROM (SELECT 
DISTINCT DECODE(geneCHIP_ARRAY, 'Human Genome U133A Array', 'HG-U133A',
'Human Genome U133A 2.0 Array', 'HG-U133A_2', 
'HT Human Genome U133A', 'HT_HG-U133A', 
'HT Human Genome U133B', 'HT_HG-U133B', 
'Human Genome U133B Array', 'HG-U133B', 'Human Genome U95Av2 Array', 'HG_U95Av2', 'Human Genome U95B Array', 'HG_U95B') AS GENECHIP_ARRAY, TO_DATE(
ANNOTATION_DATE, 'MON DD, YYYY') AS ANNO_DATE, replace(substr(genome_version, instr(genome_version, '(')+1), ')') AS GEN_VER,
'Affymetrix' AS PLATFORM, 'oligo' AS TYPE, geneCHIP_ARRAY AS DESCRIPTION, DECODE
(geneCHIP_ARRAY, 'Human Genome U133A Array', 'GPL96',
'Human Genome U133A 2.0 Array', 'GPL571', 'HT Human Genome U133A', 'GPL96', 'Human Genome U133B', 'GPL97') AS ACCESSION, DECODE(geneCHIP_ARRAY,
'Human Genome U133A Array',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HG-U133A',
'Human Genome U133A 2.0 Array',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HG-U133A_2',
'HT Human Genome U133A',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HT_HG-U133A',
'HT Human Genome U133B',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HT_HG-U133B',
'Human Genome U133B Array',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HG-U133B',
'Human Genome U95B Array',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HG_U95B',
'Human Genome U95Av2 Array',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:HG_U95Av2'
 ) AS LSID FROM 
zstg_rna_probesets_tmp Z);

COMMIT;

ANALYZE TABLE ar_alignments COMPUTE STATISTICS;
ANALYZE TABLE ar_alignments_tmp COMPUTE STATISTICS;

ANALYZE TABLE ar_chromosomal_location COMPUTE STATISTICS;
ANALYZE TABLE ar_chromosomal_location_tmp COMPUTE STATISTICS;

ANALYZE TABLE zstg_rna_probesets COMPUTE STATISTICS;
ANALYZE TABLE zstg_rna_probesets_tmp COMPUTE STATISTICS;

INSERT
  INTO zstg_expression_reporter (ID, NAME, microarray_ID, sequence_type,
SEQUENCE_source,
transcript_ID, target_DESCRIPTION, gene_ID, nas_ID, chromosome_ID, CHR_START,
CHR_STOP, CYTO_START,
CYTO_STOP, ASSEMBLY) SELECT REPORTER_SEQ.NEXTVAL, PROBE_SET_ID, microarray_ID,
SEQ_TYPE, SEQUENCE_source, transcript_ID, target_DESCRIPTION, GID, NID,
chromosome_ID, START_POSITION, END_POSITION, CYTO_START, CYTO_STOP, ASSEMBLY 
              FROM (SELECT DISTINCT Z.PROBE_SET_ID, Z.sequence_type AS SEQ_TYPE,
Z.SEQUENCE_source, Z.transcript_ID, M.ID AS microarray_ID, Z.target_DESCRIPTION,
G.gene_ID AS GID, N.ID AS NID, AL.chromosome_ID, AL.START_POSITION,
AL.END_POSITION, AC.CYTO_START, AC.CYTO_STOP, AL.ASSEMBLY FROM 
zstg_rna_probesets Z, microarray M, ar_alignments AL, ar_chromosomal_location AC
,
  (SELECT CLUSTER_ID, gene_ID FROM gene_tv
    WHERE taxon_ID = 5) G, nucleic_acid_sequence N
 WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID (+) AND Z.REPRESENTATIVE_PUBLIC_ID 
= N.ACCESSION_NUMBER (+) AND Z.PROBE_SET_ID = AL.PROBE_SET_ID(+) AND 
Z.PROBE_SET_ID = AC.PROBE_SET_ID(+) AND Z.geneCHIP_ARRAY = M.DESCRIPTION AND 
Z.geneCHIP_ARRAY = AL.GENECHIP_ARRAY(+) AND Z.GENECHIP_ARRAY =
AC.geneCHIP_ARRAY(+) 
UNION 
SELECT DISTINCT Z.PROBE_SET_ID, Z.sequence_type AS SEQ_TYPE, Z.SEQUENCE_source,
Z.transcript_ID, M.ID AS microarray_ID, Z.target_DESCRIPTION, G.gene_ID AS GID,
N.ID AS NID, AL.chromosome_ID, AL.START_POSITION, AL.END_POSITION, AC.CYTO_START
,
  AC.CYTO_STOP, AL.ASSEMBLY FROM zstg_rna_probesets_tmp Z, microarray M,
ar_alignments_tmp AL, ar_chromosomal_location_tmp AC, (SELECT CLUSTER_ID,
gene_ID FROM gene_tv
                   WHERE taxon_ID = 5) G, nucleic_acid_sequence N, chromosome C
 WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID (+) AND Z.REPRESENTATIVE_PUBLIC_ID 
= N.ACCESSION_NUMBER (+) AND Z.PROBE_SET_ID = AL.PROBE_SET_ID(+) AND 
Z.PROBE_SET_ID = AC.PROBE_SET_ID(+) AND Z.geneCHIP_ARRAY = M.DESCRIPTION AND 
Z.geneCHIP_ARRAY = AL.GENECHIP_ARRAY(+) AND Z.GENECHIP_ARRAY =
AC.geneCHIP_ARRAY(+));

COMMIT; 


DROP INDEX ZSTG_EXPRREP_PROBESETIDX;

INSERT
  INTO protein_domain (ACCESSION_NUMBER, DESCRIPTION, TYPE) SELECT DISTINCT 
ACCESSION_NUMBER, (SELECT DESCRIPTION FROM zstg_interpro
WHERE ACCESSION_NUMBER = Z.ACCESSION_NUMBER AND ROWNUM = 1), 'InterPro' FROM (
SELECT DISTINCT ACCESSION_NUMBER FROM zstg_interpro where description is not null) Z UNION SELECT DISTINCT 
ACCESSION_NUMBER, (SELECT DESCRIPTION FROM zstg_interpro_tmp
WHERE ACCESSION_NUMBER = Z.ACCESSION_NUMBER AND ROWNUM = 1), 'InterPro' FROM (
SELECT DISTINCT ACCESSION_NUMBER FROM zstg_interpro_tmp where description is not null) Z;

COMMIT;


-- Affy HuMapping arrays

INSERT
 INTO microarray (ID, ARRAY_NAME, GENOME_VERSION, DBSNP_VERSION, PLATFORM, TYPE,
DESCRIPTION, ACCESSION, LSID) SELECT microarray_SEQ.NEXTVAL, ARRAY_NAME,
GENOME_VERSION, DB_SNP_VERSION, 'Affymetrix', 'snp', DESCRIPTION, ACCESSION, LSID FROM 
(SELECT DISTINCT ARRAY_NAME, 'NCBI Build '||GENOME_VERSION as GENOME_VERSION, DB_SNP_VERSION, DECODE(ARRAY_NAME,
'Mapping250K_Nsp', 'Human Mapping 250K Nsp Array', 'Mapping250K_Sty',
'Human Mapping 250K Sty Array', 'Mapping50K_Hind240',
'Human Mapping 50K Array Hind 240', 'Mapping50K_Xba240',
'Human Mapping 50K Array Xba 240') AS DESCRIPTION, DECODE(ARRAY_NAME,
'Mapping250K_Nsp', 'GPL3718', 'Mapping250K_Sty', 'GPL3720', 'Mapping50K_Hind240'
,
  'GPL2004', 'Mapping50K_Xba240', 'GPL2005') AS ACCESSION, DECODE(ARRAY_NAME,
'Mapping250K_Nsp', 'URN:LSID:Affymetrix.com:PhysicalArrayDesign:Mapping250K_Nsp',
  'Mapping250K_Sty',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:Mapping250K_Sty',
  'Mapping50K_Hind240',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:Mapping50K_Hind240',
  'Mapping50K_Xba240',
'URN:LSID:Affymetrix.com:PhysicalArrayDesign:Mapping50K_Xba240'
) AS LSID FROM 
zstg_snp_affy Z);

COMMIT;

INSERT
INTO zstg_snp_reporter(ID, NAME, SNP_ID, microarray_ID, chromosome_ID, CHR_START
,
  CHR_STOP, CYTO_START, CYTO_STOP) SELECT REPORTER_SEQ.NEXTVAL, PROBE_SET_ID,
SNP_ID, ID, chromosome_ID, CHR_START, CHR_STOP, CYTO_START, CYTO_STOP FROM (
SELECT DISTINCT Z.PROBE_SET_ID, S.ID AS SNP_ID, M.ID, C.chromosome_ID,
Z.PHYSICAL_POSITION AS CHR_START, Z.PHYSICAL_POSITION AS CHR_STOP, Z.cytoband AS 
CYTO_START, Z.cytoband AS CYTO_STOP FROM zstg_snp_affy Z, snp_tv S, microarray M
,
  chromosome C
WHERE Z.chromosome = C.CHROMOSOME_NUMBER(+) AND Z.DBSNP_RS_ID = S.DB_SNP_ID (+
) AND M.DESCRIPTION = DECODE(Z.ARRAY_NAME, 'Mapping250K_Nsp',
'Human Mapping 250K Nsp Array', 'Mapping250K_Sty',
'Human Mapping 250K Sty Array', 'Mapping50K_Hind240',
'Human Mapping 50K Array Hind 240', 'Mapping50K_Xba240',
'Human Mapping 50K Array Xba 240') AND C.taxon_ID = 5 UNION SELECT DISTINCT 
Z.PROBE_SET_ID, S.ID AS SNP_ID, M.ID, NULL AS chromosome_ID, NULL AS CHR_START,
NULL AS CHR_STOP, NULL AS CYTO_START, NULL AS CYTO_STOP FROM zstg_snp_affy Z,
snp_tv S, microarray M
WHERE Z.DBSNP_RS_ID = S.DB_SNP_ID (+) AND M.DESCRIPTION = DECODE(Z.ARRAY_NAME,
'Mapping250K_Nsp', 'Human Mapping 250K Nsp Array', 'Mapping250K_Sty',
'Human Mapping 250K Sty Array', 'Mapping50K_Hind240',
'Human Mapping 50K Array Hind 240', 'Mapping50K_Xba240',
'Human Mapping 50K Array Xba 240'));

COMMIT;


ANALYZE TABLE zstg_snp_associated_gene COMPUTE STATISTICS;
ANALYZE TABLE zstg_snp_affy COMPUTE STATISTICS;
ANALYZE TABLE zstg_snp_illumina COMPUTE STATISTICS;

-- associated genes
INSERT
  INTO gene_relative_location (ORIENTATION, DISTANCE, GENE_ID, SNP_ID,
PROBE_SET_ID, TYPE) SELECT DISTINCT TYPE, DISTANCE, gene_ID, SNP_ID,
PROBE_SET_ID, TYPE_OLD FROM (SELECT DISTINCT DECODE(AG.ASSOCIATION_POSITION,
'flanking_3UTR', 'downstream', 'flanking_5UTR', 'upstream', 'coding', 'CDS',
AG.ASSOCIATION_POSITION) TYPE, MIN(AG.DISTANCE) DISTANCE, G.gene_ID, S.ID SNP_ID
,
  Z.PROBE_SET_ID, DECODE(AG.ASSOCIATION_POSITION, 'flanking_3UTR', 'downstream',
'flanking_5UTR', 'upstream', 'coding', 'CDS', AG.ASSOCIATION_POSITION) TYPE_OLD 
          FROM zstg_snp_associated_gene AG, zstg_snp_affy Z, gene_tv G, snp_tv S
WHERE AG.PROBESET_ID = Z.PROBE_SET_ID AND AG.ASSOCIATED_gene_SYMBOL = G.SYMBOL 
AND G.taxon_ID = 5 AND Z.DBSNP_RS_ID = S.DB_SNP_ID
               GROUP BY AG.ASSOCIATION_POSITION, G.gene_ID, S.ID, Z.PROBE_SET_ID
        UNION 
    SELECT DISTINCT DECODE(Z.LOCATION, 'flanking_3UTR', 'downstream',
'flanking_5UTR', 'upstream', 'coding', 'CDS', Z.LOCATION) TYPE, DECODE(
Z.LOCATION, 'coding', '0', '3UTR', '0', '5UTR', '0', 'UTR', '0',
Z.LOCATION_RELATIVE_TO_gene) DISTANCE, G.GENE_ID GENE_ID, S.ID SNP_ID,
Z.DBSNP_RS_ID PROBE_SET_ID, DECODE(Z.LOCATION, 'flanking_3UTR', 'downstream',
'flanking_5UTR', 'upstream', 'coding', 'CDS', Z.LOCATION) TYPE_OLD FROM 
zstg_snp_illumina Z, gene_tv G, snp_tv S
     WHERE Z.gene_SYMBOL = G.SYMBOL AND G.taxon_ID = 5 AND Z.DBSNP_RS_ID =
S.DB_SNP_ID);

COMMIT;

-- eliminate duplicates
 delete from gene_relative_location where ROWID NOT IN 
 (select MIN(ROWID) from gene_relative_location GROUP BY GENE_ID, SNP_ID, DISTANCE, ORIENTATION);
 
 commit;

-- Agilent 44K array

INSERT
 INTO microarray (ID, ARRAY_NAME, PLATFORM, TYPE, DESCRIPTION, ACCESSION) VALUES 
(microarray_SEQ.NEXTVAL, '014850_D', 'Agilent', 'oligo', 'Human Genome, Whole',
'GPL4133');
COMMIT;

ANALYZE TABLE zstg_rna_agilent COMPUTE STATISTICS;

INSERT
  INTO zstg_expression_reporter (ID, NAME, microarray_ID, gene_ID, nas_ID,
chromosome_ID, CHR_START, CHR_STOP, CYTO_START, CYTO_STOP) SELECT 
REPORTER_SEQ.NEXTVAL, PROBE_SET_ID, microarray_SEQ.CURRVAL, gene_ID, ID,
chromosome_ID, CHR_START, CHR_STOP, CYTO_START, CYTO_STOP FROM (SELECT DISTINCT 
Z.PROBE_SET_ID, G.gene_ID, N.ID, C.chromosome_ID, Z.CHR_START, Z.CHR_STOP,
Z.CYTO_START, Z.CYTO_STOP FROM zstg_rna_agilent Z, chromosome C,
nucleic_acid_sequence N, (SELECT CLUSTER_ID, gene_ID FROM gene_tv
                           WHERE taxon_ID = 5) G
     WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID (+) AND Z.chromosome_NUMBER =
C.chromosome_NUMBER(+) AND C.taxon_ID = 5 AND Z.PRIMARY_ACCESSION =
N.ACCESSION_NUMBER (+) 
UNION
SELECT DISTINCT Z.PROBE_SET_ID, G.gene_ID, N.ID, NULL AS chromosome_ID,
Z.CHR_START, Z.CHR_STOP, Z.CYTO_START, Z.CYTO_STOP FROM zstg_rna_agilent Z,
nucleic_acid_sequence N, (SELECT CLUSTER_ID, gene_ID FROM gene_tv
                           WHERE taxon_ID = 5) G
 WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID (+) AND Z.PRIMARY_ACCESSION =
N.ACCESSION_NUMBER (+)
);
COMMIT;

var microarray_id number;
SELECT microarray_SEQ.CURRVAL
  INTO :microarray_ID FROM DUAL;

UPDATE zstg_expression_reporter E SET nas_ID = (
SELECT N.ID FROM zstg_rna_agilent Z, nucleic_acid_sequence N
WHERE E.NAME = Z.PROBE_SET_ID AND Z.GENBANK_ACCESSION = N.ACCESSION_NUMBER (+)
)
 WHERE E.microarray_ID = MICROARRAY_ID AND E.nas_ID IS NULL;
COMMIT; 

UPDATE zstg_expression_reporter E SET nas_ID = (SELECT N.ID FROM 
zstg_rna_agilent Z, nucleic_acid_sequence N
WHERE E.NAME = Z.PROBE_SET_ID AND Z.REF_SEQ_ACCESSION = N.ACCESSION_NUMBER (+)
)
 WHERE E.microarray_ID = MICROARRAY_ID AND E.nas_ID IS NULL;

COMMIT;

-- Agilent CGH 244K array

INSERT
 INTO microarray (ID, ARRAY_NAME, PLATFORM, TYPE, DESCRIPTION, ACCESSION) VALUES 
(microarray_SEQ.NEXTVAL, '014693_D', 'Agilent', 'oligo', 'Human Genome CGH 244A'
,
  'GPL4091');
COMMIT;
SELECT microarray_SEQ.CURRVAL
  INTO :microarray_ID FROM DUAL;

ANALYZE TABLE zstg_cgh_agilent COMPUTE STATISTICS;

INSERT
  INTO zstg_expression_reporter (ID, NAME, microarray_ID, gene_ID, nas_ID,
chromosome_ID, CHR_START, CHR_STOP) SELECT REPORTER_SEQ.NEXTVAL, PROBE_SET_ID,
microarray_SEQ.CURRVAL, gene_ID, ID, chromosome_ID, PROBE_START, PROBE_END FROM 
(SELECT DISTINCT Z.PROBE_SET_ID, G.gene_ID, N.ID, C.chromosome_ID, Z.PROBE_START
,
  Z.PROBE_END FROM zstg_cgh_agilent Z, chromosome C, (SELECT SYMBOL, MIN(gene_ID
) gene_ID FROM gene_tv
                                                       WHERE taxon_ID = 5
    GROUP BY SYMBOL) G, (SELECT PROBE_SET_ID, ACCESSION FROM zstg_cgh_accessions
                                      WHERE IND = 0) A, nucleic_acid_sequence N
WHERE Z.gene_SYMBOL = G.SYMBOL (+) AND Z.PROBE_SET_ID = A.PROBE_SET_ID (+) AND 
A.ACCESSION = N.ACCESSION_NUMBER (+) AND Z.chromosome_NUMBER =
C.chromosome_NUMBER(+) AND C.taxon_ID = 5
UNION
SELECT DISTINCT Z.PROBE_SET_ID, G.gene_ID, N.ID, NULL AS chromosome_ID,
Z.PROBE_START, Z.PROBE_END FROM zstg_cgh_agilent Z, (SELECT SYMBOL, MIN(gene_ID) 
gene_ID FROM gene_tv
                                                      WHERE taxon_ID = 5
    GROUP BY SYMBOL) G, (SELECT PROBE_SET_ID, ACCESSION FROM zstg_cgh_accessions
                                      WHERE IND = 0) A, nucleic_acid_sequence N
 WHERE Z.gene_SYMBOL = G.SYMBOL(+) AND Z.PROBE_SET_ID = A.PROBE_SET_ID(+) AND 
A.ACCESSION = N.ACCESSION_NUMBER(+));

COMMIT; 
CREATE INDEX ER_NAME_INDEX ON zstg_expression_reporter(NAME) tablespace cabio_map_fut;

UPDATE zstg_expression_reporter E SET nas_ID = (SELECT N.ID FROM 
zstg_cgh_accessions A, nucleic_acid_sequence N
 WHERE A.ACCESSION = N.ACCESSION_NUMBER AND A.PROBE_SET_ID = E.NAME AND ROWNUM 
= 1)
 WHERE E.microarray_ID = MICROARRAY_ID AND E.nas_ID IS NULL;

COMMIT;

-- Illumina 550K array

INSERT
  INTO microarray (ID, ARRAY_NAME, GENOME_VERSION, PLATFORM, TYPE, DESCRIPTION,
ACCESSION, LSID) SELECT microarray_SEQ.NEXTVAL, 'HumanHap550Kv3', 'NCBI Build '||GENOME_BUILD,
'Illumina', 'snp', 'HumanHap550 Genotyping BeadChip' AS DESCRIPTION, '' AS ACCESSION, 'URN:LSID:illumina.com:PhysicalArrayDesign:HumanHap550v3_A' as LSID FROM zstg_snp_illumina Z
            WHERE ROWNUM = 1;
COMMIT;
SELECT microarray_SEQ.CURRVAL
  INTO :microarray_ID FROM DUAL;


INSERT
  INTO zstg_snp_reporter(ID, NAME, microarray_ID, SNP_ID, PHAST_CONSERVATION,
chromosome_ID, CHR_START, CHR_STOP) SELECT REPORTER_SEQ.NEXTVAL, DBSNP_RS_ID,
microarray_SEQ.CURRVAL, ID, PHAST_CONSERVATION, chromosome_ID, CHR_START,
CHR_STOP FROM (SELECT DISTINCT Z.DBSNP_RS_ID, S.ID, Z.PHAST_CONSERVATION,
C.chromosome_ID, Z.COORDINATE AS CHR_START, Z.COORDINATE AS CHR_STOP FROM 
zstg_snp_illumina Z, chromosome C, snp_tv S
WHERE Z.DBSNP_RS_ID = S.DB_SNP_ID (+) AND Z.chromosome = C.CHROMOSOME_NUMBER(+
) AND C.taxon_ID = 5 UNION SELECT DISTINCT Z.DBSNP_RS_ID, S.ID,
Z.PHAST_CONSERVATION, NULL AS chromosome_ID, Z.COORDINATE AS CHR_START,
Z.COORDINATE AS CHR_STOP FROM zstg_snp_illumina Z, snp_tv S
                            WHERE Z.DBSNP_RS_ID = S.DB_SNP_ID (+));

COMMIT;

-- Affymetrix HuExon Array

INSERT
  INTO transcript (MANUFACTURER_ID, STRAND, PROBE_COUNT, source) SELECT DISTINCT 
transcript_CLUSTER_ID, STRAND, TOTAL_PROBES, 'Affymetrix' FROM 
zstg_exon_trans_affy;
COMMIT;
ANALYZE TABLE transcript COMPUTE STATISTICS;

CREATE INDEX transcript_MI_INDEX ON TRANSCRIPT(MANUFACTURER_ID) tablespace cabio_fut;

INSERT
  INTO exon (MANUFACTURER_ID, transcript_ID, source) SELECT EXON_ID, ID,
'Affymetrix' FROM (SELECT DISTINCT Z.exon_ID, T.ID FROM zstg_exon_affy Z,
transcript T
                    WHERE Z.transcript_CLUSTER_ID = T.MANUFACTURER_ID);
COMMIT;
CREATE INDEX exon_MI_INDEX ON EXON(MANUFACTURER_ID) tablespace cabio_fut;

INSERT
 INTO microarray (ID, ARRAY_NAME, PLATFORM, TYPE, DESCRIPTION, ACCESSION, LSID) SELECT 
microarray_SEQ.NEXTVAL, 'HuEx-1_0-st-v2', 'Affymetrix', 'exon',
'Human Exon 1.0 ST Array', 'GPL5188','URN:LSID:Affymetrix.com:PhysicalArrayDesign:HuEx-1_0-st-v2'  FROM DUAL;

commit;

update microarray set genome_version = (select distinct 'NCBI Build '||genome_version from zstg_exon_trans_genes) where ARRAY_NAME = 'HuEx-1_0-st-v2';
commit;

SELECT microarray_SEQ.CURRVAL
  INTO :microarray_ID FROM DUAL;

INSERT
  INTO zstg_exon_reporter (ID, NAME, microarray_ID, MANUFACTURER_PSR_ID,
PROBE_COUNT, STRAND, transcript_ID, exon_ID, chromosome_ID, START_LOCATION,
STOP_LOCATION) SELECT REPORTER_SEQ.NEXTVAL, PROBE_SET_ID, microarray_SEQ.CURRVAL
,
  PSR_ID, PROBE_COUNT, STRAND, TRANS_ID, ID, chromosome_ID, START_LOCATION,
STOP_LOCATION FROM (SELECT DISTINCT Z.PROBE_SET_ID, Z.PSR_ID, Z.PROBE_COUNT,
Z.STRAND, T.ID AS TRANS_ID, E.ID, C.chromosome_ID, Z.START_LOCATION,
Z.STOP_LOCATION FROM zstg_exon_affy Z, chromosome C, transcript T, EXON E
             WHERE Z.transcript_CLUSTER_ID = T.MANUFACTURER_ID AND Z.exon_ID =
E.MANUFACTURER_ID AND SUBSTR(Z.SEQNAME, 4) = C.chromosome_NUMBER (+) AND 
C.taxon_ID = 5 UNION SELECT DISTINCT Z.PROBE_SET_ID, Z.PSR_ID, Z.PROBE_COUNT,
Z.STRAND, T.ID, E.ID, NULL AS chromosome_ID, Z.START_LOCATION, Z.STOP_LOCATION 
                       FROM zstg_exon_affy Z, transcript T, EXON E
             WHERE Z.transcript_CLUSTER_ID = T.MANUFACTURER_ID AND Z.exon_ID =
E.MANUFACTURER_ID);
COMMIT;

INSERT
  INTO exon_reporter (NAME, microarray_ID, MANUFACTURER_PSR_ID, PROBE_COUNT,
STRAND, transcript_ID, exon_ID) SELECT DISTINCT NAME, microarray_ID,
MANUFACTURER_PSR_ID, PROBE_COUNT, STRAND, transcript_ID, exon_ID FROM 
zstg_exon_reporter;
COMMIT;

CREATE INDEX ER_TI_INDEX ON exon_reporter(transcript_ID) tablespace cabio_fut;
ANALYZE TABLE exon_reporter COMPUTE STATISTICS;


INSERT
  INTO transcript_gene SELECT T.ID, G.GENE_ID FROM ZSTG_exon_TRANS_GENES Z,
transcript T, gene_tv G
     WHERE Z.UNIgene_ID = 'Hs.' || G.CLUSTER_ID AND Z.transcript_CLUSTER_ID =
T.MANUFACTURER_ID;
COMMIT;
CREATE INDEX TG_TI_INDEX ON transcript_gene(TRANSCRIPT_ID) tablespace cabio_fut;
ANALYZE TABLE transcript_gene COMPUTE STATISTICS;


INSERT
INTO exon_reporter_gene SELECT E.ID, TG.GENE_ID FROM exon_reporter E, transcript 
T, transcript_gene TG
                     WHERE E.transcript_ID = T.ID AND T.ID = TG.TRANSCRIPT_ID;
COMMIT;

INSERT
  INTO expression_reporter (NAME, microarray_ID, sequence_type, SEQUENCE_source,
transcript_ID, target_DESCRIPTION, gene_ID, nas_ID) SELECT DISTINCT NAME,
microarray_ID, sequence_type, SEQUENCE_source, transcript_ID, target_DESCRIPTION
,
  gene_ID, nas_ID FROM zstg_expression_reporter;
COMMIT;

INSERT
  INTO expr_reporter_protein_domain (EXPR_REPORTER_ID, protein_domain_ID) SELECT 
DISTINCT ER.ID, PD.ID FROM zstg_interpro Z, protein_domain PD,
expression_reporter ER
   WHERE Z.PROBE_SET_ID = ER.NAME AND Z.ACCESSION_NUMBER = PD.ACCESSION_NUMBER 
UNION SELECT DISTINCT ER.ID, PD.ID FROM zstg_interpro_tmp Z, protein_domain PD,
expression_reporter ER
  WHERE Z.PROBE_SET_ID = ER.NAME AND Z.ACCESSION_NUMBER = PD.ACCESSION_NUMBER;
COMMIT;

INSERT
  INTO snp_reporter(NAME, SNP_ID, microarray_ID) SELECT DISTINCT NAME, SNP_ID,
microarray_ID FROM zstg_snp_reporter;
COMMIT;

INSERT
INTO marker_relative_location (TYPE, DISTANCE, ORIENTATION, SNP_ID, PROBE_SET_ID
) SELECT DISTINCT TYPE, DISTANCE, DECODE(ORIENTATION, 'downstream', 'upstream',
'upstream', 'downstream', ORIENTATION), SNP_ID, PROBE_SET_ID FROM (SELECT 
DISTINCT TYPE, DISTANCE, '' AS ORIENTATION, SR.SNP_ID, Z.PROBE_SET_ID FROM 
zstg_geneTIC_MAP Z, snp_reporter SR
 WHERE Z.PROBE_SET_ID = SR.NAME AND SR.SNP_ID IS NOT NULL UNION SELECT DISTINCT 
'Microsatellite', Z.DISTANCE, Z.RELATIVE_POSITION, SR.SNP_ID, Z.PROBE_SET_ID 
                                     FROM zstg_microsatellite Z, snp_reporter SR
                     WHERE Z.PROBE_SET_ID = SR.NAME AND SR.SNP_ID IS NOT NULL);
COMMIT;

-- fix for GF12202 
 delete from marker_relative_location where ROWID NOT IN 
 (select MIN(ROWID) from marker_relative_location GROUP BY SNP_ID, TYPE, ORIENTATION);
 commit; 

-- these statements attempt to ensure that
-- the next 4 inserts do not choose a cartesian join path
ANALYZE TABLE marker_relative_location COMPUTE STATISTICS;

-- first TSC id
INSERT
 INTO marker_marker_rel_location (marker_ID, MARKER_REL_LOCATION_ID, SORT_ORDER) 
SELECT M.ID, MRL.ID, 1 FROM zstg_geneTIC_MAP Z, marker_relative_location MRL,
marker M
 WHERE Z.PROBE_SET_ID = MRL.PROBE_SET_ID AND Z.FIRST_SNP_TSC_ID = M.marker_ID 
AND MRL.TYPE = 'SLM1' AND M.TYPE = 'TSC';

COMMIT;

-- second TSC id
INSERT
 INTO marker_marker_rel_location (marker_ID, MARKER_REL_LOCATION_ID, SORT_ORDER) 
SELECT M.ID, MRL.ID, 2 FROM zstg_geneTIC_MAP Z, marker_relative_location MRL,
marker M
 WHERE Z.PROBE_SET_ID = MRL.PROBE_SET_ID AND Z.SECOND_SNP_TSC_ID = M.marker_ID 
AND MRL.TYPE = 'SLM1' AND M.TYPE = 'TSC';
COMMIT;

INSERT
 INTO marker_marker_rel_location (marker_ID, MARKER_REL_LOCATION_ID, SORT_ORDER) 
SELECT marker_ID, MARKER_REL_LOCATION_ID, 1 AS SORT_ORDER FROM (SELECT M.ID AS 
marker_ID, MRL.ID AS MARKER_REL_LOCATION_ID FROM zstg_geneTIC_MAP Z,
marker_relative_location MRL, marker_lookup M
             WHERE Z.PROBE_SET_ID = MRL.PROBE_SET_ID AND Z.TYPE = MRL.TYPE AND 
Z.FIRST_marker_ID = M.NAME AND M.taxon_ID = 5);
COMMIT;


-- second marker id

-- does a join with marker alias

INSERT
 INTO marker_marker_rel_location (marker_ID, MARKER_REL_LOCATION_ID, SORT_ORDER) 
SELECT marker_ID, MARKER_REL_LOCATION_ID, 2 AS SORT_ORDER FROM (SELECT M.ID AS 
marker_ID, MRL.ID AS MARKER_REL_LOCATION_ID FROM zstg_geneTIC_MAP Z,
marker_relative_location MRL, marker_lookup M
             WHERE Z.PROBE_SET_ID = MRL.PROBE_SET_ID AND Z.TYPE = MRL.TYPE AND 
Z.SECOND_marker_ID = M.NAME AND M.taxon_ID = 5) ;
COMMIT;

-- does a join with marker alias as well
-- decode(ORIENTATION,'downstream','upstream','upstream','downstream',ORIENTATION)
INSERT
INTO marker_marker_rel_location (marker_ID, MARKER_REL_LOCATION_ID) SELECT M.ID,
MRL.ID FROM zstg_microsatellite Z, marker_relative_location MRL, marker_lookup M
,
  marker MRK
     WHERE Z.PROBE_SET_ID = MRL.PROBE_SET_ID AND Z.RELATIVE_POSITION = DECODE(
MRL.ORIENTATION, 'downstream', 'upstream', 'upstream', 'downstream') AND M.NAME 
= Z.marker AND M.ID = MRK.ID AND MRK.TYPE = 'UNISTS' AND M.taxon_ID = 5;
COMMIT;

-- add annotation versions to microarray table

UPDATE microarray m SET annotation_version = 
    (select annotation_version from zstg_microarray_versions v where v.array_name = m.array_name); 
commit;
UPDATE microarray m SET  genome_version = 
    (select genome_version from ar_rna_probesets_affy_tmp v where v.array_name = m.array_name) where genome_version is null; 
commit;

-- create indexes on user tables

@create_indexes;
@enable_constraints;

-- analyze tables

ANALYZE TABLE protein_domain COMPUTE STATISTICS;
ANALYZE TABLE gene_relative_location COMPUTE STATISTICS;
ANALYZE TABLE marker_marker_rel_location COMPUTE STATISTICS;
ANALYZE TABLE marker_relative_location COMPUTE STATISTICS;
ANALYZE TABLE marker COMPUTE STATISTICS;
ANALYZE TABLE expression_reporter COMPUTE STATISTICS;
ANALYZE TABLE expr_reporter_protein_domain COMPUTE STATISTICS;
ANALYZE TABLE snp_reporter COMPUTE STATISTICS;
ANALYZE TABLE exon_reporter_gene COMPUTE STATISTICS;
ANALYZE TABLE exon COMPUTE STATISTICS;
ANALYZE TABLE microarray COMPUTE STATISTICS;

COMMIT;
exit;
