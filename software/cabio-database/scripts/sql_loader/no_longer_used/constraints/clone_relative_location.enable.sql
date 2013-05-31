/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021074_idx on CLONE_RELATIVE_LOCATION
(NUCLEIC_ACID_SEQUENCE_ID,CLONE_ID,TYPE) tablespace CABIO_FUT;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C0021074 using index SYS_C0021074_idx;
create unique index PK_CLONE_RELATIVE_LOCATION_idx on CLONE_RELATIVE_LOCATION
(ID) tablespace CABIO_FUT;
alter table CLONE_RELATIVE_LOCATION enable constraint PK_CLONE_RELATIVE_LOCATION using index PK_CLONE_RELATIVE_LOCATION_idx;

alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C0021074;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C0021074;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C0021074;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C004336;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C004337;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C004338;
alter table CLONE_RELATIVE_LOCATION enable constraint SYS_C004339;
alter table CLONE_RELATIVE_LOCATION enable constraint PK_CLONE_RELATIVE_LOCATION;

alter table CLONE_RELATIVE_LOCATION enable primary key;

--EXIT;
