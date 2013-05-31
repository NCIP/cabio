/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

ALTER TABLE LOCATION_CH_43
 DROP PRIMARY KEY CASCADE;

DROP TABLE LOCATION_CH_43 CASCADE CONSTRAINTS;

CREATE TABLE LOCATION_CH_43
(
  ID                          NUMBER            NOT NULL,
  GENE_ID                     NUMBER,
  NUCLEIC_ACID_ID             NUMBER,
  SNP_ID                      NUMBER,
  CHROMOSOME_ID               NUMBER            NOT NULL,
  CHROMOSOMAL_START_POSITION  NUMBER,
  CHROMOSOMAL_END_POSITION    NUMBER,
  TRANSCRIPT_ID               NUMBER,
  EXON_REPORTER_ID            NUMBER,
  CYTOBAND_ID                 NUMBER,
  START_CYTOBAND_LOC_ID       NUMBER,
  END_CYTOBAND_LOC_ID         NUMBER,
  DISCRIMINATOR               VARCHAR2(100 BYTE) NOT NULL,
  CYTO_GENE_ID                NUMBER,
  CYTO_SNP_ID                 NUMBER,
  MARKER_ID                   NUMBER,
  ARRAY_REPORTER_ID           NUMBER,
  CYTO_REPORTER_ID            NUMBER,
  FEATURE_TYPE                VARCHAR2(40 BYTE),
  ASSEMBLY                    VARCHAR2(40 BYTE) DEFAULT 'reference' NOT NULL,
  BIG_ID                      VARCHAR2(100 BYTE),
  CONSERVATION_PVALUE         VARCHAR2(50 BYTE),
  CONSERVATION_SCORE          NUMBER,
  MULTIPLE_ALIGNMENT_ID       NUMBER
)
TABLESPACE CABIO_FUT
PCTUSED    0
PCTFREE    10
INITRANS   1
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOLOGGING 
NOCOMPRESS 
NOCACHE
NOPARALLEL
MONITORING;

ALTER TABLE LOCATION_CH_43 ADD (
  CONSTRAINT LCHNP_PK
 PRIMARY KEY
 (ID) DISABLE);
