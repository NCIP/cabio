/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_EXON_ID  (Trigger) 
--
--  Dependencies: 
--   EXON (Table)
--
CREATE OR REPLACE TRIGGER SET_exon_ID
BEFORE INSERT
ON EXON
FOR EACH ROW
BEGIN
  SELECT exon_id_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



