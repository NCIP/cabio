/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PROTEIN_SECONDARY_ACCESSION disable constraint SYS_C0021170;
alter table PROTEIN_SECONDARY_ACCESSION disable constraint SYS_C004666;
alter table PROTEIN_SECONDARY_ACCESSION disable constraint SYS_C004667;
alter table PROTEIN_SECONDARY_ACCESSION disable constraint SYS_C004668;

alter table PROTEIN_SECONDARY_ACCESSION disable primary key;

--EXIT;
