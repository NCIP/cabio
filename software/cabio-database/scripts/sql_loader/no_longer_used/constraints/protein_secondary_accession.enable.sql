/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021170_idx on PROTEIN_SECONDARY_ACCESSION
(SECONDARY_ACCESSION,PROTEIN_ID) tablespace CABIO_FUT;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint SYS_C0021170 using index SYS_C0021170_idx;
create unique index PSA_PK_idx on PROTEIN_SECONDARY_ACCESSION
(ID) tablespace CABIO_FUT;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint PSA_PK using index PSA_PK_idx;

alter table PROTEIN_SECONDARY_ACCESSION enable constraint SYS_C0021170;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint SYS_C0021170;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint SYS_C004666;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint SYS_C004667;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint SYS_C004668;
alter table PROTEIN_SECONDARY_ACCESSION enable constraint PSA_PK;

alter table PROTEIN_SECONDARY_ACCESSION enable primary key;

--EXIT;
