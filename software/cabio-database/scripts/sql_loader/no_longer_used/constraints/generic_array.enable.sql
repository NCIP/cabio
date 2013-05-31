/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021098_idx on GENERIC_ARRAY
(TYPE,PLATFORM,ARRAY_NAME) tablespace CABIO_FUT;
alter table GENERIC_ARRAY enable constraint SYS_C0021098 using index SYS_C0021098_idx;
create unique index PK_GENERIC_ARRAY_idx on GENERIC_ARRAY
(ID) tablespace CABIO_FUT;
alter table GENERIC_ARRAY enable constraint PK_GENERIC_ARRAY using index PK_GENERIC_ARRAY_idx;
create unique index GENERICARRNODUPS_idx on GENERIC_ARRAY
(TYPE,PLATFORM,ARRAY_NAME) tablespace CABIO_FUT;
alter table GENERIC_ARRAY enable constraint GENERICARRNODUPS using index GENERICARRNODUPS_idx;

alter table GENERIC_ARRAY enable constraint SYS_C0021098;
alter table GENERIC_ARRAY enable constraint SYS_C0021098;
alter table GENERIC_ARRAY enable constraint SYS_C0021098;
alter table GENERIC_ARRAY enable constraint SYS_C004443;
alter table GENERIC_ARRAY enable constraint SYS_C004444;
alter table GENERIC_ARRAY enable constraint SYS_C004445;
alter table GENERIC_ARRAY enable constraint SYS_C004446;
alter table GENERIC_ARRAY enable constraint PK_GENERIC_ARRAY;
alter table GENERIC_ARRAY enable constraint GENERICARRNODUPS;
alter table GENERIC_ARRAY enable constraint GENERICARRNODUPS;
alter table GENERIC_ARRAY enable constraint GENERICARRNODUPS;

alter table GENERIC_ARRAY enable primary key;

--EXIT;
