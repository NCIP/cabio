/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- INTERACTION_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   PID_INTERACTION (Table)
--
CREATE OR REPLACE TRIGGER interaction_id_trigger
BEFORE INSERT
ON pid_interaction
FOR EACH ROW
BEGIN
  SELECT interaction_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/
SHOW ERRORS;



