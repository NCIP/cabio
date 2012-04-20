
create index RESEARCH_INS_NAME_lwr on RESEARCH_INSTITUTION_SOURCE(lower(NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RESEARCH_INS_INSTITUTION__lwr on RESEARCH_INSTITUTION_SOURCE(lower(INSTITUTION_NAME)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RESEARCH_INS_INSTITUTION__lwr on RESEARCH_INSTITUTION_SOURCE(lower(INSTITUTION_DEPT)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RESEARCH_INS_INSTITUTION__lwr on RESEARCH_INSTITUTION_SOURCE(lower(INSTITUTION_PERSONS)) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index RESEARCH_INS_INSTITUTION__lwr on RESEARCH_INSTITUTION_SOURCE(lower(INSTITUTION_ADDRESS)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;