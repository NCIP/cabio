/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_GO_BIOLOGICAL_PROCESS_TMP disable constraint SYS_C004233;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP disable constraint SYS_C004234;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP disable constraint SYS_C004235;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP disable constraint SYS_C004236;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP disable constraint SYS_C004237;

alter table AR_GO_BIOLOGICAL_PROCESS_TMP disable primary key;

--EXIT;
