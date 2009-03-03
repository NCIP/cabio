
alter table GENE_MARKER enable constraint GENE_MARKER_PK;
alter table GENE_MARKER enable constraint GENE_MARKER_PK;

alter table GENE_MARKER enable primary key;

--EXIT;
create unique index GENE_MARKER_PK_idx on GENE_MARKER
(MARKER_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_MARKER enable constraint GENE_MARKER_PK using index GENE_MARKER_PK_idx;
