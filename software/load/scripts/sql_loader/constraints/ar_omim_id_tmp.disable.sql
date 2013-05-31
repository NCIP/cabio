/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_OMIM_ID_TMP disable constraint SYS_C004261;
alter table AR_OMIM_ID_TMP disable constraint SYS_C004262;
alter table AR_OMIM_ID_TMP disable constraint SYS_C004263;

alter table AR_OMIM_ID_TMP disable primary key;

--EXIT;
