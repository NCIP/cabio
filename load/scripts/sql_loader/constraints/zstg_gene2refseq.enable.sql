
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004915;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004916;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004917;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004918;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004919;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004920;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004921;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004922;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004923;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004924;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004925;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004926;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004927;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C004928;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836;

alter table ZSTG_GENE2REFSEQ enable primary key;

--EXIT;
create unique index SYS_C0020836_idx on ZSTG_GENE2REFSEQ
(ASSEMBLY,PROTEIN_ID,ORIENTATION,END_POSITON,START_POSITION,GENOMIC_NUCLEOTIDE_GI,GENOMIC_NUCLEOTIDE_ACC,PROTEIN_GI,PROTEIN_ACCESSION,RNA_NUCLEOTIDE_GI,RNA_NUCLEOTIDE_ACC,STATUS,GENEID,TAX_ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_GENE2REFSEQ enable constraint SYS_C0020836 using index SYS_C0020836_idx;
