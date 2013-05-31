/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_CLOLONE_RELATIVE_T_lwr on ZSTG_CLONE(lower(RELATIVE_TYPE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_CLOLONE_CLONE_NAME_lwr on ZSTG_CLONE(lower(CLONE_NAME)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
