CREATE OR REPLACE FORCE VIEW CABIODEV.PUBLICATION_LIMIT
(IDX, ID)
AS 
select rownum, PUBLICATION_ID from PUBLICATION;


