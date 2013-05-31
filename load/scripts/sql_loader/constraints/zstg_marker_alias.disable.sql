/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ZSTG_MARKER_ALIAS disable constraint SYS_C005012;
alter table ZSTG_MARKER_ALIAS disable constraint SYS_C005013;
alter table ZSTG_MARKER_ALIAS disable constraint SYS_C005014;

alter table ZSTG_MARKER_ALIAS disable primary key;

--EXIT;
