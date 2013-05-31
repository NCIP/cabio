/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_TARGET_ID  (Trigger) 
--
--  Dependencies: 
--   TARGET (Table)
--
CREATE OR REPLACE TRIGGER SET_target_ID
BEFORE INSERT
ON TARGET
FOR EACH ROW
BEGIN
  SELECT target_id.NEXTVAL
  INTO :NEW.TARGET_ID
  FROM DUAL;
END;
/
SHOW ERRORS;



