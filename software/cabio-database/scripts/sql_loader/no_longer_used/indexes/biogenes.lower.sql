
create index BIOGENESENES_BC_ID_lwr on BIOGENES(lower(BC_ID)) PARALLEL NOLOGGING tablespace CABIO_FUT;

--EXIT;
