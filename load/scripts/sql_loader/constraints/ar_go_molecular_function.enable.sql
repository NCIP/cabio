create unique index SYS_C0021055_idx on AR_GO_MOLECULAR_FUNCTION
(GENECHIP_ARRAY,EVIDENCE,DESCRIPTION,ACCESSION_NUMBER,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C0021055 using index SYS_C0021055_idx;

alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C0021055;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C0021055;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C0021055;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C0021055;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C0021055;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C004248;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C004249;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C004250;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C004251;
alter table AR_GO_MOLECULAR_FUNCTION enable constraint SYS_C004252;

alter table AR_GO_MOLECULAR_FUNCTION enable primary key;

--EXIT;
