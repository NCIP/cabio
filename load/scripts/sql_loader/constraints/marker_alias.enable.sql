/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021120_idx on MARKER_ALIAS
(NAME) tablespace CABIO_FUT;
alter table MARKER_ALIAS enable constraint SYS_C0021120 using index SYS_C0021120_idx;
create unique index PK_MARKER_ALIAS_idx on MARKER_ALIAS
(ID) tablespace CABIO_FUT;
alter table MARKER_ALIAS enable constraint PK_MARKER_ALIAS using index PK_MARKER_ALIAS_idx;

alter table MARKER_ALIAS enable constraint SYS_C0021120;
alter table MARKER_ALIAS enable constraint SYS_C004583;
alter table MARKER_ALIAS enable constraint PK_MARKER_ALIAS;

alter table MARKER_ALIAS enable primary key;

--EXIT;
