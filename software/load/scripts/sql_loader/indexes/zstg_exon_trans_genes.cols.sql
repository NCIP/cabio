/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_EXOENES_UNIGENE_ID on ZSTG_EXON_TRANS_GENES(UNIGENE_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_EXOENES_TRANSCRIPT on ZSTG_EXON_TRANS_GENES(TRANSCRIPT_CLUSTER_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
