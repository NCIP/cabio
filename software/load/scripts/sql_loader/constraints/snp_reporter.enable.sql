/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021185_idx on SNP_REPORTER
(PHAST_CONSERVATION,SNP_ID,MICROARRAY_ID,NAME) tablespace CABIO_FUT;
alter table SNP_REPORTER enable constraint SYS_C0021185 using index SYS_C0021185_idx;
create unique index SNP_REPORTER_PK_idx on SNP_REPORTER
(ID) tablespace CABIO_FUT;
alter table SNP_REPORTER enable constraint SNP_REPORTER_PK using index SNP_REPORTER_PK_idx;

alter table SNP_REPORTER enable constraint SYS_C0021185;
alter table SNP_REPORTER enable constraint SYS_C0021185;
alter table SNP_REPORTER enable constraint SYS_C0021185;
alter table SNP_REPORTER enable constraint SYS_C0021185;
alter table SNP_REPORTER enable constraint SYS_C004740;
alter table SNP_REPORTER enable constraint SYS_C004741;
alter table SNP_REPORTER enable constraint SYS_C004742;
alter table SNP_REPORTER enable constraint SNP_REPORTER_PK;

alter table SNP_REPORTER enable primary key;

--EXIT;
