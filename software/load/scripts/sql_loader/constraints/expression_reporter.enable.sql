/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index SYS_C0021093_idx on EXPRESSION_REPORTER
(NAS_ID,GENE_ID,TARGET_DESCRIPTION,TRANSCRIPT_ID,SEQUENCE_SOURCE,SEQUENCE_TYPE,MICROARRAY_ID,NAME) tablespace CABIO_FUT;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093 using index SYS_C0021093_idx;
create unique index EXPR_REPORTER_PK_idx on EXPRESSION_REPORTER
(ID) tablespace CABIO_FUT;
alter table EXPRESSION_REPORTER enable constraint EXPR_REPORTER_PK using index EXPR_REPORTER_PK_idx;

alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C0021093;
alter table EXPRESSION_REPORTER enable constraint SYS_C004434;
alter table EXPRESSION_REPORTER enable constraint SYS_C004435;
alter table EXPRESSION_REPORTER enable constraint SYS_C004436;
alter table EXPRESSION_REPORTER enable constraint EXPR_REPORTER_PK;

alter table EXPRESSION_REPORTER enable primary key;

--EXIT;
