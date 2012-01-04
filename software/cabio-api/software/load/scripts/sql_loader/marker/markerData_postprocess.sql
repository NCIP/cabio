DELETE FROM marker
 WHERE taxon_ID IS NULL;
COMMIT;
DROP SEQUENCE marker_SEQ;
DROP SEQUENCE marker_alias_SEQ;
VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;
SELECT MAX(ID) + 1 AS V_MAXROW
  FROM marker; 
CREATE SEQUENCE marker_SEQ START WITH &V_MAXROW;
CREATE SEQUENCE marker_alias_SEQ START WITH &V_MAXROW;

@$LOAD/indexes/zstg_marker_alias.cols.sql;
@$LOAD/indexes/zstg_marker_alias.lower.sql;
INSERT
  INTO marker (ID, MARKER_ID, NAME, TYPE, taxon_ID) SELECT MARKER_SEQ.NEXTVAL, 
                                            marker_ID, NAME, TYPE, 5 AS taxon_ID
                                     FROM (SELECT DISTINCT marker_ID, NAME, TYPE
           FROM (SELECT DISTINCT FIRST_SNP_TSC_ID marker_ID, '' NAME, 'TSC' TYPE
                                                           FROM zstg_geneTIC_MAP
      WHERE FIRST_SNP_TSC_ID IS NOT NULL UNION SELECT DISTINCT SECOND_SNP_TSC_ID 
                                                  marker_ID, '' NAME, 'TSC' TYPE
                                                           FROM zstg_geneTIC_MAP
                                          WHERE SECOND_SNP_TSC_ID IS NOT NULL));
COMMIT;
INSERT
  INTO marker_alias (ID, NAME) SELECT marker_ALIAS_SEQ.NEXTVAL, NAME
                                 FROM (SELECT DISTINCT Z.NAME
                                         FROM zstg_marker_alias Z, marker M
                       WHERE Z.marker_ID = M.MARKER_ID AND M.TYPE = 'UNISTS');
COMMIT;

INSERT INTO gene_marker(GENE_ID, MARKER_ID) SELECT DISTINCT A.GENE_ID, B.ID FROM zstg_gene_markers A, MARKER B, gene_tv C WHERE A.marker_ID = B.MARKER_ID AND B.TYPE = 'UNISTS' AND A.gene_ID = C.gene_ID AND C.taxon_ID = B.TAXON_ID;

-- insert into gene_marker(gene_id, marker_id) select distinct g.gene_id, m.id from gene_tv g, marker m, gene_nucleic_acid_sequence gn, nucleic_acid_sequence n where m.ACCNO = n.ACCESSION_NUMBER and n.ID = gn.GENE_SEQUENCE_ID and gn.GENE_ID = g.GENE_ID and g.TAXON_ID = m.TAXON_ID  and m.type = 'UNISTS';

COMMIT;
@$LOAD/indexes/marker.cols.sql;
@$LOAD/indexes/marker_alias.cols.sql;
COMMIT;

INSERT
INTO marker_marker_alias (MARKER_ID, MARKER_ALIAS_ID) SELECT DISTINCT A.ID, B.ID
                              FROM marker A, marker_alias B, zstg_marker_alias C
                          WHERE A.marker_ID = C.MARKER_ID AND C.NAME = B.NAME;

COMMIT;
INSERT
  INTO marker_lookup SELECT DISTINCT M.NAME NAME, M.ID MARKER_ID, M.taxon_ID
                       FROM marker M
    WHERE NAME IS NOT NULL AND (M.NAME NOT LIKE '-' OR M.NAME NOT LIKE '') UNION 
SELECT MA.NAME NAME, M.ID marker_ID, M.taxon_ID
  FROM marker M, MARKER_marker_alias MMA, MARKER_ALIAS MA
WHERE MMA.marker_ID = M.ID AND MMA.marker_alias_ID = MA.ID AND M.NAME NOT LIKE 
       '-' AND M.taxon_ID IS NOT NULL; 

@$LOAD/indexes/marker.lower.sql;
@$LOAD/indexes/marker_lookup.cols.sql;
@$LOAD/indexes/marker_marker_alias.cols.sql;
@$LOAD/indexes/marker_marker_alias.lower.sql;
@$LOAD/indexes/marker_alias.lower.sql;
@$LOAD/indexes/gene_marker.cols.sql;
@$LOAD/indexes/gene_marker.lower.sql;

@$LOAD/indexes/zstg_marker_alias.cols.sql;
@$LOAD/indexes/zstg_marker_alias.lower.sql;

@$LOAD/constraints/marker.enable.sql;
@$LOAD/constraints/gene_marker.enable.sql;
@$LOAD/constraints/marker_alias.enable.sql;
@$LOAD/constraints/marker_marker_alias.enable.sql;
@$LOAD/constraints/marker_lookup.enable.sql;
@$LOAD/constraints/zstg_marker_alias.enable.sql;


@$LOAD/triggers/marker.enable.sql;
@$LOAD/triggers/marker_alias.enable.sql;
@$LOAD/triggers/marker_marker_alias.enable.sql;


ANALYZE TABLE marker COMPUTE STATISTICS;
ANALYZE TABLE marker_alias COMPUTE STATISTICS;
ANALYZE TABLE marker_marker_alias COMPUTE STATISTICS;
ANALYZE TABLE gene_marker COMPUTE STATISTICS;

COMMIT;
EXIT;
