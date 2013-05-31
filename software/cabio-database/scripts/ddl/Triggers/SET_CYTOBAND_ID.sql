/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_CYTOBAND_ID  (Trigger) 
--
--  Dependencies: 
--   CYTOBAND (Table)
--
CREATE OR REPLACE TRIGGER SET_CYTOBAND_ID
BEFORE INSERT
ON CYTOBAND
FOR EACH ROW
BEGIN
  SELECT CYTOBAND_ID_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;

ALTER TRIGGER SET_CYTOBAND_ID DISABLE
/



