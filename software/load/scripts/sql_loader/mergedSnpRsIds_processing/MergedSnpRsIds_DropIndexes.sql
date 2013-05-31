/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- Drop indexes with merged SnpIds Table;
TRUNCATE TABLE zstg_merged_snp_rsids_mapping;
DROP INDEX ZSTGMRGDSNPRSIDSMAPCURRENTRSID;
DROP INDEX ZSTGMRGDSNPRSIDSMAPNEWRSID;
EXIT;
