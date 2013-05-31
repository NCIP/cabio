/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021100_idx on GENE_ALIAS_OBJECT_TV
(GENE_ID,NAME,ALIAS_TYPE,GENE_ALIAS_ID) tablespace CABIO_FUT;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C0021100 using index SYS_C0021100_idx;
create unique index GAOPK_idx on GENE_ALIAS_OBJECT_TV
(GENE_ALIAS_ID) tablespace CABIO_FUT;
alter table GENE_ALIAS_OBJECT_TV enable constraint GAOPK using index GAOPK_idx;

alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C0021100;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C0021100;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C0021100;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C0021100;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C004456;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C004457;
alter table GENE_ALIAS_OBJECT_TV enable constraint SYS_C004458;
alter table GENE_ALIAS_OBJECT_TV enable constraint GAOPK;

alter table GENE_ALIAS_OBJECT_TV enable primary key;

--EXIT;
