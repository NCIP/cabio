
create index NEW_LOCATION_DISCRIMINATO_lwr on NEW_LOCATION_TV_BK(lower(DISCRIMINATOR)) PARALLEL NOLOGGING tablespace CABIO_MAP_FUT;

--EXIT;
