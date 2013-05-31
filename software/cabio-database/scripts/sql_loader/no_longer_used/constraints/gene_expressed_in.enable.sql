/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PK_GENE_EXPRESSED_IN_idx on GENE_EXPRESSED_IN
(ORGAN_ID,GENE_ID) tablespace CABIO_FUT;
alter table GENE_EXPRESSED_IN enable constraint PK_GENE_EXPRESSED_IN using index PK_GENE_EXPRESSED_IN_idx;

alter table GENE_EXPRESSED_IN enable constraint PK_GENE_EXPRESSED_IN;
alter table GENE_EXPRESSED_IN enable constraint PK_GENE_EXPRESSED_IN;

alter table GENE_EXPRESSED_IN enable primary key;

--EXIT;
