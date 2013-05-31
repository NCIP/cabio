/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index GPTV_PK_idx on GENE_PROTEIN_TV
(PROTEIN_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_PROTEIN_TV enable constraint GPTV_PK using index GPTV_PK_idx;

alter table GENE_PROTEIN_TV enable constraint SYS_C004486;
alter table GENE_PROTEIN_TV enable constraint SYS_C004487;
alter table GENE_PROTEIN_TV enable constraint GPTV_PK;
alter table GENE_PROTEIN_TV enable constraint GPTV_PK;

alter table GENE_PROTEIN_TV enable primary key;

--EXIT;
