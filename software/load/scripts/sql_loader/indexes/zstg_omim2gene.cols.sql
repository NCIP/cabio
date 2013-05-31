/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_OMIGENE_TYPE on ZSTG_OMIM2GENE(TYPE) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_OMIGENE_GENEID on ZSTG_OMIM2GENE(GENEID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_OMIGENE_OMIM_NUMBE on ZSTG_OMIM2GENE(OMIM_NUMBER) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
