/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_XSCRIPT_ID  (Trigger) 
--
--  Dependencies: 
--   TRANSCRIPT (Table)
--
CREATE OR REPLACE TRIGGER SET_xscript_ID
BEFORE INSERT
ON TRANSCRIPT
FOR EACH ROW
BEGIN
  SELECT xscript_id_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



