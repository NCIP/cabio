/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_DBCROSSREF_ID  (Trigger) 
--
--  Dependencies: 
--   DATABASE_CROSS_REFERENCE (Table)
--
CREATE OR REPLACE TRIGGER SET_DBCROSSREF_ID
BEFORE INSERT
ON DATABASE_CROSS_REFERENCE
FOR EACH ROW
BEGIN
  SELECT DBCROSSREF_ID.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



