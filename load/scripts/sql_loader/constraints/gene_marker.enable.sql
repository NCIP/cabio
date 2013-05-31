/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index GENE_MARKER_PK_idx on GENE_MARKER
(MARKER_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_MARKER enable constraint GENE_MARKER_PK using index GENE_MARKER_PK_idx;

alter table GENE_MARKER enable constraint GENE_MARKER_PK;
alter table GENE_MARKER enable constraint GENE_MARKER_PK;

alter table GENE_MARKER enable primary key;

--EXIT;
