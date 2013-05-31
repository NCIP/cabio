/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table PROTEIN_TAXON disable constraint SYS_C004677;
alter table PROTEIN_TAXON disable constraint SYS_C004678;

alter table PROTEIN_TAXON disable primary key;

--EXIT;
