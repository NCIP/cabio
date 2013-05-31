/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- PATHWAY_ID  (Trigger) 
--
--  Dependencies: 
--   BIO_PATHWAYS_TV (Table)
--
CREATE OR REPLACE TRIGGER pathway_ID
BEFORE INSERT
ON BIO_PATHWAYS_TV
FOR EACH ROW
BEGIN
  SELECT pathway_id_seq.NEXTVAL
  INTO :NEW.pathway_ID
  FROM DUAL;
END;
/
SHOW ERRORS;

ALTER TRIGGER PATHWAY_ID DISABLE
/



