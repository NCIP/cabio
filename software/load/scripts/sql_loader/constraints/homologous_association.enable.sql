/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021113_idx on HOMOLOGOUS_ASSOCIATION
(HOMOLOGOUS_GENE_ID,HOMOLOGOUS_ID,SIMILARITY_PERCENTAGE) tablespace CABIO_FUT;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C0021113 using index SYS_C0021113_idx;
create unique index PK_HOMOLOGOUS_ASSOCIATION_idx on HOMOLOGOUS_ASSOCIATION
(ID) tablespace CABIO_FUT;
alter table HOMOLOGOUS_ASSOCIATION enable constraint PK_HOMOLOGOUS_ASSOCIATION using index PK_HOMOLOGOUS_ASSOCIATION_idx;

alter table HOMOLOGOUS_ASSOCIATION enable constraint HA_SP;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C0021113;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C0021113;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C0021113;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C004538;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C004539;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C004540;
alter table HOMOLOGOUS_ASSOCIATION enable constraint SYS_C004541;
alter table HOMOLOGOUS_ASSOCIATION enable constraint PK_HOMOLOGOUS_ASSOCIATION;

alter table HOMOLOGOUS_ASSOCIATION enable primary key;

--EXIT;
