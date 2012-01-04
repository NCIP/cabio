--
-- EVIDENCE_CODE_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   EVIDENCE_CODE (Table)
--
CREATE OR REPLACE TRIGGER evidence_code_id_trigger
BEFORE INSERT
ON evidence_code
FOR EACH ROW
BEGIN
  SELECT evidencecode_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/
SHOW ERRORS;



