create unique index SYS_C0016508_idx on PID_PARTICIPANT
(ID) tablespace CABIO_FUT;
alter table PID_PARTICIPANT enable constraint SYS_C0016508 using index SYS_C0016508_idx;

alter table PID_PARTICIPANT enable constraint SYS_C0016488;
alter table PID_PARTICIPANT enable constraint SYS_C0016489;
alter table PID_PARTICIPANT enable constraint SYS_C0016508;

alter table PID_PARTICIPANT enable primary key;

--EXIT;
