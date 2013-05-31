/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PROTEIN_ALIAS disable constraint SYS_C0021164;
alter table PROTEIN_ALIAS disable constraint SYS_C004648;
alter table PROTEIN_ALIAS disable constraint SYS_C004649;
alter table PROTEIN_ALIAS disable constraint SYS_C004650;
alter table PROTEIN_ALIAS disable constraint PABIGID;

alter table PROTEIN_ALIAS disable primary key;

--EXIT;
