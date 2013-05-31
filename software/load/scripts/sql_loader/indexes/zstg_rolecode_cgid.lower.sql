/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_ROLCGID_ROLECODE_lwr on ZSTG_ROLECODE_CGID(lower(ROLECODE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
