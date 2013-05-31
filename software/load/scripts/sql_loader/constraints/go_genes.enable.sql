/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index GOGPK_idx on GO_GENES
(GO_ID,TAXON_ID,GENE_ID) tablespace CABIO_FUT;
alter table GO_GENES enable constraint GOGPK using index GOGPK_idx;

alter table GO_GENES enable constraint SYS_C004510;
alter table GO_GENES enable constraint GOGPK;
alter table GO_GENES enable constraint GOGPK;
alter table GO_GENES enable constraint GOGPK;

alter table GO_GENES enable primary key;

--EXIT;
