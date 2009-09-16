delete from zstg_rna_probesets_tmp where genechip_array like 'please see the bundled README%';
commit;
@$LOAD/arrays/array_createIndexes.sql;
@$LOAD/arrays/array_enableConstraints.sql;
EXIT;
