create unique index SYS_C0021109_idx on GO_RELATIONSHIP
(RELATIONSHIP,PARENT_ID,CHILD_ID) tablespace CABIO_FUT;
alter table GO_RELATIONSHIP enable constraint SYS_C0021109 using index SYS_C0021109_idx;
create unique index PK_GO_RELATIONSHIP_idx on GO_RELATIONSHIP
(ID) tablespace CABIO_FUT;
alter table GO_RELATIONSHIP enable constraint PK_GO_RELATIONSHIP using index PK_GO_RELATIONSHIP_idx;

alter table GO_RELATIONSHIP enable constraint SYS_C0021109;
alter table GO_RELATIONSHIP enable constraint SYS_C0021109;
alter table GO_RELATIONSHIP enable constraint SYS_C0021109;
alter table GO_RELATIONSHIP enable constraint SYS_C004518;
alter table GO_RELATIONSHIP enable constraint SYS_C004519;
alter table GO_RELATIONSHIP enable constraint SYS_C004520;
alter table GO_RELATIONSHIP enable constraint PK_GO_RELATIONSHIP;

alter table GO_RELATIONSHIP enable primary key;

--EXIT;
