--
-- EVIDENCE_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   EVIDENCE (Table)
--
CREATE OR REPLACE TRIGGER evidence_id_trigger
BEFORE INSERT
ON evidence
FOR EACH ROW
BEGIN
  SELECT evidence_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/
SHOW ERRORS;



