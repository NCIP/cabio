/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

SET SERVEROUTPUT ON;
WHENEVER SQLERROR EXIT SQL.SQLCODE;
WHENEVER OSERROR EXIT 9;
DROP SEQUENCE PDS_SEQ;
DROP SEQUENCE PAT_SEQ;
DROP SEQUENCE PRO_SEQ;
DROP TABLE protocol_agents;
DROP TABLE protocol_diseases;
DROP TABLE protocols;
EXIT;
