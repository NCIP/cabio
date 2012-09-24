create unique index PK_ZSTG_EXPRESSION_REPORTER_idx on ZSTG_EXPRESSION_REPORTER
(ID) tablespace CABIO_MAP_FUT;
alter table ZSTG_EXPRESSION_REPORTER enable constraint PK_ZSTG_EXPRESSION_REPORTER using index PK_ZSTG_EXPRESSION_REPORTER_idx;

alter table ZSTG_EXPRESSION_REPORTER enable constraint SYS_C004897;
alter table ZSTG_EXPRESSION_REPORTER enable constraint SYS_C004898;
alter table ZSTG_EXPRESSION_REPORTER enable constraint SYS_C004899;
alter table ZSTG_EXPRESSION_REPORTER enable constraint PK_ZSTG_EXPRESSION_REPORTER;

alter table ZSTG_EXPRESSION_REPORTER enable primary key;

--EXIT;
