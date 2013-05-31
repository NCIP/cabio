/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_CYTO_PHYLOC_ID  (Trigger) 
--
--  Dependencies: 
--   CYTOBAND (Table)
--
CREATE OR REPLACE TRIGGER SET_CYTO_PHYLOC_ID
BEFORE INSERT
ON CYTOBAND
FOR EACH ROW
BEGIN
  SELECT CYTOBAND_PHYLOC_ID.NEXTVAL
  INTO :NEW.PHYSICAL_LOCATION_ID
  FROM DUAL;
END;
/
SHOW ERRORS;

ALTER TRIGGER SET_CYTO_PHYLOC_ID DISABLE
/



