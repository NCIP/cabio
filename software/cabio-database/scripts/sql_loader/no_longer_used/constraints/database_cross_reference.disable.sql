/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table DATABASE_CROSS_REFERENCE disable constraint SYS_C0021081;
alter table DATABASE_CROSS_REFERENCE disable constraint SYS_C004388;
alter table DATABASE_CROSS_REFERENCE disable constraint SYS_C004389;
alter table DATABASE_CROSS_REFERENCE disable constraint SYS_C004390;
alter table DATABASE_CROSS_REFERENCE disable constraint SYS_C004391;
alter table DATABASE_CROSS_REFERENCE disable constraint SYS_C004392;

alter table DATABASE_CROSS_REFERENCE disable primary key;

--EXIT;
