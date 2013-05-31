/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- create all PL/SQL procedures needed for loading
@population_frequency.sql;
@snp_tv.sql;
@gene_tv31_ld.sql;

@nucleic_acid_seq31a2b.sql;
@nucleic_acid_seq31.sql;

@generic_32.sql;

@homologous_association31a_ld.sql;
@homologous_association31b_ld.sql;

@organOntologyRelationship31_ld.sql;
@disease_relationship31_ld.sql;

@clone_tv31_ld.sql;

@db_cross_ref_01.sql;
@db_cross_ref_02.sql;
@db_cross_ref_03.sql;
@db_cross_ref_04.sql;
@db_cross_ref_05.sql;
@db_cross_ref_06.sql;

@physical_l_cyto31_00_ld.sql;
@physical_l_cyto31_01_ld.sql;

@physical_l_human31_ld.sql;
@physical_l_mouse31_ld.sql;

@physical_l_est_human31_ld.sql;
@physical_l_est_mouse31_ld.sql;

@physical_l_snp31a_ld.sql;
@physical_l_exon_ld.sql;

@cytoband31_01_ld.sql;
@cytoband31_02_ld.sql;
@cytoband31_03_ld.sql;

@cyto_l_cytoband31_01_ld.sql;
@cyto_l_cytoband31_02_ld.sql;
@cyto_l_cytoband31_03_ld.sql;
@cyto_l_cytoband31_04_ld.sql;

@gene_alias_object31_tv_ld.sql;
@gene_genealias31_ld.sql;

@clone_r_l31_ld.sql;
@location_tv31_ld.sql;

@provenance_ld.sql;
@provenance_gene_ld.sql;
@provenance_nc_ld.sql;
@provenance_snp_ld.sql;

@toggle_constraints.sql;


EXIT;