/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create index ZSTG_PIDENCE_PUBMED_ID on ZSTG_PID_PATHWAYREFERENCE(PUBMED_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;
create index ZSTG_PIDENCE_PATHWAY_ID on ZSTG_PID_PATHWAYREFERENCE(PATHWAY_ID) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
