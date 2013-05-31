/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PROTEIN_KEYWORDS disable constraint SYS_C0021168;
alter table PROTEIN_KEYWORDS disable constraint SYS_C004659;
alter table PROTEIN_KEYWORDS disable constraint SYS_C004660;
alter table PROTEIN_KEYWORDS disable constraint SYS_C004661;

alter table PROTEIN_KEYWORDS disable primary key;

--EXIT;
