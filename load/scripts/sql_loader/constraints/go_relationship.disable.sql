/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table GO_RELATIONSHIP disable constraint SYS_C0021109;
alter table GO_RELATIONSHIP disable constraint SYS_C004518;
alter table GO_RELATIONSHIP disable constraint SYS_C004519;
alter table GO_RELATIONSHIP disable constraint SYS_C004520;
alter table GO_RELATIONSHIP disable constraint GORBIGID;

alter table GO_RELATIONSHIP disable primary key;

--EXIT;
