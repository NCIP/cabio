--
-- PROTEIN_COMPOUND_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   PROTEIN_COMPOUND (Table)
--
CREATE OR REPLACE TRIGGER protein_compound_id_trigger
BEFORE INSERT
ON protein_compound
FOR EACH ROW
BEGIN
  SELECT compound_id_seq.NEXTVAL
  INTO :NEW.compound_id
  FROM DUAL;
END;
/
SHOW ERRORS;



