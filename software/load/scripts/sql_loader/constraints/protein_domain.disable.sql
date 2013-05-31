/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PROTEIN_DOMAIN disable constraint SYS_C004653;
alter table PROTEIN_DOMAIN disable constraint SYS_C004654;
alter table PROTEIN_DOMAIN disable constraint SYS_C004655;
alter table PROTEIN_DOMAIN disable constraint SYS_C004656;
alter table PROTEIN_DOMAIN disable constraint PDBIGID;
alter table PROTEIN_DOMAIN disable constraint SYS_C0021167;

alter table PROTEIN_DOMAIN disable primary key;

--EXIT;
