/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PK_ZSTG_EXON_REPORTER_idx on ZSTG_EXON_REPORTER
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_EXON_REPORTER enable constraint PK_ZSTG_EXON_REPORTER using index PK_ZSTG_EXON_REPORTER_idx;

alter table ZSTG_EXON_REPORTER enable constraint SYS_C004883;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004884;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004885;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004886;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004887;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004888;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004889;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004890;
alter table ZSTG_EXON_REPORTER enable constraint PK_ZSTG_EXON_REPORTER;

alter table ZSTG_EXON_REPORTER enable primary key;

--EXIT;
