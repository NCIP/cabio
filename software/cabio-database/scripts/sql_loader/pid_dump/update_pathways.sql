@$LOAD/indexer_new.sql bio_pathways_tv 
@$LOAD/indexer_new.sql pid_entity_accession 
@$LOAD/indexer_new.sql pid_entity_agent 
@$LOAD/indexer_new.sql pid_entity_name 
@$LOAD/indexer_new.sql pid_entity_protein 
@$LOAD/indexer_new.sql pid_entity_sequence 
@$LOAD/indexer_new.sql pid_family_participant 
@$LOAD/indexer_new.sql pid_interaction 
@$LOAD/indexer_new.sql pid_interaction_ec 
@$LOAD/indexer_new.sql pid_interaction_evidence 
@$LOAD/indexer_new.sql pid_participant 
@$LOAD/indexer_new.sql pid_pathway_interaction 
@$LOAD/indexer_new.sql pid_physical_entity 
@$LOAD/indexer_new.sql pid_physical_entity_accession 
@$LOAD/indexer_new.sql pid_physical_entity_name 
@$LOAD/indexer_new.sql protein_compound
@$LOAD/indexer_new.sql biogenes

@$LOAD/constraints.sql bio_pathways_tv 
@$LOAD/constraints.sql pid_entity_accession 
@$LOAD/constraints.sql pid_entity_agent 
@$LOAD/constraints.sql pid_entity_name 
@$LOAD/constraints.sql pid_entity_protein 
@$LOAD/constraints.sql pid_entity_sequence 
@$LOAD/constraints.sql pid_family_participant 
@$LOAD/constraints.sql pid_interaction 
@$LOAD/constraints.sql pid_interaction_ec 
@$LOAD/constraints.sql pid_interaction_evidence 
@$LOAD/constraints.sql pid_participant 
@$LOAD/constraints.sql pid_pathway_interaction 
@$LOAD/constraints.sql pid_physical_entity 
@$LOAD/constraints.sql pid_physical_entity_accession 
@$LOAD/constraints.sql pid_physical_entity_name 
@$LOAD/constraints.sql biogenes 

@$LOAD/constraints/pid_entity_accession.disable.sql
@$LOAD/constraints/bio_pathways_tv.disable.sql
@$LOAD/constraints/pid_entity_agent.disable.sql
@$LOAD/constraints/pid_entity_name.disable.sql
@$LOAD/constraints/pid_entity_protein.disable.sql
@$LOAD/constraints/pid_entity_sequence.disable.sql
@$LOAD/constraints/pid_family_participant.disable.sql
@$LOAD/constraints/pid_interaction.disable.sql
@$LOAD/constraints/biogenes.disable.sql
@$LOAD/constraints/pid_interaction_ec.disable.sql
@$LOAD/constraints/pid_interaction_evidence.disable.sql
@$LOAD/constraints/pid_participant.disable.sql
@$LOAD/constraints/pid_pathway_interaction.disable.sql
@$LOAD/constraints/pid_physical_entity.disable.sql
@$LOAD/constraints/pid_physical_entity_accession.disable.sql

@$LOAD/indexes/pid_entity_accession.drop.sql
@$LOAD/indexes/biogenes.drop.sql
@$LOAD/indexes/pid_entity_agent.drop.sql
@$LOAD/indexes/pid_entity_name.drop.sql
@$LOAD/indexes/pid_entity_protein.drop.sql
@$LOAD/indexes/pid_entity_sequence.drop.sql
@$LOAD/indexes/pid_family_participant.drop.sql
@$LOAD/indexes/pid_interaction.drop.sql
@$LOAD/indexes/pid_interaction_ec.drop.sql
@$LOAD/indexes/pid_interaction_evidence.drop.sql
@$LOAD/indexes/pid_participant.drop.sql
@$LOAD/indexes/pid_pathway_interaction.drop.sql
@$LOAD/indexes/pid_physical_entity.drop.sql
@$LOAD/indexes/pid_physical_entity_accession.drop.sql
@$LOAD/indexes/pid_physical_entity_name.drop.sql

@$LOAD/triggers.sql bio_pathways_tv 
@$LOAD/triggers/bio_pathways_tv.disable.sql 

truncate table pid_entity_accession;
truncate table pid_entity_agent; 
truncate table pid_entity_name; 
truncate table pid_entity_protein; 
truncate table pid_entity_sequence; 
truncate table pid_family_participant; 
truncate table pid_interaction; 
truncate table pid_interaction_ec; 
truncate table pid_interaction_evidence; 
truncate table pid_participant; 
truncate table pid_pathway_interaction; 
truncate table pid_physical_entity ;
truncate table pid_physical_entity_accession; 
truncate table pid_physical_entity_name ;
truncate table PATHWAY_GENE_OBJECT;

VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;
SELECT MAX(pathway_ID) + 1 AS V_MAXROW
  FROM bio_pathways_tv; 

DROP SEQUENCE pathway_ID_SEQ;
CREATE SEQUENCE pathway_ID_SEQ START WITH &V_MAXROW INCREMENT BY 1;

-- create trigger
create or replace trigger pathway_id_trigger  
BEFORE INSERT
ON bio_pathways_tv
FOR EACH ROW
BEGIN
  SELECT pathway_id_seq.NEXTVAL
  INTO :NEW.pathway_id
  FROM DUAL;
END;
/

-- remove all the existing Nature and Reactome Pathways
--delete from bio_pathways_tv b where source  <> 'BioCarta';
commit;

-- set the source to 'BioCarta' for the existing pathways 
--update bio_pathways_tv set source = 'BioCarta';
commit;

-- update the pid_id for the existing biocarta pathways
update bio_pathways_tv set pid_id = (select pathway_id from zstg_pid_pathway a where 'h_'||lower(shortname) = lower(pathway_name) and a.source = 'BioCarta Imported') where source = 'BioCarta';
commit;

-- update the long name for the existing biocarta pathways
update bio_pathways_tv set long_name = (select longname from zstg_pid_pathway a where 'h_'||lower(shortname) = lower(pathway_name) and a.source = 'BioCarta Imported') where source = 'BioCarta' and long_name is null;
commit;


-- insert only the missing biocarta pathways
INSERT INTO bio_pathways_tv(pathway_name, taxon, long_name, source, pid_id, curator, reviewer, pathway_desc) SELECT 'h_'||shortname, 5 as taxon,longname, 'BioCarta', pathway_id, curator_string, reviewer_string, longname  FROM zstg_pid_pathway a where source = 'BioCarta' and shortname in (select distinct trim(lower('h_'||lower(shortname))) from zstg_pid_pathway where source = 'BioCarta Imported'  minus select distinct lower(trim(pathway_name)) from bio_pathways_tv where source = 'BioCarta');
COMMIT;

-- insert reactome and NCI Nature pathways
INSERT INTO bio_pathways_tv(pathway_name, taxon, long_name, source, pid_id, curator, reviewer, pathway_display) SELECT 'h_'||shortname as short_name, 5 as taxon,longname, decode(source, 'Reactome Imported', 'Reactome', 'NCI-Nature Curated', 'NCI-Nature Curated', 'BioCarta Imported', 'BioCarta'), pathway_id, curator_string, reviewer_string, longname FROM zstg_pid_pathway a where source <> 'BioCarta Imported' minus select pathway_name, taxon, long_name, source, pid_id, curator, reviewer, pathway_display from bio_pathways_tv;
COMMIT;

update bio_pathways_tv set pathway_desc = long_name where long_name is not null and pathway_desc is null;
commit;

--- Different types of interactions 
drop sequence interaction_id_seq;
create sequence interaction_id_seq;

-- create trigger
create or replace trigger interaction_id_trigger  
BEFORE INSERT
ON pid_interaction 
FOR EACH ROW
BEGIN
  SELECT interaction_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/

insert into pid_interaction(source, discriminator, pid_interaction_id) select distinct decode(source,'Reactome Imported', 'Reactome', 'NCI-Nature Curated', 'NCI-Nature Curated', 'BioCarta Imported', 'BioCarta'), decode(type,'macroprocess','Macroprocess', 'abstraction', 'PathwayReference','reaction', 'BiochemicalReaction', 'GeneRegulation'), interaction_id from zstg_pid_interaction;
commit;


-- Add macroprocess name for Macroprocess 
update pid_interaction set macro_name=(select distinct macroprocess_name from zstg_pid_macroprocess_type where pid_interaction_id = interaction_id) where discriminator='Macroprocess'; 
commit;

-- load the association table between pathway and pathway_interaction
insert into pid_pathway_interaction(pathway_id, interaction_id) select distinct b.pathway_id, c.id from zstg_pid_pathway_interaction a, bio_pathways_tv b, pid_interaction c where a.pathway_id = b.pid_id and  c.pid_interaction_id = a.interaction_id and c.source = b.source; 
commit;

-- For interactions of type PathwayReference,update the ref_pathway_idupdate pid_interaction set ref_pathway_id = (select distinct pathway_id from pid_pathway_interaction a where a.interaction_id = id) where discriminator = 'PathwayReference';
commit;
  
-- Different types of pathway interaction conditions
drop sequence participant_id_seq;
create sequence participant_id_seq;

-- create trigger
create or replace trigger participant_id_trigger  
BEFORE INSERT
ON pid_participant 
FOR EACH ROW
BEGIN
  SELECT participant_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/

-- inserted rows..but the id does not help find any associated interactions..so what are these conditions for?
--insert into pid_participant(condition_name, discriminator, pid_interaction_id) select distinct conditionname,'Condition' as discriminator, interaction_id from zstg_pid_interactioncondition;


insert into pid_participant(condition_name, discriminator, pid_interaction_id, PID_COMPLEX_COMPONENT_ORDER,INTERACTION_ID) select distinct conditionname, 'Condition', pid_interaction_id, order_of_interactants, pi.id from zstg_pid_interactioncondition c, zstg_pid_interactants i, pid_interaction pi where  role = 'condition' and pi.pid_interaction_id = i.interaction_id and I.physicalentity_id =C.condition_id;

commit;

-- Added on the basis of the May 09 dump
--update pid_participant p set p.CONDITION_NAME = (select distinct conditionname from zstg_pid_interactioncondition x 
--where p.PID_PHYSICALENTITY_ID = x.INTERACTION_ID) where condition_name is null and p.discriminator = 'Condition';
commit;


VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;
SELECT MAX(ID) + 1 AS V_MAXROW FROM evidence; 
drop sequence evidence_id_seq;
create sequence evidence_id_seq start with &v_maxrow;

-- create trigger
create or replace trigger evidence_id_trigger  
BEFORE INSERT
ON evidence 
FOR EACH ROW
BEGIN
  SELECT evidence_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/

--insert into evidence(pubmed_id, sentence) select distinct pubmed_id, 'Pathway publication' from zstg_pid_interactionreference minus select distinct pubmed_id, to_char(dbms_lob.substr(sentence, 1, 4000)) from evidence;

insert into evidence(pubmed_id, sentence)
select distinct pubmed_id, 'Pathway publication' from zstg_pid_reference_pubmed minus select distinct pubmed_id, to_char(dbms_lob.substr(sentence, 50,1)) from evidence;
commit;

SELECT MAX(ID) + 1 AS V_MAXROW
  FROM evidence_code; 
drop sequence evidencecode_id_seq;
create sequence evidencecode_id_seq start with &v_maxrow;

-- create trigger
create or replace trigger evidence_code_id_trigger  
BEFORE INSERT
ON evidence_code 
FOR EACH ROW
BEGIN
  SELECT evidencecode_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/
insert into evidence_code(evidence_code) 
select distinct evidencekind from 
zstg_pid_evidencecode 
minus
select distinct evidence_code from
evidence_code;
commit;
-- NO NEW EVIDENCE CODES are added with the new combined.dat dump

insert into pid_interaction_ec(interaction_id, evidence_code_id) select distinct i.id, e.id from pid_interaction i, evidence_code e, zstg_pid_interactionevidence z, zstg_pid_evidencecode pe where z.interaction_id = i.pid_interaction_id and z.evidence_code=pe.pid_evidencecodeid and pe.evidencekind = e.evidence_code;

commit;

--insert into pid_interaction_evidence(interaction_id, evidence_id) select distinct i.id, e.id from pid_interaction i, evidence e, zstg_pid_interactionreference z where z.interaction_id = i.pid_interaction_id and z.pubmed_id=e.pubmed_id and to_char(substr(e.sentence, 1, 4000))='Pathway publication';


insert into pid_interaction_evidence(interaction_id, evidence_id) select distinct i.id, e.id from pid_interaction i, evidence e, zstg_pid_interactionreference z, zstg_pid_reference_pubmed z2 where z.interaction_id = i.pid_interaction_id and z.pubmed_id= z2.reference_id and z2.pubmed_id = e.pubmed_id and to_char(substr(e.sentence, 1, 4000))='Pathway publication';

commit;

-- load into pid_entityName and pid_entityAccession
drop sequence pid_entityname_id;
create sequence pid_entityname_id;

insert into pid_entity_name(id, pid_physicalentity_id, name) select pid_entityname_id.nextval, physicalentity_id, name from zstg_pid_entityname; 
commit;

delete from pid_entity_name where name is null;
commit;

delete from pid_entity_name where rowid NOT in (select min(rowid) from pid_entity_name group by name, pid_physicalentity_id);
commit;

drop sequence pid_entityaccession_id;
create sequence pid_entityaccession_id;

insert into pid_entity_accession(id, pid_physicalentity_id, accession, database) select pid_entityaccession_id.nextval, physicalentity_id, accession, database from zstg_pid_entityaccession; 
commit;

delete from pid_entity_accession where accession is null;
commit;

delete from pid_entity_accession where rowid NOT in (select min(rowid) from pid_entity_accession m group by m.ACCESSION, m.DATABASE);
commit;

drop sequence pid_pe_id;
create sequence pid_pe_id;

insert into pid_physical_entity(id, pid_physicalentity_id, discriminator) select pid_pe_id.nextval, physicalentity_id, decode(type, 'protein', 'ProteinEntity', 'complex', 'ComplexEntity', 'smallmolecule','SmallMoleculeEntity', 'rna','RNAEntity','proteinsubunit', 'ProteinSubunit') from zstg_pid_physicalentity;
commit;

-- delete those where discriminator is null
delete from pid_physical_entity where discriminator is null;
commit;


-- insert the family data
-- Per model change, this discriminator should not be updated
--update pid_physical_entity p set p.discriminator = 'PhysicalEntityFamily' where p.pid_physicalentity_id in (select distinct family_id from zstg_pid_family_member);
--commit;


-- Association between PE and EA
insert into pid_physical_entity_accession(physical_entity_id, entity_accession_id) select a.id, b.id from pid_physical_entity a, pid_entity_accession b where a.pid_physicalentity_id = b.pid_physicalentity_id;
commit;

-- Association between PE and EN
insert into pid_physical_entity_name(physical_entity_id, entity_name_id) select a.id, b.id from pid_physical_entity a, pid_entity_name b where a.pid_physicalentity_id = b.pid_physicalentity_id;
commit;


-- Association to ProteinSubUnit
update pid_physical_entity a set a.protein_entity_id = (select distinct b.id from pid_physical_entity b, zstg_pid_proteinsubunit c where b.pid_physicalentity_id = c.whole_protein_id and a.pid_physicalentity_id = c.subunit_protein_id)  where discriminator = 'ProteinSubunit'; 
commit;

-- Set ProteinSubUnit start and stop
update pid_physical_entity a set (a.prot_subunit_start, a.prot_subunit_stop) = (select distinct start_loc, stop_loc from zstg_pid_proteinsubunit b where a.pid_physicalentity_id = b.subunit_protein_id) where discriminator='ProteinSubunit';
commit;

-- 
drop sequence phys_part_id;
create sequence phys_part_id;

-- inserting pathway conditions here also
-- why?
drop sequence phys_part_id;
create sequence phys_part_id;

-- inserting pathway conditions here also
-- why?
insert into pid_participant(id, discriminator, pid_interaction_id, pid_physicalentity_id, pid_complex_component_order) select phys_part_id.nextval, decode(role, 'input', 'Input', 'output', 'Output', 'positivecontrol', 'PositiveControl', 'negativecontrol', 'NegativeControl' ),interaction_id, physicalentity_id, order_of_interactants from zstg_pid_interactants where role <> 'condition';
commit;

update zstg_pid_complex_component z set z.complex_id = (select x.id from pid_physical_entity x where z.pid_complex_id = x.PID_PHYSICALENTITY_ID);
commit;

update zstg_pid_complex_component z set z.component_id = (select x.id from pid_physical_entity x where z.pid_component_id = x.PID_PHYSICALENTITY_ID);
commit;

insert into pid_participant(id, discriminator, pid_complex_entity_id, pid_complex_component_id, pid_complex_component_order, complex_entity_id, pid_physicalentity_id, physical_entity_id) select phys_part_id.nextval, 'ComplexComponent', pid_complex_id, pid_component_id, order_of_complex, complex_id, pid_component_id,component_id from zstg_pid_complex_component;
commit;


-- Insert all the family members into PID_Participant
insert into pid_participant(id, discriminator, pid_family_id, pid_member_id, pid_physicalentity_id) select phys_part_id.nextval, 'FamilyMember', family_id, member_id, member_id from zstg_pid_family_member;
commit;


--insert into pid_family_participant
insert into pid_family_participant (participant_id, physical_entity_id) select distinct b.ID, a.ID from pid_physical_entity a, pid_participant b, zstg_pid_family_member c where c.FAMILY_ID = b.PID_FAMILY_ID and b.PID_FAMILY_ID = a.PID_PHYSICALENTITY_ID and c.MEMBER_ID =  b.PID_MEMBER_ID;
commit;

-- association between physicalparticipant and interaction
update pid_participant m set interaction_id = (select id from pid_interaction p where p.pid_interaction_id = m.pid_interaction_id);
commit;

-- association between physical participant and physical entity
update pid_participant p set p.physical_entity_id=(select b.id from pid_physical_entity b where p.pid_physicalentity_id = b.pid_physicalentity_id); 
commit;

-- add location, posttranslationalmodification and activitystate for complex components
update pid_participant p set p.LOCATION = 
(select location from zstg_pid_intr_partpant_loc z where 
z.INTERACTION_ID = p.pid_interaction_id and 
z.ORDER_OF_INTERACTION = p.pid_complex_component_order and 
z.PID_PHYSICALENTITY_ID = p.PID_PHYSICALENTITY_ID);
commit;


-- add ptm
update pid_participant p set p.PTM = 
(select z.ptm from zstg_pid_intr_partcpant_ptm z where 
z.INTERACTION_ID = p.pid_interaction_id and 
z.ORDER_OF_INTERACTION = p.pid_complex_component_order and 
z.PID_PHYSICALENTITY_ID = p.PID_PHYSICALENTITY_ID);
commit;

-- add activity state
update pid_participant p set p.ACTIVITY_STATE = 
(select z.ACTIVITY_STATE from zstg_pid_intr_partcpant_actst z where 
z.INTERACTION_ID = p.pid_interaction_id and 
z.ORDER_OF_INTERACTION = p.pid_complex_component_order and 
z.PID_PHYSICALENTITY_ID = p.PID_PHYSICALENTITY_ID);
commit;


delete from zstg_pid_comp_partcipant_ptm where rowid NOT in (select min(rowid) from zstg_pid_comp_partcipant_ptm group by complex_id, order_of_complex, ptm);
commit; 

update pid_participant p set p.PTM = (select min(ptm) from zstg_pid_comp_partcipant_ptm x where p.COMPLEX_ENTITY_ID = x.COMPLEX_ID and p.PID_COMPLEX_COMPONENT_ID = x.ORDER_OF_COMPLEX) where p.PTM is null and p.DISCRIMINATOR = 'ComplexComponent';
commit;

update pid_participant p set p.ACTIVITY_STATE = (select min(x.ACTIVITY_STATE) from zstg_pid_comp_partcipant_actst x where p.COMPLEX_ENTITY_ID = x.COMPLEX_ID and p.PID_COMPLEX_COMPONENT_ID = x.ORDER_OF_COMPLEX) where p.ACTIVITY_STATE is null and p.DISCRIMINATOR = 'ComplexComponent';
commit;

update pid_participant p set p.LOCATION = (select min(x.LOCATION) from zstg_pid_compl_participant_loc x where p.COMPLEX_ENTITY_ID = x.COMPLEX_COMPONENT_ID and p.PID_COMPLEX_COMPONENT_ID = x.ORDER_OF_COMPLEX) where p.LOCATION is null and p.DISCRIMINATOR = 'ComplexComponent';
commit;

delete from zstg_pid_fmly_prtpnt_ptm where rowid NOT in (select min(rowid) from zstg_pid_fmly_prtpnt_ptm group by family_id, member_id, ptm);
commit;

update pid_participant p set p.PTM = (select min(ptm) from zstg_pid_fmly_prtpnt_ptm x where p.PID_FAMILY_ID = x.FAMILY_ID and p.PID_MEMBER_ID = x.MEMBER_ID) where p.PTM is null and p.DISCRIMINATOR = 'FamilyMember';
commit;

delete from zstg_pid_fmly_prtpnt_actst where rowid NOT in (select min(rowid) from zstg_pid_fmly_prtpnt_actst group by family_id, member_id, activity_state);
commit;

update pid_participant p set p.ACTIVITY_STATE = (select min(x.ACTIVITY_STATE) from zstg_pid_fmly_prtpnt_actst x where p.PID_FAMILY_ID = x.FAMILY_ID and p.PID_MEMBER_ID = x.MEMBER_ID) where p.ACTIVITY_STATE is null and p.DISCRIMINATOR = 'FamilyMember';
commit;

update pid_participant p set p.PID_INTERACTION_ID =
(select min(interaction_id) from zstg_pid_interactants 
z where z.PHYSICALENTITY_ID = p.PID_MEMBER_ID) 
where discriminator = 'FamilyMember' and p.PID_INTERACTION_ID is null;


-- association between ProteinEntity and Protein
insert into pid_entity_protein(physical_entity_id, protein_id) select distinct p.ID, n.PROTEIN_ID from pid_physical_entity p, pid_entity_accession a, new_protein n where p.PID_PHYSICALENTITY_ID = a.PID_PHYSICALENTITY_ID and p.DISCRIMINATOR = 'ProteinEntity'  and lower(trim(a.ACCESSION)) = lower(trim(n.PRIMARY_ACCESSION)) and a.DATABASE = 'UniProt' union select pe.ID, gp.PROTEIN_ID from pid_entity_accession p, database_cross_reference d, gene_protein_tv gp, pid_physical_entity pe where p.DATABASE = 'EntrezGene' and p.ACCESSION = d.CROSS_REFERENCE_ID and d.GENE_ID = gp.GENE_ID  and p.PID_PHYSICALENTITY_ID = pe.PID_PHYSICALENTITY_ID and pe.discriminator='ProteinEntity' union   select distinct pe.ID, gp.PROTEIN_ID  from pid_entity_accession p, database_cross_reference d, pid_physical_entity pe, gene_protein_tv gp, gene_Tv g where database = 'EnzymeConsortium' and 'EC:'||p.ACCESSION = d.CROSS_REFERENCE_ID and d.GENE_ID = gp.GENE_ID and gp.GENE_ID = g.GENE_ID and g.TAXON_ID = 5 and pe.DISCRIMINATOR = 'ProteinEntity' and  p.PID_PHYSICALENTITY_ID = pe.PID_PHYSICALENTITY_ID;

 
commit; 

-- association between SmallMoleculeEntity and Agent
insert into pid_entity_agent(physical_entity_id, agent_id) select distinct p.ID, g.AGENT_ID from pid_physical_entity p, pid_entity_name a , agent g where p.PID_PHYSICALENTITY_ID = a.PID_PHYSICALENTITY_ID and p.DISCRIMINATOR = 'SmallMoleculeEntity' and lower(trim(a.NAME)) = lower(trim(g.AGENT_NAME));
commit;


-- See if one can add agents on the basis of Unigene cluster number
-- and on the basis of Locus link id
insert into pid_entity_agent(physical_entity_id, agent_id) select distinct p.id, gfa.agent_id from zstg_pid_geneentity z, pid_physical_entity p, gene_tv g, gene_function_association gfa where z.PID_PE_ID = p.PID_PHYSICALENTITY_ID and p.DISCRIMINATOR = 'SmallMoleculeEntity' and substr(z.UNIGENE_CLUSTER,instr(z.unigene_cluster,'.')+1) = g.CLUSTER_ID and g.TAXON_ID = 5 and g.GENE_ID = gfa.GENE_ID union select distinct p.id, gfa.agent_id from zstg_pid_geneentity z, pid_physical_entity p, database_cross_reference d, gene_function_association gfa  where z.PID_PE_ID = p.PID_PHYSICALENTITY_ID and p.DISCRIMINATOR = 'SmallMoleculeEntity' and z.LOCUSLINK = d.CROSS_REFERENCE_ID and d.SOURCE_TYPE = 'Entrez Gene' and d.GENE_ID = gfa.GENE_ID;

commit;

-- association between RNAEntity and NucleicAcidSequence
insert into pid_entity_sequence(physical_entity_id, nucleic_acid_sequence_id) select p.ID, n.ID from pid_physical_entity p, pid_entity_accession a, nucleic_acid_sequence n where p.discriminator = 'RNAEntity' and p.PID_PHYSICALENTITY_ID = a.PID_PHYSICALENTITY_ID and n.ACCESSION_NUMBER=a.ACCESSION union select p.id, n.id from pid_entity_name pen, pid_physical_entity p, nucleic_acid_sequence n where pen.PID_PHYSICALENTITY_ID in (select distinct pid_physicalentity_id from pid_physical_entity where discriminator = 'RNAEntity') and pen.NAME = n.DESCRIPTION and pen.pid_physicalentity_id = p.pid_physicalentity_id union select pe.id, gs.gene_sequence_id from zstg_pid_geneentity p, gene_tv g, gene_nucleic_acid_sequence gs, pid_physical_entity pe where p.PID_PE_ID = pe.PID_PHYSICALENTITY_ID and substr(p.UNIGENE_CLUSTER, instr(p.Unigene_cluster,'.')+1) = g.CLUSTER_ID and g.TAXON_ID = 5 and g.GENE_ID = gs.GENE_ID and pe.DISCRIMINATOR = 'RNAEntity';

commit;


-- try on the basis of Entrez Gene Id and Uniprot 
insert into pid_entity_sequence(physical_entity_id, nucleic_acid_sequence_id) select distinct p.ID, GS.GENE_SEQUENCE_ID from pid_physical_entity p, pid_entity_accession a, new_protein n, gene_protein_tv gp, gene_nucleic_acid_sequence gs where p.PID_PHYSICALENTITY_ID = a.PID_PHYSICALENTITY_ID and p.DISCRIMINATOR = 'RNAEntity'  and lower(trim(a.ACCESSION)) = lower(trim(n.PRIMARY_ACCESSION)) and a.DATABASE = 'UniProt' and n.PROTEIN_ID = gp.PROTEIN_ID and gp.PROTEIN_ID = gs.GENE_SEQUENCE_ID union select pe.ID, gn.GENE_SEQUENCE_ID from pid_entity_accession p, database_cross_reference d, gene_nucleic_acid_sequence gn, pid_physical_entity pe where p.DATABASE = 'EntrezGene' and p.ACCESSION = d.CROSS_REFERENCE_ID and d.GENE_ID = gn.GENE_ID  and p.PID_PHYSICALENTITY_ID = pe.PID_PHYSICALENTITY_ID and pe.discriminator='RNAEntity';
commit;


-- try to populate the association between Pathway and Gene
update pid_entity_protein p set p.gene_id = (select min(gt.gene_id) from gene_protein_tv g, gene_tv gt where p.protein_id = g.protein_id and g.gene_id = gt.gene_id and gt.taxon_id = 5 and gt.hugo_symbol is not null group by g.protein_id);
commit;


-- delete associations from gene_pathway and from biogenes
delete from gene_pathway where bc_id in (select distinct to_char(b.long_name) from bio_pathways_tv b where source <> 'BioCarta');
commit;

delete from biogenes where bc_id in (select distinct to_char(b.long_name) from bio_pathways_tv b where source <> 'BioCarta');
commit;

-- Now populate the association between Gene and Pathway with this Id
-- insert into biogenes(organism, bc_id, gene_id) select distinct to_char(b.TAXON), to_char(b.LONG_NAME), pe.gene_id from pid_participant p, pid_entity_protein pe, pid_pathway_interaction pi, bio_pathways_tv b  where pe.PHYSICAL_ENTITY_ID = p.PHYSICAL_ENTITY_ID and pe.GENE_ID is not null and pi.INTERACTION_ID = p.interaction_id and pi.PATHWAY_ID = b.PATHWAY_ID and b.SOURCE <> 'BioCarta' minus 
select distinct organism, bc_id, gene_id from biogenes;
-- commit;


-- insert into gene_pathway(bc_id, pathway_id) select distinct to_char(b.LONG_NAME),b.PATHWAY_ID from pid_participant p, pid_entity_protein pe, pid_pathway_interaction pi, bio_pathways_tv b  where pe.PHYSICAL_ENTITY_ID = p.PHYSICAL_ENTITY_ID and pe.GENE_ID is not null and pi.INTERACTION_ID = p.interaction_id and pi.PATHWAY_ID = b.PATHWAY_ID and b.SOURCE <> 'BioCarta' minus 
select distinct bc_id, pathway_id from gene_pathway;

-- commit;

insert into PATHWAY_GENE_OBJECT(GENE_ID, PATHWAY_ID)
select unique GPT.GENE_ID, BPT.PATHWAY_ID 
from ZSTG_PROTEIN_PATHWAY_FROM_PID PTA, 
     NEW_PROTEIN NP, 
	 GENE_PROTEIN_TV GPT, 
	 BIO_PATHWAYS_TV BPT 
where PTA.PROTEIN_ID = NP.PRIMARY_ACCESSION 
and NP.PROTEIN_ID = GPT.PROTEIN_ID 
AND PTA.SHORT_NAME = SUBSTR(BPT.PATHWAY_NAME, 3) 
union 
SELECT unique bg.gene_id, gp.pathway_id FROM 
GENE_PATHWAY gp, BIOGENES bg 
WHERE gp.bc_id = bg.bc_id;

COMMIT;


-- In the above, there are currently 41 Pathways where more than one gene id matches, currently picking only the smallest of it


@$LOAD/indexes/pid_entity_accession.cols.sql
@$LOAD/indexes/bio_pathways_tv.cols.sql
@$LOAD/indexes/pid_entity_agent.cols.sql
@$LOAD/indexes/pid_entity_name.cols.sql
@$LOAD/indexes/pid_entity_protein.cols.sql
@$LOAD/indexes/pid_entity_sequence.cols.sql
@$LOAD/indexes/pid_family_participant.cols.sql
@$LOAD/indexes/pid_interaction.cols.sql
@$LOAD/indexes/pid_interaction_ec.cols.sql
@$LOAD/indexes/pid_interaction_evidence.cols.sql
@$LOAD/indexes/pid_participant.cols.sql
@$LOAD/indexes/pid_pathway_interaction.cols.sql
@$LOAD/indexes/pid_physical_entity.cols.sql
@$LOAD/indexes/pid_physical_entity_accession.cols.sql
@$LOAD/indexes/pid_physical_entity_name.cols.sql

@$LOAD/indexes/pid_entity_accession.lower.sql
@$LOAD/indexes/bio_pathways_tv.lower.sql
@$LOAD/indexes/pid_entity_agent.lower.sql
@$LOAD/indexes/pid_entity_name.lower.sql
@$LOAD/indexes/pid_entity_protein.lower.sql
@$LOAD/indexes/pid_entity_sequence.lower.sql
@$LOAD/indexes/pid_family_participant.lower.sql
@$LOAD/indexes/pid_interaction.lower.sql
@$LOAD/indexes/pid_interaction_ec.lower.sql
@$LOAD/indexes/pid_interaction_evidence.lower.sql
@$LOAD/indexes/pid_participant.lower.sql
@$LOAD/indexes/pid_pathway_interaction.lower.sql
@$LOAD/indexes/pid_physical_entity.lower.sql
@$LOAD/indexes/pid_physical_entity_accession.lower.sql
@$LOAD/indexes/pid_physical_entity_name.lower.sql

@$LOAD/constraints/pid_entity_accession.enable.sql
@$LOAD/constraints/bio_pathways_tv.enable.sql
@$LOAD/constraints/pid_entity_agent.enable.sql
@$LOAD/constraints/pid_entity_name.enable.sql
@$LOAD/constraints/pid_entity_protein.enable.sql
@$LOAD/constraints/pid_entity_sequence.enable.sql
@$LOAD/constraints/pid_family_participant.enable.sql
@$LOAD/constraints/pid_interaction.enable.sql
@$LOAD/constraints/pid_interaction_ec.enable.sql
@$LOAD/constraints/pid_interaction_evidence.enable.sql
@$LOAD/constraints/pid_participant.enable.sql
@$LOAD/constraints/pid_pathway_interaction.enable.sql
@$LOAD/constraints/pid_physical_entity.enable.sql
@$LOAD/constraints/pid_physical_entity_accession.enable.sql
@$LOAD/constraints/pid_physical_entity_name.enable.sql

EXIT;
  
