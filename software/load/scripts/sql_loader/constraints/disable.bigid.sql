/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

alter table ARRAY_REPORTER_CH disable constraint ARREPBIGID;
alter table BIO_PATHWAYS_TV disable constraint BPTBIGID;
alter table CHROMOSOME disable constraint CHRBIGID;
alter table CLONE_TV disable constraint CTVBIGID;
alter table CYTOBAND disable constraint CYTOBIGID;
alter table CYTOGENIC_LOCATION_CYTOBAND disable constraint CCCBIGID;
alter table DISEASE_RELATIONSHIP disable constraint DRBIGID;
alter table EXON disable constraint XONBIGID;
alter table EXON_REPORTER disable constraint XONREPORTER;
alter table EXPRESSION_REPORTER disable constraint EXPRREPBIGID;
alter table GENERIC_ARRAY disable constraint GABIGID;
alter table GENERIC_REPORTER disable constraint GREP;
alter table GENE_ALIAS_OBJECT_TV disable constraint GAOBIGID;
alter table GENE_TV disable constraint GTVBIGID;
alter table GO_ONTOLOGY disable constraint GOOBIGID;
alter table GO_RELATIONSHIP disable constraint GORBIGID;
alter table HISTOLOGY_CODE disable constraint HCBIGID;
alter table HISTOPATHOLOGY_TST disable constraint HISTOBIGID;
alter table HOMOLOGOUS_ASSOCIATION disable constraint HABIGID;
alter table LIBRARY disable constraint LIBBIGID;
alter table MARKER disable constraint MARKERBIGID;
alter table MARKER_ALIAS disable constraint MABIGID;
alter table MICROARRAY disable constraint MABIGIDUNIQ;
alter table NEW_PROTEIN disable constraint NPBIGIDUNIQ;
alter table NUCLEIC_ACID_SEQUENCE disable constraint NASBIGID;
alter table ORGANONTOLOGYRELATIONSHIP disable constraint OORBIGID;
alter table POPULATION_FREQUENCY disable constraint PFBIGID;
alter table PROTEIN_ALIAS disable constraint PABIGID;
alter table PROTEIN_DOMAIN disable constraint PDBIGID;
alter table PROTEIN_SEQUENCE disable constraint PROTSEQ;
alter table PROTOCOL disable constraint PROBIGIDUN;
alter table RELATIVE_LOCATION disable constraint RCHBIGID;
alter table SNP_REPORTER disable constraint SNPREPBIGID;
alter table TARGET disable constraint TARGETBIGID;
alter table TAXON disable constraint TAXBIGID;
alter table TISSUE_CODE disable constraint TCBIGID;
alter table TISSUE_SAMPLE disable constraint TISSSAMP;
alter table TRANSCRIPT disable constraint XSCRIPTBIGID;
alter table TRANSCRIPT_ARRAY_REPORTER disable constraint XSCRIPTARRREP;
alter table VOCABULARY disable constraint BIGID;
alter table ZSTG_EXON_REPORTER disable constraint SYS_C004892;
alter table PID_ENTITY_ACCESSION disable constraint SYS_C0017726;

EXIT;
