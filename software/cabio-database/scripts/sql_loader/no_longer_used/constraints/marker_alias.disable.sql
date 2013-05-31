/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table MARKER_ALIAS disable constraint MABIGID;
alter table MARKER_ALIAS disable constraint SYS_C0021120;
alter table MARKER_ALIAS disable constraint SYS_C004583;

alter table MARKER_ALIAS disable primary key;

--EXIT;
