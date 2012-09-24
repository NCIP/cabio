create unique index PK_GENE_SEQUENCE_idx on GENE_NUCLEIC_ACID_SEQUENCE
(GENE_SEQUENCE_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_NUCLEIC_ACID_SEQUENCE enable constraint PK_GENE_SEQUENCE using index PK_GENE_SEQUENCE_idx;

alter table GENE_NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004480;
alter table GENE_NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004481;
alter table GENE_NUCLEIC_ACID_SEQUENCE enable constraint PK_GENE_SEQUENCE;
alter table GENE_NUCLEIC_ACID_SEQUENCE enable constraint PK_GENE_SEQUENCE;

alter table GENE_NUCLEIC_ACID_SEQUENCE enable primary key;

--EXIT;
