DROP TABLE GENE_HISTOPATHOLOGY CASCADE CONSTRAINTS PURGE
/

--
-- GENE_HISTOPATHOLOGY  (Table) 
--
--  Dependencies: 
--   GENE_TV (Table)
--
CREATE TABLE GENE_HISTOPATHOLOGY ( GENE_ID NUMBER NOT NULL, CONTEXT_CODE NUMBER NOT NULL, FOREIGN KEY (GENE_ID) REFERENCES GENE_TV (GENE_ID) ) TABLESPACE CABIO_FUT NOLOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/

