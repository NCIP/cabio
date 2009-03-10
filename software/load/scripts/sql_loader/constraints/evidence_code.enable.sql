
alter table EVIDENCE_CODE enable constraint SYS_C0016520;
alter table EVIDENCE_CODE enable constraint SYS_C0021090;
alter table EVIDENCE_CODE enable constraint SYS_C004413;
alter table EVIDENCE_CODE enable constraint SYS_C004414;

alter table EVIDENCE_CODE enable primary key;

--EXIT;
create unique index SYS_C0016520_idx on EVIDENCE_CODE
(ID) tablespace CABIO_FUT;
alter table EVIDENCE_CODE enable constraint SYS_C0016520 using index SYS_C0016520_idx;
create unique index SYS_C0021090_idx on EVIDENCE_CODE
(EVIDENCE_CODE) tablespace CABIO_FUT;
alter table EVIDENCE_CODE enable constraint SYS_C0021090 using index SYS_C0021090_idx;