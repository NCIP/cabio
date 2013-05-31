/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table CLONE_TV disable constraint SYS_C0021076;
alter table CLONE_TV disable constraint SYS_C004349;
alter table CLONE_TV disable constraint SYS_C004350;
alter table CLONE_TV disable constraint SYS_C004351;
alter table CLONE_TV disable constraint CTVBIGID;
alter table CLONE_TV disable constraint CLONENODUPS;

alter table CLONE_TV disable primary key;

--EXIT;
