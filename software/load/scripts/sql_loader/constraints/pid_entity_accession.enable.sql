
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0016465;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0016466;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0016467;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0016468;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0017725;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0017725;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0021149;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0021149;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0021149;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0016499;

alter table PID_ENTITY_ACCESSION enable primary key;

--EXIT;
create unique index SYS_C0017725_idx on PID_ENTITY_ACCESSION
(DATABASE,ACCESSION) tablespace CABIO_FUT;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0017725 using index SYS_C0017725_idx;
create unique index SYS_C0021149_idx on PID_ENTITY_ACCESSION
(PID_PHYSICALENTITY_ID,DATABASE,ACCESSION) tablespace CABIO_FUT;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0021149 using index SYS_C0021149_idx;
create unique index SYS_C0016499_idx on PID_ENTITY_ACCESSION
(ID) tablespace CABIO_FUT;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0016499 using index SYS_C0016499_idx;
