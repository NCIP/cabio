/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021119_idx on MARKER
(ACCNO,TAXON_ID,TYPE,MARKER_ID,NAME) tablespace CABIO_FUT;
alter table MARKER enable constraint SYS_C0021119 using index SYS_C0021119_idx;
create unique index MARKER_PK_idx on MARKER
(ID) tablespace CABIO_FUT;
alter table MARKER enable constraint MARKER_PK using index MARKER_PK_idx;

alter table MARKER enable constraint SYS_C0021119;
alter table MARKER enable constraint SYS_C0021119;
alter table MARKER enable constraint SYS_C0021119;
alter table MARKER enable constraint SYS_C0021119;
alter table MARKER enable constraint SYS_C0021119;
alter table MARKER enable constraint SYS_C004577;
alter table MARKER enable constraint SYS_C004578;
alter table MARKER enable constraint SYS_C004579;
alter table MARKER enable constraint SYS_C004580;
alter table MARKER enable constraint MARKER_PK;

alter table MARKER enable primary key;

--EXIT;
