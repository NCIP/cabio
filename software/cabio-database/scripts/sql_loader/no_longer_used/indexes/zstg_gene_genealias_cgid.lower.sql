/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENCGID_ALIAS_lwr on ZSTG_GENE_GENEALIAS_CGID(lower(ALIAS)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
