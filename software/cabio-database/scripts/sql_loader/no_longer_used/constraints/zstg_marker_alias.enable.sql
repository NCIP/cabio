/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PK_ZSTG_MARKER_ALIAS_idx on ZSTG_MARKER_ALIAS
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_MARKER_ALIAS enable constraint PK_ZSTG_MARKER_ALIAS using index PK_ZSTG_MARKER_ALIAS_idx;

alter table ZSTG_MARKER_ALIAS enable constraint SYS_C005012;
alter table ZSTG_MARKER_ALIAS enable constraint SYS_C005013;
alter table ZSTG_MARKER_ALIAS enable constraint SYS_C005014;
alter table ZSTG_MARKER_ALIAS enable constraint PK_ZSTG_MARKER_ALIAS;

alter table ZSTG_MARKER_ALIAS enable primary key;

--EXIT;
