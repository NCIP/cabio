/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004972;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004973;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004974;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004975;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004976;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004977;
alter table ZSTG_HUMAN_CYTOBAND disable constraint CYTOBAND_UNIQ;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004969;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004970;
alter table ZSTG_HUMAN_CYTOBAND disable constraint SYS_C004971;

alter table ZSTG_HUMAN_CYTOBAND disable primary key;

--EXIT;
