SET SERVEROUTPUT ON;
--WHENEVER SQLERROR EXIT SQL.SQLCODE;
--WHENEVER OSERROR EXIT 9;
DROP DATABASE LINK cmap;
CREATE DATABASE LINK cmap
CONNECT TO cmap IDENTIFIED BY "qa!cmap1234"
USING 'BIOQA';
column columnprod new_value prod_tablspc;
select globals.get_production_tablespace as columnprod from dual;
-- drop indexes
DROP INDEX protocol_DOCUMENT_IND;
DROP INDEX protocol_agents_AGENT_IND;
DROP INDEX protocol_disease_INDEX;
DROP INDEX protocol_disease_PROTOCOL_IND;
DROP INDEX protocol_IMT_INDEX;

DROP TABLE protocol_agents;
DROP TABLE protocol_diseases;
DROP TABLE protocols;

-- create new tables
CREATE TABLE protocols (
  ID                         NUMBER (10)   NOT NULL, 
  DOCUMENT_NUMBER            VARCHAR2 (35), 
  TITLE                      VARCHAR2 (2000), 
  PHASE                      VARCHAR2 (10), 
  PARTICIPATION_TYPE         VARCHAR2 (35), 
  TREATMENT_FLAG             VARCHAR2 (5), 
  NIH_ADMIN_CODE             VARCHAR2 (10), 
  CURRENT_STATUS             VARCHAR2 (40), 
  CURRENT_STATUS_DATE        DATE, 
  LEAD_organIZATION_CTEP_ID  VARCHAR2 (6), 
  LEAD_organIZATION_NAME     VARCHAR2 (100), 
  PI_NAME                    VARCHAR2 (85), 
  REVIEWER_NAME              VARCHAR2 (85), 
  PDQ_protocol_CODE          VARCHAR2 (50),
  BIG_ID                     VARCHAR2(200)
) tablespace &prod_tablspc;

CREATE TABLE protocol_agents ( 
  PRO_ID    NUMBER (10)   NOT NULL, 
  agent_ID  NUMBER        NOT NULL
) tablespace &prod_tablspc;

CREATE TABLE protocol_diseases ( 
  ID                    NUMBER (10)   NOT NULL, 
  PRO_ID                NUMBER (10)   NOT NULL, 
  IMT_CODE              NUMBER (8), 
  CTEP_NAME             VARCHAR2 (100), 
  disease_SUB_CATEGORY  VARCHAR2 (255), 
  disease_CATEGORY      VARCHAR2 (255), 
  histology_code        NUMBER, 
  concept_ID            VARCHAR2 (10),
  BIG_ID                VARCHAR2(200)
) tablespace &prod_tablspc;
 
@$LOAD/indexer_new.sql protocols
@$LOAD/indexer_new.sql protocol_agents
@$LOAD/constraints.sql protocol_diseases
@$LOAD/constraints.sql protocols
@$LOAD/constraints.sql protocol_agents
@$LOAD/constraints.sql protocol_diseases

@$LOAD/indexes/protocols.drop.sql
@$LOAD/indexes/protocol_agents.drop.sql
@$LOAD/indexes/protocol_diseases.drop.sql

INSERT INTO protocols(ID, DOCUMENT_NUMBER, TITLE, PHASE, PARTICIPATION_TYPE, TREATMENT_FLAG, NIH_ADMIN_CODE, CURRENT_STATUS, CURRENT_STATUS_DATE, LEAD_organIZATION_CTEP_ID, LEAD_ORGANIZATION_NAME, PI_NAME, REVIEWER_NAME) SELECT ID, DOCUMENT_NUMBER, TITLE, PHASE, PARTICIPATION_TYPE, TREATMENT_FLAG, NIH_ADMIN_CODE, CURRENT_STATUS, CURRENT_STATUS_DATE, LEAD_ORGANIZATION_CTEP_ID, LEAD_ORGANIZATION_NAME, PI_NAME, REVIEWER_NAME FROM protocols@cmap;  
  
UPDATE protocols p1 SET pdq_protocol_code = (SELECT pdq_protocol_code FROM zstg_old_protocols p2 WHERE p1.document_number = p2.document_number);

INSERT INTO protocol_agents(PRO_ID, AGENT_ID) SELECT PRO_ID, (SELECT min(agent_id) FROM agent a2 WHERE a2.nsc_number = a1.nsc) FROM protocol_agents@cmap a1 WHERE (SELECT min(agent_id) FROM agent a2 WHERE a2.nsc_number = a1.nsc) IS NOT NULL;

INSERT INTO protocol_diseases(ID, PRO_ID, IMT_CODE, CTEP_NAME, DISEASE_SUB_CATEGORY, DISEASE_CATEGORY) SELECT ID, PRO_ID, IMT_CODE, CTEP_NAME, DISEASE_SUB_CATEGORY, DISEASE_CATEGORY FROM protocol_diseases@cmap;

UPDATE protocol_diseases p1 SET imt_code = ( SELECT MIN(imt_code) FROM zstg_old_protocol_diseases p2 WHERE p2.ctep_name = p1.ctep_name);

@$LOAD/indexes/protocols.cols.sql
@$LOAD/indexes/protocol_agents.cols.sql
@$LOAD/indexes/protocol_diseases.cols.sql

@$LOAD/indexes/protocols.lower.sql
@$LOAD/indexes/protocol_agents.lower.sql
@$LOAD/indexes/protocol_diseases.lower.sql

EXIT;
