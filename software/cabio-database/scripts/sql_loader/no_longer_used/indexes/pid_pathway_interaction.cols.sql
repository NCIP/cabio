
create index PID_PATHTION_INTERACTIO on PID_PATHWAY_INTERACTION(INTERACTION_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;
create index PID_PATHTION_PATHWAY_ID on PID_PATHWAY_INTERACTION(PATHWAY_ID) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
