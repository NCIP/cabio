/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PROTEIN_SEQUENCE disable constraint PROTSEQ;
alter table PROTEIN_SEQUENCE disable constraint SYS_C0021171;
alter table PROTEIN_SEQUENCE disable constraint SYS_C004670;
alter table PROTEIN_SEQUENCE disable constraint SYS_C004671;
alter table PROTEIN_SEQUENCE disable constraint SYS_C004672;
alter table PROTEIN_SEQUENCE disable constraint SYS_C004673;
alter table PROTEIN_SEQUENCE disable constraint SYS_C004674;

alter table PROTEIN_SEQUENCE disable primary key;

--EXIT;
