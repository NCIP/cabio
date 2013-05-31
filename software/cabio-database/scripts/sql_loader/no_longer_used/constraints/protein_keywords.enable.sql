/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021168_idx on PROTEIN_KEYWORDS
(PROTEIN_ID,KEYWORD) tablespace CABIO_FUT;
alter table PROTEIN_KEYWORDS enable constraint SYS_C0021168 using index SYS_C0021168_idx;
create unique index PKW_PK_idx on PROTEIN_KEYWORDS
(ID) tablespace CABIO_FUT;
alter table PROTEIN_KEYWORDS enable constraint PKW_PK using index PKW_PK_idx;

alter table PROTEIN_KEYWORDS enable constraint SYS_C0021168;
alter table PROTEIN_KEYWORDS enable constraint SYS_C0021168;
alter table PROTEIN_KEYWORDS enable constraint SYS_C004659;
alter table PROTEIN_KEYWORDS enable constraint SYS_C004660;
alter table PROTEIN_KEYWORDS enable constraint SYS_C004661;
alter table PROTEIN_KEYWORDS enable constraint PKW_PK;

alter table PROTEIN_KEYWORDS enable primary key;

--EXIT;
