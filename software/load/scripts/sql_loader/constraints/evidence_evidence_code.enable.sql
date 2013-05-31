/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index EV_EVCODE_PK_idx on EVIDENCE_EVIDENCE_CODE
(EVIDENCE_CODE_ID,EVIDENCE_ID) tablespace CABIO_FUT;
alter table EVIDENCE_EVIDENCE_CODE enable constraint EV_EVCODE_PK using index EV_EVCODE_PK_idx;

alter table EVIDENCE_EVIDENCE_CODE enable constraint EV_EVCODE_PK;
alter table EVIDENCE_EVIDENCE_CODE enable constraint EV_EVCODE_PK;

alter table EVIDENCE_EVIDENCE_CODE enable primary key;

--EXIT;
