--
-- This script adds Compara data into caBIO user tables. 
-- The following tables are populated:
-- TAXON, MULTIPLE_ALIGNMENT, MULTIPLE_ALIGNMENT_TAXON LOCATION_CH_43
--

-- Revert to static taxons 

truncate table TAXON;
insert into TAXON select from ZSTG_TAXON;

-- Create taxon id sequence

DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(TAXON_ID)+1 INTO N FROM TAXON;
    Execute immediate ('DROP SEQUENCE TAXON_SEQ');
    Execute immediate ('CREATE SEQUENCE TAXON_SEQ START WITH '||N);
END;

-- Insert new species into Taxon

insert into TAXON (TAXON_ID, SCIENTIFIC_NAME, COMMON_NAME)
    select TAXON_SEQ.NEXTVAL, s.SCIENTIFIC_NAME, s.COMMON_NAME
    from (
        select distinct z.SCIENTIFIC_NAME, z.COMMON_NAME from 
            (select distinct SCIENTIFIC_NAME from ZSTG_COMPARA_SPECIES
            MINUS
            select distinct SCIENTIFIC_NAME from TAXON) d, ZSTG_COMPARA_SPECIES z
        WHERE d.SCIENTIFIC_NAME = z.SCIENTIFIC_NAME
    ) s
    
commit;

-- Insert methods

DROP SEQUENCE MULTI_ALIGN_SEQ;
CREATE SEQUENCE MULTI_ALIGN_SEQ;

truncate table MULTIPLE_ALIGNMENT;
insert into MULTIPLE_ALIGNMENT
    select MULTI_ALIGN_SEQ.NEXTVAL, METHOD_NAME, 'Ensembl Compara', METHOD_CLASS, METHOD_ID  
    from ZSTG_COMPARA_METHODS;

truncate table MULTIPLE_ALIGNMENT_TAXON;
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

truncate table LOCATION_CH_43;

--insert into LOCATION_CH_43 select * from LOCATION_CH;
-- Create a view for now because there isn't enough space in the database to 
-- duplicate LOCATION_CH 

create or replace view LOCATION_43 as
    select * from location_ch
    UNION ALL 
    select * from location_ch_43;

-- Insert constrained regions

DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(ID)+1 INTO N FROM LOCATION_CH_43;
    Execute immediate ('DROP SEQUENCE LOCATION43_SEQ');
    Execute immediate ('CREATE SEQUENCE LOCATION43_SEQ START WITH '||N);
END;

insert into LOCATION_CH_43 (ID, CHROMOSOME_ID, DISCRIMINATOR, ASSEMBLY,
        CHROMOSOMAL_START_POSITION, CHROMOSOMAL_END_POSITION, 
        CONSERVATION_PVALUE, CONSERVATION_SCORE, MULTIPLE_ALIGNMENT_ID)
    select LOCATION43_SEQ.NEXTVAL, c.CHROMOSOME_ID, 'ConstrainedRegion', 'reference',
           z.START_LOC, z.END_LOC, z.PVALUE, z.SCORE, m.ID
    from ZSTG_COMPARA_REGIONS z, MULTIPLE_ALIGNMENT m, CHROMOSOME c
    where z.METHOD_ID = m.ORIG_COMPARA_ID
    and c.CHROMOSOME_NUMBER = z.CHROMOSOME_NAME
    and c.TAXON_ID = 5;

commit;

-- analyze tables

ANALYZE TABLE TAXON COMPUTE STATISTICS;
ANALYZE TABLE MULTIPLE_ALIGNMENT COMPUTE STATISTICS;
ANALYZE TABLE MULTIPLE_ALIGNMENT_TAXON COMPUTE STATISTICS;
ANALYZE TABLE LOCATION_CH_43 COMPUTE STATISTICS;

commit;
exit;
