/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0016535_idx on DATABASE_CROSS_REFERENCE
(ID) tablespace CABIO_FUT;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0016535 using index SYS_C0016535_idx;
create unique index SYS_C0021081_idx on DATABASE_CROSS_REFERENCE
(ENGINEEREDGENE_ID,PROTEIN_ID,NUCLEIC_ACID_SEQ_ID,SNP_ID,GENE_ID,SUMMARY,SOURCE_TYPE,CROSS_REFERENCE_ID,SOURCE_NAME,TYPE) tablespace CABIO_FUT;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081 using index SYS_C0021081_idx;

alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0016535;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C004388;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C004389;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C004390;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C004391;
alter table DATABASE_CROSS_REFERENCE enable constraint SYS_C004392;

alter table DATABASE_CROSS_REFERENCE enable primary key;

--EXIT;
