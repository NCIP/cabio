/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- SET_GENE_REL_LOC_ID  (Trigger) 
--
--  Dependencies: 
--   GENE_RELATIVE_LOCATION (Table)
--
CREATE OR REPLACE TRIGGER SET_GENE_rel_loc_ID
BEFORE INSERT
ON GENE_RELATIVE_LOCATION
FOR EACH ROW
BEGIN
  SELECT REL_LOCATION_SEQ.NEXTVAL
  INTO :NEW.ID
  FROM DUAL;
END;
/
SHOW ERRORS;



