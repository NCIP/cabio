/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index EXPREPPROTDOMPK_idx on EXPR_REPORTER_PROTEIN_DOMAIN
(PROTEIN_DOMAIN_ID,EXPR_REPORTER_ID) tablespace CABIO_FUT;
alter table EXPR_REPORTER_PROTEIN_DOMAIN enable constraint EXPREPPROTDOMPK using index EXPREPPROTDOMPK_idx;

alter table EXPR_REPORTER_PROTEIN_DOMAIN enable constraint SYS_C004439;
alter table EXPR_REPORTER_PROTEIN_DOMAIN enable constraint SYS_C004440;
alter table EXPR_REPORTER_PROTEIN_DOMAIN enable constraint EXPREPPROTDOMPK;
alter table EXPR_REPORTER_PROTEIN_DOMAIN enable constraint EXPREPPROTDOMPK;

alter table EXPR_REPORTER_PROTEIN_DOMAIN enable primary key;

--EXIT;
