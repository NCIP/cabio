DROP TABLE ZSTG_SNP_TSC CASCADE CONSTRAINTS PURGE
/

--
-- ZSTG_SNP_TSC  (Table) 
--
CREATE TABLE ZSTG_SNP_TSC ( TSC_ID VARCHAR2(50 BYTE) NOT NULL, SS_ID VARCHAR2(20 BYTE) NOT NULL, DBSNP_RS_ID VARCHAR2(18 BYTE) NOT NULL ) TABLESPACE CABIO_MAP_FUT LOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/

