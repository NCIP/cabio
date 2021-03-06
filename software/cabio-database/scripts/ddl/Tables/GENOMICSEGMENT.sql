/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

DROP TABLE GENOMICSEGMENT CASCADE CONSTRAINTS PURGE
/

--
-- GENOMICSEGMENT  (Table) 
--
CREATE TABLE GENOMICSEGMENT ( GENOMICSEGMENT_ID NUMBER NOT NULL, CLONEDESIGNATOR VARCHAR2(50 BYTE) NULL, SEGMENTSIZE VARCHAR2(50 BYTE) NULL, SEGMENTTYPE_ID NUMBER NULL, ANIMALMODEL_ID NUMBER NULL, LOCATIONOFINTEGRATION VARCHAR2(100 BYTE) NULL, INTEGRATIONTYPE_ID NUMBER NULL, UNIQUE (GENOMICSEGMENT_ID, CLONEDESIGNATOR, SEGMENTSIZE, SEGMENTTYPE_ID, ANIMALMODEL_ID, LOCATIONOFINTEGRATION, INTEGRATIONTYPE_ID) ) TABLESPACE CABIO_MAP_FUT NOLOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/


