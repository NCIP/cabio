/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021192_idx on TRANSCRIPT
(PROBE_COUNT,STRAND,SOURCE,MANUFACTURER_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT enable constraint SYS_C0021192 using index SYS_C0021192_idx;
create unique index TRANSCRIPT_PK_idx on TRANSCRIPT
(ID) tablespace CABIO_FUT;
alter table TRANSCRIPT enable constraint TRANSCRIPT_PK using index TRANSCRIPT_PK_idx;

alter table TRANSCRIPT enable constraint SYS_C0021192;
alter table TRANSCRIPT enable constraint SYS_C0021192;
alter table TRANSCRIPT enable constraint SYS_C0021192;
alter table TRANSCRIPT enable constraint SYS_C0021192;
alter table TRANSCRIPT enable constraint SYS_C004798;
alter table TRANSCRIPT enable constraint SYS_C004799;
alter table TRANSCRIPT enable constraint SYS_C004800;
alter table TRANSCRIPT enable constraint SYS_C004801;
alter table TRANSCRIPT enable constraint TRANSCRIPT_PK;

alter table TRANSCRIPT enable primary key;

--EXIT;
