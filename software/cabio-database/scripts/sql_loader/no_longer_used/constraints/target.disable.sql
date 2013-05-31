/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table TARGET disable constraint SYS_C0021189;
alter table TARGET disable constraint SYS_C004764;
alter table TARGET disable constraint SYS_C004765;
alter table TARGET disable constraint SYS_C004766;
alter table TARGET disable constraint SYS_C004767;
alter table TARGET disable constraint SYS_C004768;
alter table TARGET disable constraint TARGETBIGID;

alter table TARGET disable primary key;

--EXIT;
