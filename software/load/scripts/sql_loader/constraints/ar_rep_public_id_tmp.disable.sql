/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table AR_REP_PUBLIC_ID_TMP disable constraint SYS_C004285;
alter table AR_REP_PUBLIC_ID_TMP disable constraint SYS_C004286;
alter table AR_REP_PUBLIC_ID_TMP disable constraint SYS_C004287;

alter table AR_REP_PUBLIC_ID_TMP disable primary key;

--EXIT;
