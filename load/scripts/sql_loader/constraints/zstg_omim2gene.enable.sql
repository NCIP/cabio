
alter table ZSTG_OMIM2GENE enable constraint SYS_C005057;
alter table ZSTG_OMIM2GENE enable constraint SYS_C0020929;
alter table ZSTG_OMIM2GENE enable constraint SYS_C0020929;
alter table ZSTG_OMIM2GENE enable constraint SYS_C0020929;
alter table ZSTG_OMIM2GENE enable constraint SYS_C005055;
alter table ZSTG_OMIM2GENE enable constraint SYS_C005056;

alter table ZSTG_OMIM2GENE enable primary key;

--EXIT;
create unique index SYS_C0020929_idx on ZSTG_OMIM2GENE
(TYPE,GENEID,OMIM_NUMBER) tablespace CABIO_MAP_FUT;
alter table ZSTG_OMIM2GENE enable constraint SYS_C0020929 using index SYS_C0020929_idx;
