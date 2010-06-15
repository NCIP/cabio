DROP TABLE ma_database_cross_reference;
DROP TABLE ma_rel_feature_ms_annotation;
DROP TABLE ma_molecular_seq_annotation;
DROP TABLE ma_disease;
DROP TABLE ma_therapeutic_agent;
DROP TABLE ma_rel_gene_array_reporter;
DROP TABLE ma_rel_location_feature;    
DROP TABLE ma_physical_location;
DROP TABLE ma_array_reporter;
DROP TABLE ma_microarray;
DROP TABLE ma_rel_gene_nas_variation;
DROP TABLE ma_feature;
DROP TABLE ma_organism;
DROP TABLE ma_chromosome;
DROP TABLE ma_genome;
DROP TABLE ma_homologous_association;


DROP sequence ma_genome_pk;
DROP sequence ma_chromosome_pk;
DROP sequence ma_organism_pk;
DROP sequence ma_feature_pk;
DROP sequence ma_microarray_pk;
DROP sequence ma_array_reporter_pk;
DROP sequence ma_physical_location_pk;
DROP sequence ma_therapeutic_agent_pk;
DROP sequence ma_disease_pk;
DROP sequence ma_molecular_seq_annotation_pk;
DROP sequence ma_database_cross_reference_pk;
DROP sequence ma_homologous_association_pk;

   
CREATE TABLE ma_genome (
                        id NUMBER, 
                        assembly_source VARCHAR2(50),
                        assembly_version VARCHAR2(50), 
                        primary key (id)
                        ) TABLESPACE CABIO_FUT;

CREATE TABLE ma_chromosome 
                          (
                            id NUMBER,
                            name VARCHAR2(50), 
                            genome_id NUMBER, 
                            primary key (id)
                           ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_organism(
                         id NUMBER, 
                         scientific_name VARCHAR2(50), 
                         common_name  VARCHAR2(50), 
                         ncbi_taxonomy_id NUMBER, 
                         taxonomy_rank VARCHAR2(50),
                         primary key (id)
                         ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_feature
                         (
                          id NUMBER, 
                          full_name VARCHAR2(200), 
                          symbol VARCHAR2(50), 
                          feature_type VARCHAR(2),
                          amino_acid_change VARCHAR(30),
                          chr_x_pseudo_autosomal_region NUMBER, 
                          coding_status VARCHAR2(10), 
                          flank VARCHAR2(55), 
                          validation_status VARCHAR2(50),
                          organism_id NUMBER, 
                          discriminator VARCHAR2(50), 
                          alleles VARCHAR2(50), 
                          primary key (id)

                        ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_microarray (
                            id NUMBER, 
                            ARRAY_name VARCHAR2(50), 
                            description VARCHAR2(100), 
                            platform VARCHAR2(50),
                            annotation_date DATE, 
                            annotion_version VARCHAR2(50), 
                            db_snp_version VARCHAR(50), 
                            genome_version VARCHAR2(100), 
                            type VARCHAR2(50), 
                            lsid VARCHAR2(100), primary key (id)   
                            ) TABLESPACE CABIO_FUT;




CREATE TABLE ma_array_reporter(
                               id NUMBER, 
                               name VARCHAR2(50), 
                               microarray_id NUMBER, 
                               primary key (id)) TABLESPACE CABIO_FUT;



CREATE TABLE ma_physical_location
                             (
                              id NUMBER, 
                              chromosome_id NUMBER,
                              start_coordinate NUMBER, 
                              end_coordinate NUMBER,                               
                              orientation VARCHAR2(10), 
                              array_reporter_id NUMBER, 
                              primary key (id)
                              ) TABLESPACE CABIO_FUT;

CREATE TABLE ma_rel_location_feature
                             (
                                  feature_id NUMBER NOT NULL,
	                          location_id  NUMBER NOT NULL
                              ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_rel_gene_nas_variation
                             (
                                  gene_id NUMBER NOT NULL,
	                          nas_variation_id  NUMBER NOT NULL
                              ) TABLESPACE CABIO_FUT;



CREATE TABLE ma_rel_gene_array_reporter
                             (
                              gene_id NUMBER, 
                              array_reporter_id NUMBER
                              ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_disease
                              (
                                id NUMBER NOT NULL,
	                             evs_id VARCHAR2(50),
	                             name    VARCHAR2(50),
                                primary key (id)
                               ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_therapeutic_agent
                              (	
                                 id NUMBER NOT NULL,
	                              description  VARCHAR2(110),
	                              evs_id VARCHAR2(50),
                                 name  VARCHAR2(50),
                                 primary key (id)
                               ) TABLESPACE CABIO_FUT;



CREATE TABLE ma_molecular_seq_annotation
                              (
                               	id NUMBER,
	                              source VARCHAR2(50),
                              	term  VARCHAR2(50),
	                              role  VARCHAR2(50),
                              	therapeutic_agent_id NUMBER,
	                              disease_id NUMBER,
                              	discriminator VARCHAR2(50),
                                 primary key (id)

                               ) TABLESPACE CABIO_FUT;

CREATE TABLE ma_rel_feature_ms_annotation
                                (
	                                molecular_seq_annotation_id  NUMBER NOT NULL,
	                                feature_id  NUMBER NOT NULL
                                ) TABLESPACE CABIO_FUT;

CREATE TABLE ma_database_cross_reference
                                    (
                                       id NUMBER NOT NULL,
	                                    database_name VARCHAR2(50),
	                                    identifier VARCHAR2(50) NOT NULL,
	                                    discriminator VARCHAR2(50),
	                                    therapeutic_agent_id NUMBER,
                                       variation_id  NUMBER,
                                       gene_id NUMBER ,
                                       primary key (id)
                                    ) TABLESPACE CABIO_FUT;


CREATE TABLE ma_homologous_association
                                (
	                                id  NUMBER NOT NULL,
	                                similarity_percentage  float,
	                                gene_id NUMBER,
	                                homologous_gene_id NUMBER,
	                                 primary key (id)
                                ) TABLESPACE CABIO_FUT;


ALTER TABLE ma_database_cross_reference ADD foreign key(therapeutic_agent_id) references ma_therapeutic_agent (ID) ON DELETE cascade;
ALTER TABLE ma_database_cross_reference ADD foreign key(variation_id) references ma_feature (ID) ON DELETE cascade;
ALTER TABLE ma_database_cross_reference ADD foreign key(gene_id) references ma_feature (ID) ON DELETE cascade;




ALTER TABLE ma_rel_feature_ms_annotation ADD foreign key(molecular_seq_annotation_id) references ma_molecular_seq_annotation (ID) ON DELETE cascade;
ALTER TABLE ma_rel_feature_ms_annotation ADD foreign key(feature_id) references ma_feature (ID) ON DELETE cascade;



ALTER TABLE ma_molecular_seq_annotation ADD foreign key(therapeutic_agent_id) references ma_therapeutic_agent(ID) ON DELETE cascade;
ALTER TABLE ma_molecular_seq_annotation ADD foreign key(disease_id) references ma_disease (ID) ON DELETE cascade;



ALTER TABLE ma_rel_gene_array_reporter ADD foreign key(gene_id) references ma_feature (ID) ON DELETE cascade;
ALTER TABLE ma_rel_gene_array_reporter ADD foreign key(array_reporter_id) references ma_array_reporter(ID) ON DELETE cascade;

ALTER TABLE ma_rel_location_feature ADD foreign key(feature_id) references ma_feature (ID) ON DELETE cascade;
ALTER TABLE ma_rel_location_feature ADD foreign key(location_id) references ma_physical_location (ID) ON DELETE cascade;


ALTER TABLE ma_physical_location ADD foreign key(array_reporter_id) references ma_array_reporter(ID) ON DELETE cascade;
ALTER TABLE ma_physical_location ADD foreign key(chromosome_id) references ma_chromosome(ID) ON DELETE cascade;


ALTER TABLE ma_array_reporter ADD foreign key(microarray_id) references ma_microarray(ID) ON DELETE cascade;
                                                                       

ALTER TABLE ma_rel_gene_nas_variation  ADD foreign key (gene_id) references ma_feature (ID) ON DELETE cascade;
ALTER TABLE ma_rel_gene_nas_variation  ADD foreign key (nas_variation_id) references ma_feature (ID) ON DELETE cascade;



ALTER TABLE ma_feature ADD foreign key(organism_id) references ma_organism(ID) ON DELETE cascade;


ALTER TABLE ma_chromosome ADD foreign key(genome_id) references ma_genome(ID) ON DELETE cascade; 

ALTER TABLE ma_homologous_association ADD foreign key(gene_id) references ma_gene(ID) ON DELETE cascade;
ALTER TABLE ma_homologous_association ADD foreign key(homologous_gene_id) references ma_gene(ID) ON DELETE cascade;


CREATE sequence ma_genome_pk;
CREATE sequence ma_chromosome_pk;
CREATE sequence ma_organism_pk;
CREATE sequence ma_feature_pk;
CREATE sequence ma_microarray_pk;
CREATE sequence ma_array_reporter_pk;
CREATE sequence ma_physical_location_pk;
CREATE sequence ma_therapeutic_agent_pk;
CREATE sequence ma_disease_pk;
CREATE sequence ma_molecular_seq_annotation_pk;
CREATE sequence ma_database_cross_reference_pk;
CREATE sequence ma_homologous_association_pk;
