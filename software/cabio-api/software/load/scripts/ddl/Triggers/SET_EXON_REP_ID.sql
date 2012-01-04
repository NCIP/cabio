--
-- SET_EXON_REP_ID  (Trigger) 
--
--  Dependencies: 
--   EXON_REPORTER (Table)
--
CREATE OR REPLACE TRIGGER SET_exon_rep_ID
BEFORE INSERT
ON EXON_REPORTER
FOR EACH ROW
BEGIN
  SELECT FINAL_REP_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;


