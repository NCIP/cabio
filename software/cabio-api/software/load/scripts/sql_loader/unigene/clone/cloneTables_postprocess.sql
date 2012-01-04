VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM clone_relative_location;

DROP SEQUENCE crl_seq;
CREATE SEQUENCE crl_seq START WITH &V_MAXROW INCREMENT BY 1;

insert into clone_relative_location(id, nucleic_acid_sequence_id, clone_id, type)
select crl_seq.nextval, id, clone_id, 'unknown' from
(select id, clone_id  from nucleic_acid_sequence where clone_id is not null and discriminator = 'ExpressedSequenceTag'
minus
select nucleic_acid_sequence_id, clone_id from clone_relative_location);



@$LOAD/indexes/clone_tv.lower.sql;
@$LOAD/indexes/clone_taxon.lower.sql;
@$LOAD/indexes/clone_relative_location.lower.sql;

@$LOAD/indexes/clone_tv.cols.sql;
@$LOAD/indexes/zstg_clone.cols.sql;
@$LOAD/indexes/clone_taxon.cols.sql;
@$LOAD/indexes/clone_relative_location.cols.sql;

@$LOAD/constraints/clone_tv.enable.sql;
@$LOAD/constraints/zstg_clone.enable.sql;
@$LOAD/constraints/clone_taxon.enable.sql;
@$LOAD/constraints/clone_relative_location.enable.sql;

@$LOAD/triggers/clone_tv.enable.sql;
@$LOAD/triggers/zstg_clone.enable.sql;
@$LOAD/triggers/clone_taxon.enable.sql;
@$LOAD/triggers/clone_relative_location.enable.sql;


--ANALYZE TABLE clone_tv COMPUTE STATISTICS;
--ANALYZE TABLE clone_taxon COMPUTE STATISTICS;
--ANALYZE TABLE zstg_clone COMPUTE STATISTICS;

EXIT;
