create unique index SYS_C0021056_idx on AR_GO_MOLECULAR_FUNCTION_TMP
(GENECHIP_ARRAY,EVIDENCE,DESCRIPTION,ACCESSION_NUMBER,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C0021056 using index SYS_C0021056_idx;

alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C0021056;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C0021056;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C0021056;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C0021056;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C0021056;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C004253;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C004254;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C004255;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C004256;
alter table AR_GO_MOLECULAR_FUNCTION_TMP enable constraint SYS_C004257;

alter table AR_GO_MOLECULAR_FUNCTION_TMP enable primary key;

--EXIT;
