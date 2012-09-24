
alter table BIO_PATHWAYS_TV disable constraint SYS_C0016533;
alter table BIO_PATHWAYS_TV disable constraint PATHWAYS_UNIQ;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004318;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004319;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004320;
alter table BIO_PATHWAYS_TV disable constraint SYS_C004321;
alter table BIO_PATHWAYS_TV disable constraint BPTBIGID;

alter table BIO_PATHWAYS_TV disable primary key;

--EXIT;
