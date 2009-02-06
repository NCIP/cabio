CREATE OR REPLACE FORCE VIEW CABIODEV.PARTY_PERSON_VIEW
(PARTY_ID, FIRSTNAME, LASTNAME, PERSON_ID)
AS 
SELECT party.party_id, person.firstname, person.lastname, person.person_id 
     FROM party, person 
    WHERE party.party_id = person.party_id;


