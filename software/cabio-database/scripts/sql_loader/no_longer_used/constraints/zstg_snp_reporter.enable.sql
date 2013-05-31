/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PK_ZSTG_SNP_REPORTER_idx on ZSTG_SNP_REPORTER
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_SNP_REPORTER enable constraint PK_ZSTG_SNP_REPORTER using index PK_ZSTG_SNP_REPORTER_idx;

alter table ZSTG_SNP_REPORTER enable constraint SYS_C005239;
alter table ZSTG_SNP_REPORTER enable constraint SYS_C005240;
alter table ZSTG_SNP_REPORTER enable constraint SYS_C005241;
alter table ZSTG_SNP_REPORTER enable constraint PK_ZSTG_SNP_REPORTER;

alter table ZSTG_SNP_REPORTER enable primary key;

--EXIT;
