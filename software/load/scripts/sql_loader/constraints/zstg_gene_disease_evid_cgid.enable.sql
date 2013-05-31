/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index GDER_idx on ZSTG_GENE_DISEASE_EVID_CGID
(ROLE_ID,EVIDENCE_ID,DISEASE_ID,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_DISEASE_EVID_CGID enable constraint GDER using index GDER_idx;

alter table ZSTG_GENE_DISEASE_EVID_CGID enable constraint GDER;
alter table ZSTG_GENE_DISEASE_EVID_CGID enable constraint GDER;
alter table ZSTG_GENE_DISEASE_EVID_CGID enable constraint GDER;
alter table ZSTG_GENE_DISEASE_EVID_CGID enable constraint GDER;

alter table ZSTG_GENE_DISEASE_EVID_CGID enable primary key;

--EXIT;
