/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- This script adds Compara data into caBIO user tables. 
-- The following tables are populated:
-- TAXON, MULTIPLE_ALIGNMENT, MULTIPLE_ALIGNMENT_TAXON LOCATION_CH_43
--

-- Revert to static taxons 

insert into TAXON select * from ZSTG_TAXON;
commit;

DROP SEQUENCE TAXON_SEQ;
-- Create taxon id sequence

DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(TAXON_ID)+1 INTO N FROM TAXON;
--    Execute immediate ('DROP SEQUENCE TAXON_SEQ');
    Execute immediate ('CREATE SEQUENCE TAXON_SEQ START WITH '||N);
END;
/

-- Insert new species into Taxon

insert into TAXON (TAXON_ID, SCIENTIFIC_NAME, COMMON_NAME)
    select TAXON_SEQ.NEXTVAL, s.SCIENTIFIC_NAME, s.COMMON_NAME
    from (
        select distinct z.SCIENTIFIC_NAME, z.COMMON_NAME from 
            (select distinct SCIENTIFIC_NAME from ZSTG_COMPARA_SPECIES
            MINUS
            select distinct SCIENTIFIC_NAME from TAXON) d, ZSTG_COMPARA_SPECIES z
        WHERE d.SCIENTIFIC_NAME = z.SCIENTIFIC_NAME
    ) s;
    
commit;

-- Insert methods

DROP SEQUENCE MULTI_ALIGN_SEQ;
CREATE SEQUENCE MULTI_ALIGN_SEQ;

insert into MULTIPLE_ALIGNMENT
    select MULTI_ALIGN_SEQ.NEXTVAL, METHOD_NAME, 'Ensembl Compara', METHOD_CLASS, METHOD_ID  
    from ZSTG_COMPARA_METHODS;

insert into MULTIPLE_ALIGNMENT_TAXON (MULTIPLE_ALIGNMENT_ID, TAXON_ID)
    select m.ID, t.TAXON_ID
    from MULTIPLE_ALIGNMENT m, ZSTG_COMPARA_SPECIES z, TAXON t
    where m.ORIG_COMPARA_ID = z.METHOD_ID
    and z.SCIENTIFIC_NAME = t.SCIENTIFIC_NAME
    and t.STRAIN_OR_ETHNICITY IS NULL;

commit;

-- Create new LOCATION_CH table for 4.3. Since we are adding subclasses,
-- we can't add them into LOCATION_CH because the older APIs will not know 
-- how to handle instances with the 'ConstrainedRegion' discriminator.

insert into LOCATION_CH_43(ID, GENE_ID, NUCLEIC_ACID_ID, SNP_ID, CHROMOSOME_ID, CHROMOSOMAL_START_POSITION, CHROMOSOMAL_END_POSITION, TRANSCRIPT_ID, EXON_REPORTER_ID, CYTOBAND_ID, START_CYTOBAND_LOC_ID, END_CYTOBAND_LOC_ID, DISCRIMINATOR, CYTO_GENE_ID, CYTO_SNP_ID, MARKER_ID, ARRAY_REPORTER_ID, CYTO_REPORTER_ID, FEATURE_TYPE, ASSEMBLY, BIG_ID) select * from LOCATION_CH;
commit;

DROP SEQUENCE LOCATION43_SEQ;

-- Insert constrained regions

DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(ID)+1 INTO N FROM LOCATION_CH_43;
--    Execute immediate ('DROP SEQUENCE LOCATION43_SEQ');
    Execute immediate ('CREATE SEQUENCE LOCATION43_SEQ START WITH '||N);
END;
/

insert into LOCATION_CH_43 (ID, CHROMOSOME_ID, DISCRIMINATOR, ASSEMBLY,
        CHROMOSOMAL_START_POSITION, CHROMOSOMAL_END_POSITION, 
        CONSERVATION_PVALUE, CONSERVATION_SCORE, MULTIPLE_ALIGNMENT_ID)
    select LOCATION43_SEQ.NEXTVAL, c.CHROMOSOME_ID, 'ConstrainedRegion', 'GRCh37',
           z.START_LOC, z.END_LOC, z.PVALUE, z.SCORE, m.ID
    from ZSTG_COMPARA_REGIONS z, MULTIPLE_ALIGNMENT m, CHROMOSOME c
    where z.METHOD_ID = m.ORIG_COMPARA_ID
    and c.CHROMOSOME_NUMBER = z.CHROMOSOME_NAME
    and c.TAXON_ID = 5;

commit;

-- enable indexes and constraints

@lch43_indexes.sql

@$LOAD/indexes/taxon.lower.sql
@$LOAD/indexes/multiple_alignment.lower.sql
@$LOAD/indexes/multiple_alignment_taxon.lower.sql
@$LOAD/indexes/location_ch_43.lower.sql

@$LOAD/indexes/taxon.cols.sql
@$LOAD/indexes/multiple_alignment.cols.sql
@$LOAD/indexes/multiple_alignment_taxon.cols.sql
@$LOAD/indexes/location_ch_43.cols.sql

@$LOAD/constraints/taxon.enable.sql
@$LOAD/constraints/multiple_alignment.enable.sql
@$LOAD/constraints/multiple_alignment_taxon.enable.sql
@$LOAD/constraints/location_ch_43.enable.sql

-- analyze tables

ANALYZE TABLE TAXON COMPUTE STATISTICS;
ANALYZE TABLE MULTIPLE_ALIGNMENT COMPUTE STATISTICS;
ANALYZE TABLE MULTIPLE_ALIGNMENT_TAXON COMPUTE STATISTICS;
ANALYZE TABLE LOCATION_CH_43 COMPUTE STATISTICS;

commit;
exit;
