/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLACE procedure Generic_32_LD as

BEGIN

   	EXECUTE IMMEDIATE('TRUNCATE TABLE GENERIC_REPORTER REUSE STORAGE');
	EXECUTE IMMEDIATE('TRUNCATE TABLE Generic_array REUSE STORAGE');
	EXECUTE IMMEDIATE('TRUNCATE TABLE GENERIC_ARRAY_GENERIC_REPORTER REUSE STORAGE');

Insert into GENERIC_REPORTER(ID, NAME, TYPE, GENE_ID, cluster_ID)
select rownum, a.PROBE_SET_ID, 'AFFYMETRIX', c.GENE_ID, b.UNIGENE_ID
from AR_RNA_PROBESETS_AFFY a,
     AR_UNIGENE_ID b,
     GENE_TV c
where a.PROBE_SET_ID = b.PROBE_SET_ID(+)
and b.UNIGENE_ID = 'Hs.'||c.CLUSTER_ID(+) and c.taxon_ID = 5;

Commit;

Insert into Generic_array
	(ID,
  ARRAY_NAME,
  PLATFORM,
  TYPE) values (1, 'Human Genome U133 Plus 2.0 Array', 'Affy', 'olig');

commit;

Insert into GENERIC_ARRAY_GENERIC_REPORTER
(
  GENERIC_ARRAY_ID,
  GENERIC_REPORTER_ID) select a.ID, b.ID
  from Generic_array a, GENERIC_REPORTER b;

COMMIT;

END; 
/

