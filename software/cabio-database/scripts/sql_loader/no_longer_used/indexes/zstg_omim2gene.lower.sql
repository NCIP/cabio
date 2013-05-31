/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_OMIGENE_TYPE_lwr on ZSTG_OMIM2GENE(lower(TYPE)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
