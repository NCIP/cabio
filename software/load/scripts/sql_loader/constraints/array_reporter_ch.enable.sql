/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021037_idx on ARRAY_REPORTER_CH
(DISCRIMINATOR,MICROARRAY_ID,NAME) tablespace CABIO;
alter table ARRAY_REPORTER_CH enable constraint SYS_C0021037 using index SYS_C0021037_idx;
create unique index ARCHPK_idx on ARRAY_REPORTER_CH
(ID) tablespace CABIO;
alter table ARRAY_REPORTER_CH enable constraint ARCHPK using index ARCHPK_idx;

alter table ARRAY_REPORTER_CH enable constraint SYS_C0021037;
alter table ARRAY_REPORTER_CH enable constraint SYS_C0021037;
alter table ARRAY_REPORTER_CH enable constraint SYS_C0021037;
alter table ARRAY_REPORTER_CH enable constraint SYS_C004162;
alter table ARRAY_REPORTER_CH enable constraint SYS_C004163;
alter table ARRAY_REPORTER_CH enable constraint SYS_C004164;
alter table ARRAY_REPORTER_CH enable constraint SYS_C004165;
alter table ARRAY_REPORTER_CH enable constraint ARCHPK;

alter table ARRAY_REPORTER_CH enable primary key;

--EXIT;
