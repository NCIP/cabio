DROP TABLE ZSTG_CGH_ACCESSIONS CASCADE CONSTRAINTS PURGE
/

--
-- ZSTG_CGH_ACCESSIONS  (Table) 
--
CREATE TABLE ZSTG_CGH_ACCESSIONS ( PROBE_SET_ID VARCHAR2(20 BYTE) NOT NULL, IND VARCHAR2(20 BYTE) NOT NULL, SOURCE VARCHAR2(10 BYTE) NOT NULL, ACCESSION VARCHAR2(40 BYTE) NOT NULL ) TABLESPACE CABIO_MAP_FUT NOLOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/

