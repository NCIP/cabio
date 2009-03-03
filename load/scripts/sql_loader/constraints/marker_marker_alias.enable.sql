
alter table MARKER_MARKER_ALIAS enable constraint SYS_C004590;
alter table MARKER_MARKER_ALIAS enable constraint SYS_C004591;
alter table MARKER_MARKER_ALIAS enable constraint PK_MARKER_MARKER_ALIAS;
alter table MARKER_MARKER_ALIAS enable constraint PK_MARKER_MARKER_ALIAS;

alter table MARKER_MARKER_ALIAS enable primary key;

--EXIT;
create unique index PK_MARKER_MARKER_ALIAS_idx on MARKER_MARKER_ALIAS
(MARKER_ALIAS_ID,MARKER_ID) tablespace CABIO_FUT;
alter table MARKER_MARKER_ALIAS enable constraint PK_MARKER_MARKER_ALIAS using index PK_MARKER_MARKER_ALIAS_idx;
