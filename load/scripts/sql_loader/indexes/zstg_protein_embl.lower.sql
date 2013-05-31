/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PROEMBL_ACC_NUM_lwr on ZSTG_PROTEIN_EMBL(lower(ACC_NUM)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
