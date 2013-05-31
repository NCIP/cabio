/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table NEW_PROTEIN disable constraint SYS_C0021126;
alter table NEW_PROTEIN disable constraint SYS_C004603;
alter table NEW_PROTEIN disable constraint SYS_C004604;
alter table NEW_PROTEIN disable constraint SYS_C004605;
alter table NEW_PROTEIN disable constraint SYS_C004606;
alter table NEW_PROTEIN disable constraint SYS_C004607;
alter table NEW_PROTEIN disable constraint NPBIGIDUNIQ;
alter table NEW_PROTEIN disable constraint PROTUNIQ;

alter table NEW_PROTEIN disable primary key;

--EXIT;
