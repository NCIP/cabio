/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

TRUNCATE TABLE clone_relative_location reuse storage;
CREATE INDEX CLONE_IDX on zstg_clone(CLONE_ID, RELATIVE_TYPE);
CREATE INDEX CLONE_REL_TYPE_IDX on zstg_clone(RELATIVE_TYPE);
CREATE INDEX CLONE_ID_IDX on zstg_clone(CLONE_ID);
DELETE FROM zstg_clone where RELATIVE_TYPE IS NULL;
COMMIT;
@$LOAD/indexer_new.sql clone_relative_location;
@$LOAD/indexes/clone_relative_location.drop.sql;

CREATE SEQUENCE CLONE_REL_LOC_ID START WITH 1 INCREMENT BY 1;
ALTER TRIGGER SET_CLONERELLOC_ID ENABLE;

INSERT INTO clone_relative_location(clone_id,type,nucleic_acid_sequence_id) select distinct a.clone_id clone_id, a.relative_type type, b.id nucleic_acid_sequence_id from zstg_clone a, nucleic_acid_sequence b where a.clone_id = b.clone_id;

DROP INDEX CLONE_IDX;
DROP INDEX CLONE_ID_IDX;
DROP INDEX CLONE_REL_TYPE_IDX;


DROP SEQUENCE CLONE_REL_LOC_ID;

@$LOAD/indexes/clone_relative_location.cols.sql;
@$LOAD/indexes/clone_relative_location.lower.sql;
ALTER TRIGGER SET_CLONERELLOC_ID ENABLE;

--ANALYZE TABLE clone_relative_location COMPUTE STATISTICS;
COMMIT;
EXIT;
