create unique index SYS_C0020841_idx on ZSTG_GENE_EVIDENCE_CGID
(EVIDENCECODE_ID,EVIDENCE_ID,GENE_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE_EVIDENCE_CGID enable constraint SYS_C0020841 using index SYS_C0020841_idx;

alter table ZSTG_GENE_EVIDENCE_CGID enable constraint SYS_C0020841;
alter table ZSTG_GENE_EVIDENCE_CGID enable constraint SYS_C0020841;
alter table ZSTG_GENE_EVIDENCE_CGID enable constraint SYS_C0020841;

alter table ZSTG_GENE_EVIDENCE_CGID enable primary key;

--EXIT;
