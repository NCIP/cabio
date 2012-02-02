ALTER TABLE CLONE_TV
 DROP PRIMARY KEY CASCADE
/
DROP TABLE CLONE_TV CASCADE CONSTRAINTS PURGE
/

--
-- CLONE_TV  (Table) 
--
--  Dependencies: 
--   LIBRARY (Table)
--
CREATE TABLE CLONE_TV ( CLONE_ID NUMBER NOT NULL, CLONE_NAME VARCHAR2(50 BYTE) NOT NULL, INSERT_SIZE NUMBER NULL, LIBRARY_ID NUMBER NOT NULL, TYPE VARCHAR2(50 BYTE) NULL, BIG_ID VARCHAR2(200 BYTE) NULL, CONSTRAINT CLONE_TV_PK PRIMARY KEY (CLONE_ID), CONSTRAINT CLONENODUPS UNIQUE (LIBRARY_ID, CLONE_NAME), CONSTRAINT CTVBIGID UNIQUE (BIG_ID), UNIQUE (CLONE_NAME, INSERT_SIZE, LIBRARY_ID, TYPE), CONSTRAINT CLONTVFK FOREIGN KEY (LIBRARY_ID) REFERENCES LIBRARY (LIBRARY_ID) DISABLE ) TABLESPACE CABIO_FUT LOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/

