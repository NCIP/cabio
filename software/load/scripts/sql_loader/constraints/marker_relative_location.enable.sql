/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021123_idx on MARKER_RELATIVE_LOCATION
(PROBE_SET_ID,SNP_ID,DISTANCE,ORIENTATION,TYPE) tablespace CABIO_FUT;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0021123 using index SYS_C0021123_idx;
create unique index MARKER_RL_PK_idx on MARKER_RELATIVE_LOCATION
(ID) tablespace CABIO_FUT;
alter table MARKER_RELATIVE_LOCATION enable constraint MARKER_RL_PK using index MARKER_RL_PK_idx;

alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0021123;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0021123;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0021123;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0021123;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0021123;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0016540;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0016541;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C004595;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C004596;
alter table MARKER_RELATIVE_LOCATION enable constraint MARKER_RL_PK;
alter table MARKER_RELATIVE_LOCATION enable constraint SYS_C0016539;

alter table MARKER_RELATIVE_LOCATION enable primary key;

--EXIT;
