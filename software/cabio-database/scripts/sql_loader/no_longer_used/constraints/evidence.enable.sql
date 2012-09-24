create unique index EVIDENCE_PK_1_idx on EVIDENCE
(ID) tablespace CABIO_FUT;
alter table EVIDENCE enable constraint EVIDENCE_PK_1 using index EVIDENCE_PK_1_idx;

alter table EVIDENCE enable constraint SYS_C004408;
alter table EVIDENCE enable constraint SYS_C004409;
alter table EVIDENCE enable constraint SYS_C004410;
alter table EVIDENCE enable constraint EVIDENCE_PK_1;

alter table EVIDENCE enable primary key;

--EXIT;
