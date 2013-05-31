/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table MICROARRAY disable constraint SYS_C0021124;
alter table MICROARRAY disable constraint SYS_C0016542;
alter table MICROARRAY disable constraint SYS_C0016543;
alter table MICROARRAY disable constraint SYS_C0016544;
alter table MICROARRAY disable constraint SYS_C004599;
alter table MICROARRAY disable constraint SYS_C004600;
alter table MICROARRAY disable constraint MABIGIDUNIQ;

alter table MICROARRAY disable primary key;

--EXIT;
