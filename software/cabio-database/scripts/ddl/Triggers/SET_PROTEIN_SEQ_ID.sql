/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_PROTEIN_SEQ_ID  (Trigger) 
--
--  Dependencies: 
--   PROTEIN_DOMAIN (Table)
--
CREATE OR REPLACE TRIGGER SET_protein_seq_ID
BEFORE INSERT
ON PROTEIN_DOMAIN
FOR EACH ROW
BEGIN
  SELECT PROTEIN_DOMAIN_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



