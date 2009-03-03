
alter table MARKER_LOOKUP enable constraint SYS_C004586;
alter table MARKER_LOOKUP enable constraint SYS_C004587;
alter table MARKER_LOOKUP enable constraint SYS_C004588;
alter table MARKER_LOOKUP enable constraint MR_LK;
alter table MARKER_LOOKUP enable constraint MR_LK;

--EXIT;
create unique index MR_LK_idx on MARKER_LOOKUP
(ID,NAME) tablespace CABIO_FUT;
alter table MARKER_LOOKUP enable constraint MR_LK using index MR_LK_idx;
