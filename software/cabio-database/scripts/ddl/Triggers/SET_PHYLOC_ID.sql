/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_PHYLOC_ID  (Trigger) 
--
--  Dependencies: 
--   PHYSICAL_LOCATION (Table)
--
CREATE OR REPLACE TRIGGER SET_PHYLOC_ID
BEFORE INSERT
ON PHYSICAL_LOCATION
FOR EACH ROW
BEGIN
  SELECT PHYLOC_ID_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;

ALTER TRIGGER SET_PHYLOC_ID DISABLE
/



