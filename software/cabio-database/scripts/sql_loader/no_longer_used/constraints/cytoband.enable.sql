/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021079_idx on CYTOBAND
(CHROMOSOME_ID,PHYSICAL_LOCATION_ID,NAME) tablespace CABIO_FUT;
alter table CYTOBAND enable constraint SYS_C0021079 using index SYS_C0021079_idx;
create unique index CYTOPK_idx on CYTOBAND
(ID) tablespace CABIO_FUT;
alter table CYTOBAND enable constraint CYTOPK using index CYTOPK_idx;
create unique index CYTOPL_idx on CYTOBAND
(PHYSICAL_LOCATION_ID) tablespace CABIO_FUT;
alter table CYTOBAND enable constraint CYTOPL using index CYTOPL_idx;
create unique index CYTOUNIQ_idx on CYTOBAND
(CHROMOSOME_ID,NAME) tablespace CABIO_FUT;
alter table CYTOBAND enable constraint CYTOUNIQ using index CYTOUNIQ_idx;

alter table CYTOBAND enable constraint SYS_C0021079;
alter table CYTOBAND enable constraint SYS_C0021079;
alter table CYTOBAND enable constraint SYS_C0021079;
alter table CYTOBAND enable constraint SYS_C004368;
alter table CYTOBAND enable constraint SYS_C004369;
alter table CYTOBAND enable constraint SYS_C004370;
alter table CYTOBAND enable constraint CYTOPK;
alter table CYTOBAND enable constraint CYTOPL;
alter table CYTOBAND enable constraint CYTOUNIQ;
alter table CYTOBAND enable constraint CYTOUNIQ;

alter table CYTOBAND enable primary key;

--EXIT;
