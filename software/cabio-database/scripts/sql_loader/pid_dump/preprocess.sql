/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

truncate table zstg_pid_dump;
truncate table ZSTG_PID_INTERACTIONREFERENCE;
truncate table ZSTG_PID_ENTITYNAME;
truncate table ZSTG_PID_COMPL_PARTICIPANT_LOC;
truncate table ZSTG_PID_COMP_PARTCIPANT_PTM;
truncate table ZSTG_PID_INTR_PARTPANT_LOC;
truncate table ZSTG_PID_PHYSICALENTITY;
truncate table ZSTG_PID_PATHWAY_INTERACTION;
truncate table ZSTG_PID_FMLY_PRTPNT_ACTST;
truncate table ZSTG_PID_PATHWAYREFERENCE;
truncate table ZSTG_PID_PROTEINSUBUNIT;
truncate table ZSTG_PID_INTERACTANTS;
truncate table ZSTG_PID_INTR_PARTCPANT_ACTST;
truncate table ZSTG_PID_DUMP;
truncate table ZSTG_PID_MACROPROCESS_TYPE;
truncate table ZSTG_PID_FAMILY_MEMBER;
truncate table ZSTG_PID_COMP_PARTCIPANT_ACTST;
truncate table ZSTG_PID_INTR_PARTCPANT_PTM;
truncate table ZSTG_PID_FMLY_PRTPNT_PTM;
truncate table ZSTG_PID_INTERACTIONEVIDENCE;
truncate table ZSTG_PID_ENTITYACCESSION;
truncate table ZSTG_PID_INTERACTION;
truncate table ZSTG_PID_PATHWAY;
truncate table ZSTG_PID_INTERACTIONCONDITION;
truncate table ZSTG_PID_COMPLEX_COMPONENT;
truncate table zstg_pid_evidencecode;
truncate table zstg_pid_geneentity;
truncate table ZSTG_PID_reference_pubmed;
truncate table ZSTG_PROTEIN_PATHWAY_FROM_PID;

@$LOAD/indexer_new.sql ZSTG_PID_INTERACTIONREFERENCE
@$LOAD/indexer_new.sql ZSTG_PID_ENTITYNAME
@$LOAD/indexer_new.sql ZSTG_PID_COMPL_PARTICIPANT_LOC
@$LOAD/indexer_new.sql ZSTG_PID_COMP_PARTCIPANT_PTM
@$LOAD/indexer_new.sql ZSTG_PID_INTR_PARTPANT_LOC
@$LOAD/indexer_new.sql ZSTG_PID_PHYSICALENTITY
@$LOAD/indexer_new.sql ZSTG_PID_PATHWAY_INTERACTION
@$LOAD/indexer_new.sql ZSTG_PID_FMLY_PRTPNT_ACTST
@$LOAD/indexer_new.sql ZSTG_PID_PATHWAYREFERENCE
@$LOAD/indexer_new.sql ZSTG_PID_PROTEINSUBUNIT
@$LOAD/indexer_new.sql ZSTG_PID_INTERACTANTS
@$LOAD/indexer_new.sql ZSTG_PID_INTR_PARTCPANT_ACTST
@$LOAD/indexer_new.sql ZSTG_PID_DUMP
@$LOAD/indexer_new.sql ZSTG_PID_MACROPROCESS_TYPE
@$LOAD/indexer_new.sql ZSTG_PID_FAMILY_MEMBER
@$LOAD/indexer_new.sql ZSTG_PID_COMP_PARTCIPANT_ACTST
@$LOAD/indexer_new.sql ZSTG_PID_INTR_PARTCPANT_PTM
@$LOAD/indexer_new.sql ZSTG_PID_FMLY_PRTPNT_PTM
@$LOAD/indexer_new.sql ZSTG_PID_INTERACTIONEVIDENCE
@$LOAD/indexer_new.sql ZSTG_PID_ENTITYACCESSION
@$LOAD/indexer_new.sql ZSTG_PID_INTERACTION
@$LOAD/indexer_new.sql ZSTG_PID_PATHWAY
@$LOAD/indexer_new.sql ZSTG_PID_INTERACTIONCONDITION
@$LOAD/indexer_new.sql ZSTG_PID_COMPLEX_COMPONENT

@$LOAD/constraints.sql ZSTG_PID_INTERACTIONREFERENCE
@$LOAD/constraints.sql ZSTG_PID_ENTITYNAME
@$LOAD/constraints.sql ZSTG_PID_COMPL_PARTICIPANT_LOC
@$LOAD/constraints.sql ZSTG_PID_COMP_PARTCIPANT_PTM
@$LOAD/constraints.sql ZSTG_PID_INTR_PARTPANT_LOC
@$LOAD/constraints.sql ZSTG_PID_PHYSICALENTITY
@$LOAD/constraints.sql ZSTG_PID_PATHWAY_INTERACTION
@$LOAD/constraints.sql ZSTG_PID_FMLY_PRTPNT_ACTST
@$LOAD/constraints.sql ZSTG_PID_PATHWAYREFERENCE
@$LOAD/constraints.sql ZSTG_PID_PROTEINSUBUNIT
@$LOAD/constraints.sql ZSTG_PID_INTERACTANTS
@$LOAD/constraints.sql ZSTG_PID_INTR_PARTCPANT_ACTST
@$LOAD/constraints.sql ZSTG_PID_DUMP
@$LOAD/constraints.sql ZSTG_PID_MACROPROCESS_TYPE
@$LOAD/constraints.sql ZSTG_PID_FAMILY_MEMBER
@$LOAD/constraints.sql ZSTG_PID_COMP_PARTCIPANT_ACTST
@$LOAD/constraints.sql ZSTG_PID_INTR_PARTCPANT_PTM
@$LOAD/constraints.sql ZSTG_PID_FMLY_PRTPNT_PTM
@$LOAD/constraints.sql ZSTG_PID_INTERACTIONEVIDENCE
@$LOAD/constraints.sql ZSTG_PID_ENTITYACCESSION
@$LOAD/constraints.sql ZSTG_PID_INTERACTION
@$LOAD/constraints.sql ZSTG_PID_PATHWAY
@$LOAD/constraints.sql ZSTG_PID_INTERACTIONCONDITION
@$LOAD/constraints.sql ZSTG_PID_COMPLEX_COMPONENT

@$LOAD/triggers.sql ZSTG_PID_INTERACTIONREFERENCE
@$LOAD/triggers.sql ZSTG_PID_ENTITYNAME
@$LOAD/triggers.sql ZSTG_PID_COMPL_PARTICIPANT_LOC
@$LOAD/triggers.sql ZSTG_PID_COMP_PARTCIPANT_PTM
@$LOAD/triggers.sql ZSTG_PID_INTR_PARTPANT_LOC
@$LOAD/triggers.sql ZSTG_PID_PHYSICALENTITY
@$LOAD/triggers.sql ZSTG_PID_PATHWAY_INTERACTION
@$LOAD/triggers.sql ZSTG_PID_FMLY_PRTPNT_ACTST
@$LOAD/triggers.sql ZSTG_PID_PATHWAYREFERENCE
@$LOAD/triggers.sql ZSTG_PID_PROTEINSUBUNIT
@$LOAD/triggers.sql ZSTG_PID_INTERACTANTS
@$LOAD/triggers.sql ZSTG_PID_INTR_PARTCPANT_ACTST
@$LOAD/triggers.sql ZSTG_PID_DUMP
@$LOAD/triggers.sql ZSTG_PID_MACROPROCESS_TYPE
@$LOAD/triggers.sql ZSTG_PID_FAMILY_MEMBER
@$LOAD/triggers.sql ZSTG_PID_COMP_PARTCIPANT_ACTST
@$LOAD/triggers.sql ZSTG_PID_INTR_PARTCPANT_PTM
@$LOAD/triggers.sql ZSTG_PID_FMLY_PRTPNT_PTM
@$LOAD/triggers.sql ZSTG_PID_INTERACTIONEVIDENCE
@$LOAD/triggers.sql ZSTG_PID_ENTITYACCESSION
@$LOAD/triggers.sql ZSTG_PID_INTERACTION
@$LOAD/triggers.sql ZSTG_PID_PATHWAY
@$LOAD/triggers.sql ZSTG_PID_INTERACTIONCONDITION
@$LOAD/triggers.sql ZSTG_PID_COMPLEX_COMPONENT


@$LOAD/indexes/zstg_pid_interactionreference.drop.sql
@$LOAD/indexes/zstg_pid_entityname.drop.sql
@$LOAD/indexes/zstg_pid_compl_participant_loc.drop.sql
@$LOAD/indexes/zstg_pid_comp_participant_ptm.drop.sql
@$LOAD/indexes/zstg_pid_intr_partpant_loc.drop.sql
@$LOAD/indexes/zstg_pid_physicalentity.drop.sql
@$LOAD/indexes/zstg_pid_pathway_interaction.drop.sql
@$LOAD/indexes/zstg_pid_fmly_prtpnt_actst.drop.sql
@$LOAD/indexes/zstg_pid_pathwayreference.drop.sql
@$LOAD/indexes/zstg_pid_proteinsubunit.drop.sql
@$LOAD/indexes/zstg_pid_interactants.drop.sql
@$LOAD/indexes/zstg_pid_intr_partcpant_actst.drop.sql
@$LOAD/indexes/zstg_pid_dump.drop.sql
@$LOAD/indexes/zstg_pid_macroprocess_type.drop.sql
@$LOAD/indexes/zstg_pid_family_member.drop.sql
@$LOAD/indexes/zstg_pid_comp_partcipant_actst.drop.sql
@$LOAD/indexes/zstg_pid_intr_partcpant_ptm.drop.sql
@$LOAD/indexes/zstg_pid_fmly_prtpnt_ptm.drop.sql
@$LOAD/indexes/zstg_pid_interactionevidence.drop.sql
@$LOAD/indexes/zstg_pid_entityaccession.drop.sql
@$LOAD/indexes/zstg_pid_interaction.drop.sql
@$LOAD/indexes/zstg_pid_pathway.drop.sql
@$LOAD/indexes/zstg_pid_interactioncondition.drop.sql
@$LOAD/indexes/zstg_pid_complex_component.drop.sql


@$LOAD/constraints/zstg_pid_interactionreference.disable.sql
@$LOAD/constraints/zstg_pid_entityname.disable.sql
@$LOAD/constraints/zstg_pid_compl_participant_loc.disable.sql
@$LOAD/constraints/zstg_pid_comp_participant_ptm.disable.sql
@$LOAD/constraints/zstg_pid_intr_partpant_loc.disable.sql
@$LOAD/constraints/zstg_pid_physicalentity.disable.sql
@$LOAD/constraints/zstg_pid_pathway_interaction.disable.sql
@$LOAD/constraints/zstg_pid_fmly_prtpnt_actst.disable.sql
@$LOAD/constraints/zstg_pid_pathwayreference.disable.sql
@$LOAD/constraints/zstg_pid_proteinsubunit.disable.sql
@$LOAD/constraints/zstg_pid_interactants.disable.sql
@$LOAD/constraints/zstg_pid_intr_partcpant_actst.disable.sql
@$LOAD/constraints/zstg_pid_dump.disable.sql
@$LOAD/constraints/zstg_pid_macroprocess_type.disable.sql
@$LOAD/constraints/zstg_pid_family_member.disable.sql
@$LOAD/constraints/zstg_pid_comp_partcipant_actst.disable.sql
@$LOAD/constraints/zstg_pid_intr_partcpant_ptm.disable.sql
@$LOAD/constraints/zstg_pid_fmly_prtpnt_ptm.disable.sql
@$LOAD/constraints/zstg_pid_interactionevidence.disable.sql
@$LOAD/constraints/zstg_pid_entityaccession.disable.sql
@$LOAD/constraints/zstg_pid_interaction.disable.sql
@$LOAD/constraints/zstg_pid_pathway.disable.sql
@$LOAD/constraints/zstg_pid_interactioncondition.disable.sql
@$LOAD/constraints/zstg_pid_complex_component.disable.sql
exit;
