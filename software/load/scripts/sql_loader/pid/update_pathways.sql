/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

@$LOAD/indexer_new.sql bio_pathways_tv 
@$LOAD/indexer_new.sql pathway_interaction 
@$LOAD/indexer_new.sql pathway_pathway_interaction 
@$LOAD/indexer_new.sql pathway_participant
@$LOAD/indexer_new.sql interaction_pathway_participant
@$LOAD/indexer_new.sql interaction_evidence
@$LOAD/indexer_new.sql interaction_evidence_code
@$LOAD/indexer_new.sql pathway_evidence
@$LOAD/indexer_new.sql protein_complex
@$LOAD/indexer_new.sql protein_compound

@$LOAD/triggers.sql bio_pathways_tv 
@$LOAD/constraints.sql bio_pathways_tv 
@$LOAD/constraints/bio_pathways_tv.disable.sql 

@$LOAD/indexes/bio_pathways_tv.drop.sql 
@$LOAD/indexes/pathway_interaction.drop.sql 
@$LOAD/indexes/pathway_pathway_interaction.drop.sql 
@$LOAD/indexes/pathway_participant.drop.sql 
@$LOAD/indexes/interaction_pathway_participant.drop.sql 
@$LOAD/indexes/interaction_evidence.drop.sql 
@$LOAD/indexes/interaction_evidence_code.drop.sql 
@$LOAD/indexes/pathway_evidence.drop.sql 
@$LOAD/indexes/protein_complex.drop.sql 
@$LOAD/indexes/protein_compound.drop.sql 

--truncate table bio_pathways_tv;
truncate table pathway_interaction;
truncate table pathway_pathway_interaction;
truncate table pathway_participant;
truncate table interaction_pathway_participant;
truncate table interaction_evidence;
truncate table interaction_evidence_code;
truncate table pathway_evidence;
truncate table protein_complex;
truncate table protein_compound;


-- reload bio_pathways_tv
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

-- enable trigger 
--@$LOAD/triggers/bio_pathways_tv.enable.sql 

-- set the source to 'BioCarta' for the existing pathways 
update bio_pathways_tv set source = 'BioCarta';
commit;

-- update the pid_id for the existing biocarta pathways
update bio_pathways_tv set pid_id = (select pathway_id from zstg_pathways a where pathway_name = 'h_'||pathway_name) where source = 'BioCarta';
commit;

-- insert only the missing biocarta pathways
--INSERT INTO bio_pathways_tv(pathway_name, taxon, long_name, source, pid_id) SELECT 'h_'||shortname, 5 as taxon,longname, 'Bio Carta', pathway_id FROM zstg_pathways a where source_id in (2,3) and shortname in (select distinct trim(lower('h_'||shortname)) from zstg_pathways where source_id in (2,3) minus select distinct lower(trim(pathway_name)) from bio_pathways_tv where source = 'BioCarta');
COMMIT;

-- insert reactome and NCI Nature pathways
--INSERT INTO bio_pathways_tv(pathway_name, taxon, long_name, source, pid_id) SELECT 'h_'||shortname, 5 as taxon,longname, decode(source_id, 7, 'Reactome', 5, 'NCI Nature'), pathway_id FROM zstg_pathways a where source_id in (5,7);
COMMIT;
--- Different types of interactions 
drop sequence interaction_id_seq;
create sequence interaction_id_seq;

-- create trigger
create or replace trigger interaction_id_trigger  
BEFORE INSERT
ON pathway_interaction 
FOR EACH ROW
BEGIN
  SELECT interaction_id_seq.NEXTVAL
  INTO :NEW.interaction_id
  FROM DUAL;
END;
/

truncate table pathway_interaction; 
insert into pathway_interaction(description, discriminator, pid_id) select distinct interaction_type, 'Reaction' as discriminator, interaction_id from zstg_interactions;
commit;
-- No way of finding out which of these qualify as reactions, macroprocesses or abstractions 

-- load the association table between pathway and pathway_interaction
truncate table pathway_pathway_interaction;
insert into pathway_pathway_interaction(pathway_id, pathway_interaction_id)
select distinct b.pathway_id, c.interaction_id from zstg_pathwaycomponents a, bio_pathways_tv b, pathway_interaction c where a.pathway_id = b.pid_id and  c.pid_id = a.interaction_id and decode(a.source_id, 5, 'NCI Nature', 7, 'Reactome', 3, 'BioCarta', 2, 'BioCarta') = b.source; 
commit;

-- Different types of pathway interaction conditions
-- and different types of participants - input / output / agent / inhibitor
drop sequence participant_id_seq;
create sequence participant_id_seq;

-- create trigger
create or replace trigger participant_id_trigger  
BEFORE INSERT
ON pathway_participant 
FOR EACH ROW
BEGIN
  SELECT participant_id_seq.NEXTVAL
  INTO :NEW.participant_id
  FROM DUAL;
END;
/

truncate table pathway_participant; 
insert into pathway_participant(condition, discriminator, pid_id) select distinct condition, 'PathwayInteractionCondition' as discriminator, interaction_id from zstg_interactioncondition;
commit;


insert into pathway_participant(label, value, discriminator, pid_id) select distinct label_type, value, decode(role_type, 'input', 'PathwayInteractionInput', 'output', 'PathwayInteractionOutput', 'agent', 'PathwayInteractionPositiveControl', 'inhibitor', 'PathwayInteractionNegativeControl') as discriminator, interaction_id from zstg_interactioncomponentlabel;
commit;

-- Load the association between interaction and interaction condition 
truncate table interaction_pathwy_participant;
insert into interaction_pathwy_participant(interaction_id, participant_id) select distinct i.interaction_id, p.participant_id from pathway_interaction i, pathway_participant p, zstg_interactioncondition c where c.interaction_id = i.pid_id(+) and c.condition = p.condition and p.discriminator='PathwayInteractionCondition';  
commit;

--insert into interaction_pathwy_participant(interaction_id, participant_id) select distinct i.interaction_id, p.participant_id from pathway_interaction i, pathway_participant p, zstg_interactioncomponentlabel cl where cl.interaction_id = i.pid_id(+) and cl.label_type = p.label and p.discriminator <>'PathwayInteractionCondition';  
--commit;

VAR V_MAXROW NUMBER;
COLUMN V_MAXROW NEW_VALUE V_MAXROW;
SELECT MAX(ID) + 1 AS V_MAXROW
  FROM evidence; 
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

insert into evidence(pubmed_id, sentence) select distinct pmid, 'N.A.' from zstg_interactionreference;
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
select distinct evidencecode from 
zstg_interactionevidence 
minus
select distinct evidence_code from
evidence_code;
commit;

-- Load the association between pathway interaction and evidence code
truncate table interaction_evidence_code;
insert into interaction_evidence_code(interaction_id, evidence_code_id) select distinct i.interaction_id, e.id from pathway_interaction i, evidence_code e, zstg_interactionevidence c where c.interaction_id = i.pid_id and c.evidencecode = e.evidence_code; 
commit;

-- Load the association between pathway interaction and evidence
truncate table interaction_evidence;
insert into interaction_evidence(interaction_id, evidence_id) select distinct i.interaction_id, e.id from pathway_interaction i, evidence e, zstg_interactionreference c where c.interaction_id = i.pid_id and c.pmid = e.pubmed_id and e.negation_status is null and e.cellline_status is null and e.sentence_status is null;
commit;

-- Load the association between pathway and evidence
truncate table pathway_evidence;
insert into pathway_evidence(pathway_id, evidence_id) select distinct p.pathway_id, e.id from bio_pathways_tv p, evidence e, zstg_pathwaycomponents i, zstg_interactionreference r where r.interaction_id = i.interaction_id and i.pathway_id = p.pid_id and r.pmid = e.pubmed_id and e.sentence_status is null and e.cellline_status is null;

drop sequence compound_id_seq;
create sequence compound_id_seq;

-- create trigger
create or replace trigger protein_compound_id_trigger  
BEFORE INSERT
ON protein_compound 
FOR EACH ROW
BEGIN
  SELECT compound_id_seq.NEXTVAL
  INTO :NEW.compound_id
  FROM DUAL;
END;
/
-- Load compounds and complexes
truncate table protein_compound;
insert into protein_compound(value) select distinct value from zstg_moleculenames where mtype='compound';
commit;
 
truncate table protein_complex;
drop sequence complex_id_seq;
create sequence complex_id_seq;

-- create trigger
create or replace trigger protein_complex_id_trigger  
BEFORE INSERT
ON protein_complex 
FOR EACH ROW
BEGIN
  SELECT complex_id_seq.NEXTVAL
  INTO :NEW.complex_id
  FROM DUAL;
END;
/

insert into protein_complex(value, pid_id) select distinct value, molecule_id from zstg_moleculenames where mtype='complex';
commit;

drop sequence post_trans_mod_id_seq;
create sequence post_trans_mod_id_seq;

-- create trigger
create or replace trigger post_trans_mod_id_trigger  
BEFORE INSERT
ON post_translational_modification 
FOR EACH ROW
BEGIN
  SELECT post_trans_mod_id_seq.NEXTVAL
  INTO :NEW.id
  FROM DUAL;
END;
/

insert into post_translational_modification(position, amino_acid, modification) select distinct position, aa, modification from zstg_moleculecompptmterms;
commit;

@$LOAD/indexes/bio_pathways_tv.cols.sql 
@$LOAD/indexes/pathway_interaction.cols.sql 
@$LOAD/indexes/pathway_pathway_interaction.cols.sql 
@$LOAD/indexes/pathway_participant.cols.sql 
@$LOAD/indexes/interaction_pathway_participant.cols.sql 
@$LOAD/indexes/interaction_evidence.cols.sql 
@$LOAD/indexes/interaction_evidence_code.cols.sql 
@$LOAD/indexes/pathway_evidence.cols.sql 
@$LOAD/indexes/protein_complex.cols.sql 
  
@$LOAD/indexes/bio_pathways_tv.lower.sql 
@$LOAD/indexes/pathway_interaction.lower.sql 
@$LOAD/indexes/pathway_pathway_interaction.lower.sql 
@$LOAD/indexes/pathway_participant.lower.sql 
@$LOAD/indexes/interaction_pathway_participant.lower.sql 
@$LOAD/indexes/interaction_evidence.lower.sql 
@$LOAD/indexes/interaction_evidence_code.lower.sql 
@$LOAD/indexes/pathway_evidence.lower.sql 
@$LOAD/indexes/protein_complex.lower.sql 
COMMIT;
EXIT;
  
