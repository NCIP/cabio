create unique index SYS_C0021054_idx on AR_GO_CELLULAR_COMPONENT_TMP
(GENECHIP_ARRAY,EVIDENCE,DESCRIPTION,ACCESSION_NUMBER,PROBE_SET_ID) tablespace CABIO_MAP_FUT;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C0021054 using index SYS_C0021054_idx;

alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C0021054;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C0021054;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C0021054;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C0021054;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C0021054;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C004243;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C004244;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C004245;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C004246;
alter table AR_GO_CELLULAR_COMPONENT_TMP enable constraint SYS_C004247;

alter table AR_GO_CELLULAR_COMPONENT_TMP enable primary key;

--EXIT;
