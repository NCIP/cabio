/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

create unique index ARREPBIGID_idx on ARRAY_REPORTER_CH
(BIG_ID) tablespace CABIO_FUT;
alter table ARRAY_REPORTER_CH enable constraint ARREPBIGID using index ARREPBIGID_idx;
create unique index BPTBIGID_idx on BIO_PATHWAYS_TV
(BIG_ID) tablespace CABIO_FUT;
alter table BIO_PATHWAYS_TV enable constraint BPTBIGID using index BPTBIGID_idx;
create unique index CHRBIGID_idx on CHROMOSOME
(BIG_ID) tablespace CABIO_FUT;
alter table CHROMOSOME enable constraint CHRBIGID using index CHRBIGID_idx;
create unique index CTVBIGID_idx on CLONE_TV
(BIG_ID) tablespace CABIO_FUT;
alter table CLONE_TV enable constraint CTVBIGID using index CTVBIGID_idx;
create unique index CYTOBIGID_idx on CYTOBAND
(BIG_ID) tablespace CABIO_FUT;
alter table CYTOBAND enable constraint CYTOBIGID using index CYTOBIGID_idx;
create unique index CCCBIGID_idx on CYTOGENIC_LOCATION_CYTOBAND
(BIG_ID) tablespace CABIO_FUT;
alter table CYTOGENIC_LOCATION_CYTOBAND enable constraint CCCBIGID using index CCCBIGID_idx;
create unique index DRBIGID_idx on DISEASE_RELATIONSHIP
(BIG_ID) tablespace CABIO_FUT;
alter table DISEASE_RELATIONSHIP enable constraint DRBIGID using index DRBIGID_idx;
create unique index XONBIGID_idx on EXON
(BIG_ID) tablespace CABIO_FUT;
alter table EXON enable constraint XONBIGID using index XONBIGID_idx;
create unique index XONREPORTER_idx on EXON_REPORTER
(BIG_ID) tablespace CABIO_FUT;
alter table EXON_REPORTER enable constraint XONREPORTER using index XONREPORTER_idx;
create unique index EXPRREPBIGID_idx on EXPRESSION_REPORTER
(BIG_ID) tablespace CABIO_FUT;
alter table EXPRESSION_REPORTER enable constraint EXPRREPBIGID using index EXPRREPBIGID_idx;
create unique index GABIGID_idx on GENERIC_ARRAY
(BIG_ID) tablespace CABIO_FUT;
alter table GENERIC_ARRAY enable constraint GABIGID using index GABIGID_idx;
create unique index GREP_idx on GENERIC_REPORTER
(BIG_ID) tablespace CABIO_FUT;
alter table GENERIC_REPORTER enable constraint GREP using index GREP_idx;
create unique index GAOBIGID_idx on GENE_ALIAS_OBJECT_TV
(BIG_ID) tablespace CABIO_FUT;
alter table GENE_ALIAS_OBJECT_TV enable constraint GAOBIGID using index GAOBIGID_idx;
create unique index GTVBIGID_idx on GENE_TV
(BIG_ID) tablespace CABIO_FUT;
alter table GENE_TV enable constraint GTVBIGID using index GTVBIGID_idx;
create unique index GOOBIGID_idx on GO_ONTOLOGY
(BIG_ID) tablespace CABIO_FUT;
alter table GO_ONTOLOGY enable constraint GOOBIGID using index GOOBIGID_idx;
create unique index GORBIGID_idx on GO_RELATIONSHIP
(BIG_ID) tablespace CABIO_FUT;
alter table GO_RELATIONSHIP enable constraint GORBIGID using index GORBIGID_idx;
create unique index HCBIGID_idx on HISTOLOGY_CODE
(BIG_ID) tablespace CABIO_FUT;
alter table HISTOLOGY_CODE enable constraint HCBIGID using index HCBIGID_idx;
create unique index HISTOBIGID_idx on HISTOPATHOLOGY_TST
(BIG_ID) tablespace CABIO_FUT;
alter table HISTOPATHOLOGY_TST enable constraint HISTOBIGID using index HISTOBIGID_idx;
create unique index HABIGID_idx on HOMOLOGOUS_ASSOCIATION
(BIG_ID) tablespace CABIO_FUT;
alter table HOMOLOGOUS_ASSOCIATION enable constraint HABIGID using index HABIGID_idx;
create unique index LIBBIGID_idx on LIBRARY
(BIG_ID) tablespace CABIO_FUT;
alter table LIBRARY enable constraint LIBBIGID using index LIBBIGID_idx;
create unique index MARKERBIGID_idx on MARKER
(BIG_ID) tablespace CABIO_FUT;
alter table MARKER enable constraint MARKERBIGID using index MARKERBIGID_idx;
create unique index MABIGID_idx on MARKER_ALIAS
(BIG_ID) tablespace CABIO_FUT;
alter table MARKER_ALIAS enable constraint MABIGID using index MABIGID_idx;
create unique index MABIGIDUNIQ_idx on MICROARRAY
(BIG_ID) tablespace CABIO_FUT;
alter table MICROARRAY enable constraint MABIGIDUNIQ using index MABIGIDUNIQ_idx;
create unique index NPBIGIDUNIQ_idx on NEW_PROTEIN
(BIG_ID) tablespace CABIO_FUT;
alter table NEW_PROTEIN enable constraint NPBIGIDUNIQ using index NPBIGIDUNIQ_idx;
create unique index NASBIGID_idx on NUCLEIC_ACID_SEQUENCE
(BIG_ID) tablespace CABIO_FUT;
alter table NUCLEIC_ACID_SEQUENCE enable constraint NASBIGID using index NASBIGID_idx;
create unique index OORBIGID_idx on ORGANONTOLOGYRELATIONSHIP
(BIG_ID) tablespace CABIO_FUT;
alter table ORGANONTOLOGYRELATIONSHIP enable constraint OORBIGID using index OORBIGID_idx;
create unique index PFBIGID_idx on POPULATION_FREQUENCY
(BIG_ID) tablespace CABIO_FUT;
alter table POPULATION_FREQUENCY enable constraint PFBIGID using index PFBIGID_idx;
create unique index PABIGID_idx on PROTEIN_ALIAS
(BIG_ID) tablespace CABIO_FUT;
alter table PROTEIN_ALIAS enable constraint PABIGID using index PABIGID_idx;
create unique index PDBIGID_idx on PROTEIN_DOMAIN
(BIG_ID) tablespace CABIO_FUT;
alter table PROTEIN_DOMAIN enable constraint PDBIGID using index PDBIGID_idx;
create unique index PROTSEQ_idx on PROTEIN_SEQUENCE
(BIG_ID) tablespace CABIO_FUT;
alter table PROTEIN_SEQUENCE enable constraint PROTSEQ using index PROTSEQ_idx;
create unique index PROBIGIDUN_idx on PROTOCOL
(BIG_ID) tablespace CABIO_FUT;
alter table PROTOCOL enable constraint PROBIGIDUN using index PROBIGIDUN_idx;
create unique index RCHBIGID_idx on RELATIVE_LOCATION
(BIG_ID) tablespace CABIO_FUT;
alter table RELATIVE_LOCATION enable constraint RCHBIGID using index RCHBIGID_idx;
create unique index SNPREPBIGID_idx on SNP_REPORTER
(BIG_ID) tablespace CABIO_FUT;
alter table SNP_REPORTER enable constraint SNPREPBIGID using index SNPREPBIGID_idx;
create unique index SYS_C004768_idx on TARGET
(BIG_ID) tablespace CABIO_FUT;
alter table TARGET enable constraint SYS_C004768 using index SYS_C004768_idx;
create unique index TARGETBIGID_idx on TARGET
(BIG_ID) tablespace CABIO_FUT;
alter table TARGET enable constraint TARGETBIGID using index TARGETBIGID_idx;
create unique index SYS_C004778_idx on TAXON
(BIG_ID) tablespace CABIO_FUT;
alter table TAXON enable constraint SYS_C004778 using index SYS_C004778_idx;
create unique index TAXBIGID_idx on TAXON
(BIG_ID) tablespace CABIO_FUT;
alter table TAXON enable constraint TAXBIGID using index TAXBIGID_idx;
create unique index SYS_C004788_idx on TISSUE_CODE
(BIG_ID) tablespace CABIO_FUT;
alter table TISSUE_CODE enable constraint SYS_C004788 using index SYS_C004788_idx;
create unique index TCBIGID_idx on TISSUE_CODE
(BIG_ID) tablespace CABIO_FUT;
alter table TISSUE_CODE enable constraint TCBIGID using index TCBIGID_idx;
create unique index TISSSAMP_idx on TISSUE_SAMPLE
(BIG_ID) tablespace CABIO_FUT;
alter table TISSUE_SAMPLE enable constraint TISSSAMP using index TISSSAMP_idx;
create unique index SYS_C004802_idx on TRANSCRIPT
(BIG_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT enable constraint SYS_C004802 using index SYS_C004802_idx;
create unique index XSCRIPTBIGID_idx on TRANSCRIPT
(BIG_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT enable constraint XSCRIPTBIGID using index XSCRIPTBIGID_idx;
create unique index SYS_C004808_idx on TRANSCRIPT_ARRAY_REPORTER
(BIG_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C004808 using index SYS_C004808_idx;
create unique index XSCRIPTARRREP_idx on TRANSCRIPT_ARRAY_REPORTER
(BIG_ID) tablespace CABIO_FUT;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint XSCRIPTARRREP using index XSCRIPTARRREP_idx;
create unique index SYS_C004820_idx on VOCABULARY
(BIG_ID) tablespace CABIO_FUT;
alter table VOCABULARY enable constraint SYS_C004820 using index SYS_C004820_idx;
create unique index BIGID_idx on VOCABULARY
(BIG_ID) tablespace CABIO_FUT;
alter table VOCABULARY enable constraint BIGID using index BIGID_idx;
create unique index SYS_C0017726_idx on PID_ENTITY_ACCESSION
(BIG_ID) tablespace CABIO_FUT;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0017726 using index SYS_C0017726_idx;
create unique index SYS_C0016534_idx on CHROMOSOME
(BIG_ID) tablespace CABIO_FUT;
alter table CHROMOSOME enable constraint SYS_C0016534 using index SYS_C0016534_idx;

alter table ARRAY_REPORTER_CH enable constraint ARREPBIGID;
alter table BIO_PATHWAYS_TV enable constraint BPTBIGID;
alter table CHROMOSOME enable constraint CHRBIGID;
alter table CLONE_TV enable constraint CTVBIGID;
alter table CYTOBAND enable constraint CYTOBIGID;
alter table CYTOGENIC_LOCATION_CYTOBAND enable constraint CCCBIGID;
alter table DISEASE_RELATIONSHIP enable constraint DRBIGID;
alter table EXON enable constraint XONBIGID;
alter table EXON_REPORTER enable constraint XONREPORTER;
alter table EXPRESSION_REPORTER enable constraint EXPRREPBIGID;
alter table GENERIC_ARRAY enable constraint GABIGID;
alter table GENERIC_REPORTER enable constraint GREP;
alter table GENE_ALIAS_OBJECT_TV enable constraint GAOBIGID;
alter table GENE_TV enable constraint GTVBIGID;
alter table GO_ONTOLOGY enable constraint GOOBIGID;
alter table GO_RELATIONSHIP enable constraint GORBIGID;
alter table HISTOLOGY_CODE enable constraint HCBIGID;
alter table HISTOPATHOLOGY_TST enable constraint HISTOBIGID;
alter table HOMOLOGOUS_ASSOCIATION enable constraint HABIGID;
alter table LIBRARY enable constraint LIBBIGID;
alter table MARKER enable constraint MARKERBIGID;
alter table MARKER_ALIAS enable constraint MABIGID;
alter table MICROARRAY enable constraint MABIGIDUNIQ;
alter table NEW_PROTEIN enable constraint NPBIGIDUNIQ;
alter table NUCLEIC_ACID_SEQUENCE enable constraint NASBIGID;
alter table ORGANONTOLOGYRELATIONSHIP enable constraint OORBIGID;
alter table POPULATION_FREQUENCY enable constraint PFBIGID;
alter table PROTEIN_ALIAS enable constraint PABIGID;
alter table PROTEIN_DOMAIN enable constraint PDBIGID;
alter table PROTEIN_SEQUENCE enable constraint PROTSEQ;
alter table PROTOCOL enable constraint PROBIGIDUN;
alter table RELATIVE_LOCATION enable constraint RCHBIGID;
alter table SNP_REPORTER enable constraint SNPREPBIGID;
alter table TARGET enable constraint SYS_C004768;
alter table TARGET enable constraint TARGETBIGID;
alter table TAXON enable constraint SYS_C004778;
alter table TAXON enable constraint TAXBIGID;
alter table TISSUE_CODE enable constraint SYS_C004788;
alter table TISSUE_CODE enable constraint TCBIGID;
alter table TISSUE_SAMPLE enable constraint TISSSAMP;
alter table TRANSCRIPT enable constraint SYS_C004802;
alter table TRANSCRIPT enable constraint XSCRIPTBIGID;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint SYS_C004808;
alter table TRANSCRIPT_ARRAY_REPORTER enable constraint XSCRIPTARRREP;
alter table VOCABULARY enable constraint SYS_C004820;
alter table VOCABULARY enable constraint BIGID;
alter table ZSTG_EXON_REPORTER enable constraint SYS_C004892;
alter table PID_ENTITY_ACCESSION enable constraint SYS_C0017726;
alter table CHROMOSOME enable constraint SYS_C0016534;
alter table ZSTG_OLD_PROTOCOLS enable constraint SYS_C0020924;
alter table ZSTG_OLD_PROTOCOL_DISEASES enable constraint SYS_C0020928;
alter table ZSTG_TARGET enable constraint SYS_C0021023;
alter table ZSTG_AGENT_BK enable constraint SYS_C0026163;
alter table ZSTG_TAXON enable constraint SYS_C0031758;

EXIT;
