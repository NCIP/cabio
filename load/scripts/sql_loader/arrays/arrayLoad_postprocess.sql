/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

delete from zstg_rna_probesets_tmp where genechip_array like 'please see the bundled README%';
commit;
@$LOAD/arrays/array_createIndexes.sql;
@$LOAD/arrays/array_enableConstraints.sql;
EXIT;
