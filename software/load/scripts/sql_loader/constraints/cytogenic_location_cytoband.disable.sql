/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint SYS_C0021080;
alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint SYS_C004375;
alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint SYS_C004376;
alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint SYS_C004377;
alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint SYS_C004378;
alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint CCCBIGID;

alter table CYTOGENIC_LOCATION_CYTOBAND disable primary key;

--EXIT;
