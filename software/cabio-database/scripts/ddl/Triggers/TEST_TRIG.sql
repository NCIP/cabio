/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- TEST_TRIG  (Trigger) 
--
--  Dependencies: 
--   GENE_FUNCTION_ASSOCIATION (Table)
--
CREATE OR REPLACE TRIGGER test_trig
BEFORE INSERT
ON GENE_FUNCTION_ASSOCIATION
FOR EACH ROW
BEGIN
  SELECT test_seq.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



