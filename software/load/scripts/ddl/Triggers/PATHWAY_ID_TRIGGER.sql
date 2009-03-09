--
-- PATHWAY_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   BIO_PATHWAYS_TV (Table)
--
CREATE OR REPLACE TRIGGER pathway_id_trigger
BEFORE INSERT
ON bio_pathways_tv
FOR EACH ROW
BEGIN
  SELECT pathway_id_seq.NEXTVAL
  INTO :NEW.pathway_id
  FROM DUAL;
END;
/
SHOW ERRORS;



