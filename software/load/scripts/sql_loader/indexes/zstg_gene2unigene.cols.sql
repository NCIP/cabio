/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_GENGENE_UNIGENE_CL on ZSTG_GENE2UNIGENE(UNIGENE_CLUSTER) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_GENGENE_GENEID on ZSTG_GENE2UNIGENE(GENEID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
