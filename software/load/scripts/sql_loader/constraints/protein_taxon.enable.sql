/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PT_PK_idx on PROTEIN_TAXON
(TAXON_ID,PROTEIN_ID) tablespace CABIO_FUT;
alter table PROTEIN_TAXON enable constraint PT_PK using index PT_PK_idx;

alter table PROTEIN_TAXON enable constraint SYS_C004677;
alter table PROTEIN_TAXON enable constraint SYS_C004678;
alter table PROTEIN_TAXON enable constraint PT_PK;
alter table PROTEIN_TAXON enable constraint PT_PK;

alter table PROTEIN_TAXON enable primary key;

--EXIT;
