/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

DROP INDEX g2a_gid_idx;
DROP INDEX g2u_gid_idx;
DROP INDEX g2a_pa_idx;
DROP index np_pa_idx;
DROP INDEX np_pi_idx;
DROP index g2u_uc_idx;

CREATE INDEX G2A_GID_IDX on zstg_gene2ACCESSION(GENEID);
CREATE INDEX G2U_GID_IDX on zstg_gene2UNIGENE(GENEID);
CREATE INDEX g2a_pa_idx on zstg_gene2accession(protein_accession);
CREATE INDEX np_pa_idx on new_protein(rtrim(primary_accession));
CREATE INDEX np_pi_idx on new_protein(protein_id);
CREATE INDEX g2u_uc_idx on zstg_gene2UNIGENE(UNIGENE_CLUSTER);
drop table zstg_gpid;

CREATE TABLE ZSTG_GPID tablespace cabio_map_fut as SELECT distinct g2u.geneID, g2u.UNIGENE_CLUSTER, np.PROTEIN_ID from zstg_gene2UNIGENE g2u, zstg_gene2accession g2a, new_protein np WHERE g2u.GENEID = g2a.GENEID and substr(g2a.protein_accession,0,decode(instr(g2a.protein_accession,'.'),0,length(g2a.protein_accession), instr(g2a.protein_accession,'.')-1)) = rtrim(np.PRIMARY_ACCESSION);

DROP INDEX gtv_tid_idx;
DROP INDEX gtv_cid_idx;

CREATE INDEX tmp_pid_idx on zstg_gpid(protein_id);
CREATE INDEX tmp_pid_gid_idx on zstg_gpid(protein_id, geneid);
CREATE INDEX gtv_tid_idx on gene_tv(taxon_id);
CREATE INDEX gtv_cid_idx on gene_tv(cluster_id);
CREATE INDEX tmp_ucid_idx on zstg_GPID(substr(unigene_cluster, 4));

TRUNCATE TABLE gene_protein_tv REUSE STORAGE;
@$LOAD/indexer_new.sql gene_protein_tv
@$LOAD/constraints.sql gene_protein_tv
@$LOAD/triggers.sql gene_protein_tv

@$LOAD/constraints/gene_protein_tv.disable.sql
@$LOAD/indexes/gene_protein_tv.drop.sql
@$LOAD/triggers/gene_protein_tv.disable.sql


INSERT INTO gene_protein_tv select distinct a.GENE_ID, b.PROTEIN_ID from gene_tv a, ZSTG_GPID b where a.CLUSTER_ID = SUBSTR(b.UNIGENE_cluster,4) and a.taxon_ID in (5,6);
DROP TABLE ZSTG_GPID;
COMMIT;


@$LOAD/indexes/gene_protein_tv.cols.sql
@$LOAD/indexes/gene_protein_tv.lower.sql
@$LOAD/constraints/gene_protein_tv.enable.sql
@$LOAD/triggers/gene_protein_tv.enable.sql
ANALYZE TABLE gene_protein_tv COMPUTE STATISTICS;
exit;
