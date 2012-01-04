create unique index NAS_PK_idx on NUCLEIC_ACID_SEQUENCE
(ID) tablespace CABIO_FUT;
alter table NUCLEIC_ACID_SEQUENCE enable constraint NAS_PK using index NAS_PK_idx;
create unique index NASNODUPS_idx on NUCLEIC_ACID_SEQUENCE
(ACCESSION_NUMBER) tablespace CABIO_FUT;
alter table NUCLEIC_ACID_SEQUENCE enable constraint NASNODUPS using index NASNODUPS_idx;

alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004613;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004614;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004615;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004616;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004617;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004618;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004619;
alter table NUCLEIC_ACID_SEQUENCE enable constraint SYS_C004620;
alter table NUCLEIC_ACID_SEQUENCE enable constraint NAS_PK;
alter table NUCLEIC_ACID_SEQUENCE enable constraint NASNODUPS;

alter table NUCLEIC_ACID_SEQUENCE enable primary key;

--EXIT;
