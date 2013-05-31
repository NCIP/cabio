/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table TRANSCRIPT disable constraint XSCRIPTBIGID;
alter table TRANSCRIPT disable constraint SYS_C0021192;
alter table TRANSCRIPT disable constraint SYS_C004798;
alter table TRANSCRIPT disable constraint SYS_C004799;
alter table TRANSCRIPT disable constraint SYS_C004800;
alter table TRANSCRIPT disable constraint SYS_C004801;
alter table TRANSCRIPT disable constraint SYS_C004802;

alter table TRANSCRIPT disable primary key;

--EXIT;
