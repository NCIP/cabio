/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

DROP TABLE NAS CASCADE CONSTRAINTS PURGE
/

--
-- NAS  (Table) 
--
CREATE TABLE NAS ( NA RAW(255) NOT NULL ) TABLESPACE CABIO_FUT LOGGING NOCOMPRESS NOCACHE NOPARALLEL MONITORING
/


