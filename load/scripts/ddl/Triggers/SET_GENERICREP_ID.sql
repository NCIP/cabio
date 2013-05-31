/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_GENERICREP_ID  (Trigger) 
--
--  Dependencies: 
--   GENERIC_REPORTER (Table)
--
CREATE OR REPLACE TRIGGER SET_GENERICREP_ID
BEFORE INSERT
ON GENERIC_REPORTER
FOR EACH ROW
BEGIN
  SELECT GENERICREP_ID.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



