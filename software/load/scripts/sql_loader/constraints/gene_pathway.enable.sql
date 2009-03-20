create unique index GENE_PATHWAY_PK_idx on GENE_PATHWAY
(PATHWAY_ID,BC_ID) tablespace CABIO_FUT;
alter table GENE_PATHWAY enable constraint GENE_PATHWAY_PK using index GENE_PATHWAY_PK_idx;

alter table GENE_PATHWAY enable constraint SYS_C004483;
alter table GENE_PATHWAY enable constraint SYS_C004484;
alter table GENE_PATHWAY enable constraint GENE_PATHWAY_PK;
alter table GENE_PATHWAY enable constraint GENE_PATHWAY_PK;

alter table GENE_PATHWAY enable primary key;

--EXIT;
