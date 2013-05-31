/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index MOUSE_CYT_ID_idx on ZSTG_MOUSE_CYTOBAND
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_MOUSE_CYTOBAND enable constraint MOUSE_CYT_ID using index MOUSE_CYT_ID_idx;
create unique index CYTOBAND_M_UNIQ_idx on ZSTG_MOUSE_CYTOBAND
(CYTOBAND) tablespace CABIO_MAP_FUT;
alter table ZSTG_MOUSE_CYTOBAND enable constraint CYTOBAND_M_UNIQ using index CYTOBAND_M_UNIQ_idx;

alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005028;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005029;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005030;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005031;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005032;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005033;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005034;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005035;
alter table ZSTG_MOUSE_CYTOBAND enable constraint SYS_C005036;
alter table ZSTG_MOUSE_CYTOBAND enable constraint MOUSE_CYT_ID;
alter table ZSTG_MOUSE_CYTOBAND enable constraint CYTOBAND_M_UNIQ;

--EXIT;
