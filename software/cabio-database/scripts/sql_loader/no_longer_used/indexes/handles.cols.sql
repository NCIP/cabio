
create index HANDLES_PREFIX on HANDLES(PREFIX) tablespace CABIO_FUT;
create index HANDLES_HANDLE on HANDLES(HANDLE) tablespace CABIO_FUT;
create index HANDLES_IDX on HANDLES(IDX) tablespace CABIO_FUT;
create index HANDLES_TYPE on HANDLES(TYPE) tablespace CABIO_FUT;
create index HANDLES_DATA on HANDLES(DATA) tablespace CABIO_FUT;
create index HANDLES_TTL_TYPE on HANDLES(TTL_TYPE) tablespace CABIO_FUT;
create index HANDLES_TTL on HANDLES(TTL) tablespace CABIO_FUT;
create index HANDLES_TIMESTAMP on HANDLES(TIMESTAMP) tablespace CABIO_FUT;
create index HANDLES_REFS on HANDLES(REFS) tablespace CABIO_FUT;
create index HANDLES_ADMIN_READ on HANDLES(ADMIN_READ) tablespace CABIO_FUT;
create index HANDLES_ADMIN_WRITE on HANDLES(ADMIN_WRITE) tablespace CABIO_FUT;
create index HANDLES_PUB_READ on HANDLES(PUB_READ) tablespace CABIO_FUT;
create index HANDLES_PUB_WRITE on HANDLES(PUB_WRITE) tablespace CABIO_FUT;

--EXIT;
