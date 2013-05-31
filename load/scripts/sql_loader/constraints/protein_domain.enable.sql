/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index PROTEIN_DOMAIN_PK_idx on PROTEIN_DOMAIN
(ID) tablespace CABIO_FUT;
alter table PROTEIN_DOMAIN enable constraint PROTEIN_DOMAIN_PK using index PROTEIN_DOMAIN_PK_idx;
create unique index SYS_C0021167_idx on PROTEIN_DOMAIN
(TYPE,DESCRIPTION,ACCESSION_NUMBER) tablespace CABIO_FUT;
alter table PROTEIN_DOMAIN enable constraint SYS_C0021167 using index SYS_C0021167_idx;

alter table PROTEIN_DOMAIN enable constraint SYS_C004653;
alter table PROTEIN_DOMAIN enable constraint SYS_C004654;
alter table PROTEIN_DOMAIN enable constraint SYS_C004655;
alter table PROTEIN_DOMAIN enable constraint SYS_C004656;
alter table PROTEIN_DOMAIN enable constraint PROTEIN_DOMAIN_PK;
alter table PROTEIN_DOMAIN enable constraint SYS_C0021167;
alter table PROTEIN_DOMAIN enable constraint SYS_C0021167;
alter table PROTEIN_DOMAIN enable constraint SYS_C0021167;

alter table PROTEIN_DOMAIN enable primary key;

--EXIT;
