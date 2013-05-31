/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- CGDC_ID_INSERT  (Trigger) 
--
--  Dependencies: 
--   GENE_FUNCTION_ASSOCIATION (Table)
--
CREATE OR REPLACE TRIGGER CGDC_ID_INSERT
BEFORE INSERT
ON GENE_FUNCTION_ASSOCIATION
FOR EACH ROW
BEGIN
  SELECT CGDC_ID.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;

ALTER TRIGGER CGDC_ID_INSERT DISABLE
/



