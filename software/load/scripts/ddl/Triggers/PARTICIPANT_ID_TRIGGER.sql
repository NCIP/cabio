/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

--
-- PARTICIPANT_ID_TRIGGER  (Trigger) 
--
--  Dependencies: 
--   PID_PARTICIPANT (Table)
--
CREATE OR REPLACE TRIGGER participant_id_trigger
BEFORE INSERT
ON pid_participant
FOR EACH ROW
BEGIN
  SELECT participant_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/
SHOW ERRORS;



