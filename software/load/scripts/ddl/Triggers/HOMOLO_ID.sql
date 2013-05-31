/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- HOMOLO_ID  (Trigger) 
--
--  Dependencies: 
--   HOMOLOGOUS_ASSOCIATION (Table)
--
CREATE OR REPLACE TRIGGER HOMOLO_ID
BEFORE INSERT
ON HOMOLOGOUS_ASSOCIATION
FOR EACH ROW
BEGIN
  SELECT HOMOLOGENE_ID.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



