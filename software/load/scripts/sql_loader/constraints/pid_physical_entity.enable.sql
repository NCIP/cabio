
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0021157;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0021157;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0016492;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0016493;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0016494;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0016510;

alter table PID_PHYSICAL_ENTITY enable primary key;

--EXIT;
create unique index SYS_C0021157_idx on PID_PHYSICAL_ENTITY
(PID_PHYSICALENTITY_ID,PROTEIN_ENTITY_ID) tablespace CABIO_FUT;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0021157 using index SYS_C0021157_idx;
create unique index SYS_C0016510_idx on PID_PHYSICAL_ENTITY
(ID) tablespace CABIO_FUT;
alter table PID_PHYSICAL_ENTITY enable constraint SYS_C0016510 using index SYS_C0016510_idx;
