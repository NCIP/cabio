/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021108_idx on GO_ONTOLOGY
(MM_GENES,HS_GENES,GO_NAME) tablespace CABIO_FUT;
alter table GO_ONTOLOGY enable constraint SYS_C0021108 using index SYS_C0021108_idx;
create unique index GOOPK_idx on GO_ONTOLOGY
(GO_ID) tablespace CABIO_FUT;
alter table GO_ONTOLOGY enable constraint GOOPK using index GOOPK_idx;
create unique index GONODUPS_idx on GO_ONTOLOGY
(GO_NAME) tablespace CABIO_FUT;
alter table GO_ONTOLOGY enable constraint GONODUPS using index GONODUPS_idx;

alter table GO_ONTOLOGY enable constraint SYS_C0021108;
alter table GO_ONTOLOGY enable constraint SYS_C0021108;
alter table GO_ONTOLOGY enable constraint SYS_C0021108;
alter table GO_ONTOLOGY enable constraint SYS_C004512;
alter table GO_ONTOLOGY enable constraint SYS_C004513;
alter table GO_ONTOLOGY enable constraint SYS_C004514;
alter table GO_ONTOLOGY enable constraint GOOPK;
alter table GO_ONTOLOGY enable constraint GONODUPS;

alter table GO_ONTOLOGY enable primary key;

--EXIT;
