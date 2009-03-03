
alter table SNP_TV enable constraint SNPTVPK;
alter table SNP_TV enable constraint SNPTVUNIQ;
alter table SNP_TV enable constraint SYS_C004745;
alter table SNP_TV enable constraint SYS_C004746;
alter table SNP_TV enable constraint SYS_C004747;
alter table SNP_TV enable constraint SYS_C004748;

alter table SNP_TV enable primary key;

--EXIT;
create unique index SNPTVPK_idx on SNP_TV
(ID) tablespace CABIO_FUT;
alter table SNP_TV enable constraint SNPTVPK using index SNPTVPK_idx;
create unique index SNPTVUNIQ_idx on SNP_TV
(DB_SNP_ID) tablespace CABIO_FUT;
alter table SNP_TV enable constraint SNPTVUNIQ using index SNPTVUNIQ_idx;
