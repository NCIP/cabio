
alter table GENE_EXPRESSED_IN enable constraint PK_GENE_EXPRESSED_IN;
alter table GENE_EXPRESSED_IN enable constraint PK_GENE_EXPRESSED_IN;

alter table GENE_EXPRESSED_IN enable primary key;

--EXIT;
create unique index PK_GENE_EXPRESSED_IN_idx on GENE_EXPRESSED_IN
(ORGAN_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_EXPRESSED_IN enable constraint PK_GENE_EXPRESSED_IN using index PK_GENE_EXPRESSED_IN_idx;
