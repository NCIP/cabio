/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021041_idx on AR_CHROMOSOMAL_LOCATION_TMP
(GENECHIP_ARRAY,ASSEMBLY,CYTO_STOP,CYTO_START,CHROMOSOMAL_LOCATION,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041 using index SYS_C0021041_idx;

alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C0021041;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C004192;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C004193;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C004194;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C004195;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C004196;
alter table AR_CHROMOSOMAL_LOCATION_TMP enable constraint SYS_C004197;

alter table AR_CHROMOSOMAL_LOCATION_TMP enable primary key;

--EXIT;
