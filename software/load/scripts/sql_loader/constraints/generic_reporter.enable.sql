/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021099_idx on GENERIC_REPORTER
(CLUSTER_ID,GENE_ID,TYPE,NAME) tablespace CABIO_FUT;
alter table GENERIC_REPORTER enable constraint SYS_C0021099 using index SYS_C0021099_idx;
create unique index GENERIC_REPORTER_PK_idx on GENERIC_REPORTER
(ID) tablespace CABIO_FUT;
alter table GENERIC_REPORTER enable constraint GENERIC_REPORTER_PK using index GENERIC_REPORTER_PK_idx;

alter table GENERIC_REPORTER enable constraint SYS_C0021099;
alter table GENERIC_REPORTER enable constraint SYS_C0021099;
alter table GENERIC_REPORTER enable constraint SYS_C0021099;
alter table GENERIC_REPORTER enable constraint SYS_C0021099;
alter table GENERIC_REPORTER enable constraint SYS_C004452;
alter table GENERIC_REPORTER enable constraint SYS_C004453;
alter table GENERIC_REPORTER enable constraint GENERIC_REPORTER_PK;

alter table GENERIC_REPORTER enable primary key;

--EXIT;
