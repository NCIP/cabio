
set termout on;

set echo on;

set feedback on;

set heading on;

set verify on;

select count(*) from PROTOCOL_DISEASES where BIG_ID is NULL;
select count(*) from PROTOCOLS where BIG_ID is NULL;
select count(*) from LOCATION_CH where BIG_ID is NULL;
select count(*) from ARRAY_REPORTER_CH where BIG_ID is NULL;
select count(*) from PID_PHYSICAL_ENTITY where BIG_ID is NULL;
select count(*) from PID_PARTICIPANT where BIG_ID is NULL;
select count(*) from PID_INTERACTION where BIG_ID is NULL;
select count(*) from PID_ENTITY_NAME where BIG_ID is NULL;
select count(*) from PID_ENTITY_ACCESSION where BIG_ID is NULL;
select count(*) from BIO_PATHWAYS_TV where BIG_ID is NULL;
select count(*) from GENE_FUNCTION_ASSOCIATION where BIG_ID is NULL;
select count(*) from HISTOLOGY_CODE where BIG_ID is NULL;
select count(*) from EVIDENCE where BIG_ID is NULL;
select count(*) from EVIDENCE_CODE where BIG_ID is NULL;
select count(*) from TARGET where BIG_ID is NULL;
select count(*) from AGENT where BIG_ID is NULL;
select count(*) from RELATIVE_LOCATION_CH where BIG_ID is NULL;
select count(*) from RELATIVE_LOCATION where BIG_ID is NULL;
select count(*) from ARRAY_REPORTER where BIG_ID is NULL;
select count(*) from POPULATION_FREQUENCY where BIG_ID is NULL;
select count(*) from TRANSCRIPT_ARRAY_REPORTER where BIG_ID is NULL;
select count(*) from MICROARRAY where BIG_ID is NULL;
select count(*) from TRANSCRIPT where BIG_ID is NULL;
select count(*) from EXON where BIG_ID is NULL;
select count(*) from EXON_REPORTER where BIG_ID is NULL;
select count(*) from SNP_REPORTER where BIG_ID is NULL;
select count(*) from EXPRESSION_REPORTER where BIG_ID is NULL;
select count(*) from MARKER_RELATIVE_LOCATION where BIG_ID is NULL;
select count(*) from GENE_RELATIVE_LOCATION where BIG_ID is NULL;
select count(*) from PROTEIN_DOMAIN where BIG_ID is NULL;
select count(*) from CYTOGENIC_LOCATION_CYTOBAND where BIG_ID is NULL;
select count(*) from GENE_ALIAS_OBJECT_TV where BIG_ID is NULL;
select count(*) from GENERIC_ARRAY where BIG_ID is NULL;
select count(*) from GENERIC_REPORTER where BIG_ID is NULL;
select count(*) from GO_RELATIONSHIP where BIG_ID is NULL;
select count(*) from HOMOLOGOUS_ASSOCIATION where BIG_ID is NULL;
select count(*) from GO_ONTOLOGY where BIG_ID is NULL;
select count(*) from MARKER_ALIAS where BIG_ID is NULL;
select count(*) from MARKER where BIG_ID is NULL;
select count(*) from CYTOBAND where BIG_ID is NULL;
select count(*) from NUCLEIC_ACID_SEQUENCE where BIG_ID is NULL;
select count(*) from CLONE_RELATIVE_LOCATION where BIG_ID is NULL;
select count(*) from CLONE_TV where BIG_ID is NULL;
select count(*) from SNP_TV where BIG_ID is NULL;
select count(*) from PROTEIN_SEQUENCE where BIG_ID is NULL;
select count(*) from GENE_TV where BIG_ID is NULL;
select count(*) from PROTEIN_ALIAS where BIG_ID is NULL;
select count(*) from NEW_PROTEIN where BIG_ID is NULL;
select count(*) from TISSUE_SAMPLE where BIG_ID is NULL;
select count(*) from LIBRARY where BIG_ID is NULL;
select count(*) from VOCABULARY where BIG_ID is NULL;
select count(*) from TISSUE_CODE where BIG_ID is NULL;
select count(*) from TAXON where BIG_ID is NULL;
select count(*) from PROTOCOL where BIG_ID is NULL;
select count(*) from ORGANONTOLOGYRELATIONSHIP where BIG_ID is NULL;
select count(*) from HISTOPATHOLOGY_TST where BIG_ID is NULL;
select count(*) from DISEASE_RELATIONSHIP where BIG_ID is NULL;
select count(*) from CHROMOSOME where BIG_ID is NULL;
select count(*) from ANOMALY where BIG_ID is NULL;

EXIT;
