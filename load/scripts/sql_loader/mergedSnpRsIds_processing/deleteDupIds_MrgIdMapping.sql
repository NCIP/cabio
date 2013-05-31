/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

CREATE OR REPLace PROCEDURE DELETEDUPIDS_MRGIDMAPPING AS
CURSOR DUPLICIDS IS
  (SELECT DISTINCT SNPREPID, COUNT(*)
     FROM zstg_snprep_sntv_ids_mpng
    GROUP BY SNPREPID
   HAVING COUNT(*) > 1);

BEGIN
  
  FOR AREC IN DUPLICIDS LOOP
    DELETE FROM zstg_snprep_sntv_ids_mpng
     WHERE SNPREPID = AREC.SNPREPID;
  END LOOP;
  
  COMMIT;
  
END;
/
