/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_DISCGID_EVS_ID_lwr on ZSTG_DISEASEONTOLOGY_CGID(lower(EVS_ID)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_DISCGID_DISEASEONT_lwr on ZSTG_DISEASEONTOLOGY_CGID(lower(DISEASEONTOLOGY)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
