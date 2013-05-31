/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table CYTOBAND disable constraint CYTOBIGID;
alter table CYTOBAND disable constraint SYS_C0021079;
alter table CYTOBAND disable constraint SYS_C004368;
alter table CYTOBAND disable constraint SYS_C004369;
alter table CYTOBAND disable constraint SYS_C004370;
alter table CYTOBAND disable constraint CYTOPL;
alter table CYTOBAND disable constraint CYTOUNIQ;

alter table CYTOBAND disable primary key;

--EXIT;
