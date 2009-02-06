-- GF16793 -- Remove new prefixes and suffixes
-- TBD : Move logic to parser
update new_protein set name = replace(name,'RecName: Full=','');
update new_protein set name = replace(name,'Short=','');
update new_protein set name = replace(name,';','');
commit;

update protein_alias set name = replace(name,'AltName: Full=','');
update protein_alias set name = replace(name,'AltName: INN=','');
update protein_alias set name = replace(name,'AltName: ','');
update protein_alias set name = replace(name,';','');
commit ;

-- GF17149 -> Protein Protein Alias
insert into protein_protein_alias (protein_id, protein_alias_id) select protein_id, id from protein_alias;
commit;

-- rebuild all indexes for protein related tables
@$LOAD/indexes/new_protein.lower.sql;
@$LOAD/indexes/protein_alias.lower.sql;
@$LOAD/indexes/protein_protein_alias.lower.sql;
@$LOAD/indexes/zstg_protein_embl.lower.sql;
@$LOAD/indexes/protein_keywords.lower.sql;
@$LOAD/indexes/protein_secondary_accession.lower.sql;
@$LOAD/indexes/protein_sequence.lower.sql;
@$LOAD/indexes/protein_taxon.lower.sql;


-- rebuild all indexes for protein related tables
@$LOAD/indexes/new_protein.cols.sql;
@$LOAD/indexes/protein_alias.cols.sql;
@$LOAD/indexes/protein_protein_alias.cols.sql;
@$LOAD/indexes/zstg_protein_embl.cols.sql;
@$LOAD/indexes/protein_keywords.cols.sql;
@$LOAD/indexes/protein_secondary_accession.cols.sql;
@$LOAD/indexes/protein_sequence.cols.sql;
@$LOAD/indexes/protein_taxon.cols.sql;

-- enable all triggers for protein related tables
@$LOAD/triggers/new_protein.enable.sql;
@$LOAD/triggers/protein_alias.enable.sql;
@$LOAD/triggers/protein_protein_alias.enable.sql;
@$LOAD/triggers/zstg_protein_embl.enable.sql;
@$LOAD/triggers/protein_keywords.enable.sql;
@$LOAD/triggers/protein_secondary_accession.enable.sql;
@$LOAD/triggers/protein_sequence.enable.sql;
@$LOAD/triggers/protein_taxon.enable.sql;


-- enable all constraints for protein related tables
@$LOAD/constraints/new_protein.enable.sql;
@$LOAD/constraints/protein_alias.enable.sql;
@$LOAD/constraints/protein_protein_alias.enable.sql;
@$LOAD/constraints/zstg_protein_embl.enable.sql;
@$LOAD/constraints/protein_keywords.enable.sql;
@$LOAD/constraints/protein_secondary_accession.enable.sql;
@$LOAD/constraints/protein_sequence.enable.sql;
@$LOAD/constraints/protein_taxon.enable.sql;

--ANALYZE TABLE new_protein COMPUTE STATISTICS;
--ANALYZE TABLE protein_alias COMPUTE STATISTICS;
--ANALYZE TABLE zstg_protein_embl COMPUTE STATISTICS;
--ANALYZE TABLE protein_keywords COMPUTE STATISTICS;
--ANALYZE TABLE protein_secondary_accession COMPUTE STATISTICS;
--ANALYZE TABLE protein_sequence COMPUTE STATISTICS;
--ANALYZE TABLE protein_taxon COMPUTE STATISTICS;

COMMIT;

EXIT;
