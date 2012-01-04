--
-- PROTEIN_COMPLEX_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   PROTEIN_COMPLEX (Table)
--
CREATE OR REPLACE TRIGGER protein_complex_id_trigger
BEFORE INSERT
ON protein_complex
FOR EACH ROW
BEGIN
  SELECT complex_id_seq.NEXTVAL
  INTO :NEW.complex_id
  FROM DUAL;
END;
/
SHOW ERRORS;



