create unique index SYS_C0021052_idx on AR_GO_BIOLOGICAL_PROCESS_TMP
(GENECHIP_ARRAY,EVIDENCE,DESCRIPTION,ACCESSION_NUMBER,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C0021052 using index SYS_C0021052_idx;

alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C0021052;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C0021052;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C0021052;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C0021052;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C0021052;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C004233;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C004234;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C004235;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C004236;
alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable constraint SYS_C004237;

alter table AR_GO_BIOLOGICAL_PROCESS_TMP enable primary key;

--EXIT;
