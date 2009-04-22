DROP TABLE ZSTG_PATHWAYCOMPONENTS CASCADE CONSTRAINTS PURGE
/

--
-- ZSTG_PATHWAYCOMPONENTS  (Table) 
--
CREATE TABLE ZSTG_PATHWAYCOMPONENTS ( PATHWAY_ID VARCHAR2(2500 BYTE) NOT NULL, SOURCE_ID VARCHAR2(2500 BYTE) NOT NULL, INTERACTION_ID VARCHAR2(2500 BYTE) NOT NULL ) TABLESPACE CABIO_MAP_FUT NOLOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/

