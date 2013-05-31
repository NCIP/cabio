/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

truncate table zstg_InteractionComponentLabel;
truncate table zstg_InteractionCompPTMTerms;
truncate table zstg_InteractionCondition;
truncate table zstg_InteractionEvidence;
truncate table zstg_InteractionReference;
truncate table zstg_Interactions;
truncate table zstg_moleculecomponentlabels;
truncate table zstg_MoleculeCompPTMTerms;
truncate table zstg_moleculefamilies;
truncate table zstg_moleculeNames;
truncate table zstg_moleculeparts;
truncate table zstg_pathwaycomponents;
truncate table zstg_pathwaycurators;
truncate table zstg_pathwayreviewers;
truncate table zstg_pathways;

@$LOAD/indexer_new.sql zstg_InteractionComponentLabel
@$LOAD/indexer_new.sql zstg_InteractionCompPTMTerms
@$LOAD/indexer_new.sql zstg_InteractionCondition
@$LOAD/indexer_new.sql zstg_InteractionEvidence
@$LOAD/indexer_new.sql zstg_InteractionReference
@$LOAD/indexer_new.sql zstg_Interactions
@$LOAD/indexer_new.sql zstg_moleculecomponentlabels
@$LOAD/indexer_new.sql zstg_MoleculeCompPTMTerms
@$LOAD/indexer_new.sql zstg_moleculefamilies
@$LOAD/indexer_new.sql zstg_moleculeNames
@$LOAD/indexer_new.sql zstg_moleculeparts
@$LOAD/indexer_new.sql zstg_pathwaycomponents
@$LOAD/indexer_new.sql zstg_pathwaycurators
@$LOAD/indexer_new.sql zstg_pathwayreviewers
@$LOAD/indexer_new.sql zstg_pathways


@$LOAD/constraints.sql zstg_InteractionComponentLabel
@$LOAD/constraints.sql zstg_InteractionCompPTMTerms
@$LOAD/constraints.sql zstg_InteractionCondition
@$LOAD/constraints.sql zstg_InteractionEvidence
@$LOAD/constraints.sql zstg_InteractionReference
@$LOAD/constraints.sql zstg_Interactions
@$LOAD/constraints.sql zstg_moleculecomponentlabels
@$LOAD/constraints.sql zstg_MoleculeCompPTMTerms
@$LOAD/constraints.sql zstg_moleculefamilies
@$LOAD/constraints.sql zstg_moleculeNames
@$LOAD/constraints.sql zstg_moleculeparts
@$LOAD/constraints.sql zstg_pathwaycomponents
@$LOAD/constraints.sql zstg_pathwaycurators
@$LOAD/constraints.sql zstg_pathwayreviewers
@$LOAD/constraints.sql zstg_pathways

@$LOAD/triggers.sql zstg_InteractionComponentLabel
@$LOAD/triggers.sql zstg_InteractionCompPTMTerms
@$LOAD/triggers.sql zstg_InteractionCondition
@$LOAD/triggers.sql zstg_InteractionEvidence
@$LOAD/triggers.sql zstg_InteractionReference
@$LOAD/triggers.sql zstg_Interactions
@$LOAD/triggers.sql zstg_moleculecomponentlabels
@$LOAD/triggers.sql zstg_MoleculeCompPTMTerms
@$LOAD/triggers.sql zstg_moleculefamilies
@$LOAD/triggers.sql zstg_moleculeNames
@$LOAD/triggers.sql zstg_moleculeparts
@$LOAD/triggers.sql zstg_pathwaycomponents
@$LOAD/triggers.sql zstg_pathwaycurators
@$LOAD/triggers.sql zstg_pathwayreviewers
@$LOAD/triggers.sql zstg_pathways

@$LOAD/indexes/zstg_interactioncomponentlabel.drop.sql
@$LOAD/indexes/zstg_interactioncompptmterms.drop.sql
@$LOAD/indexes/zstg_interactioncondition.drop.sql
@$LOAD/indexes/zstg_interactionevidence.drop.sql
@$LOAD/indexes/zstg_interactionreference.drop.sql
@$LOAD/indexes/zstg_interactions.drop.sql
@$LOAD/indexes/zstg_moleculecomponentlabels.drop.sql
@$LOAD/indexes/zstg_moleculecompptmterms.drop.sql
@$LOAD/indexes/zstg_moleculefamilies.drop.sql
@$LOAD/indexes/zstg_moleculenames.drop.sql
@$LOAD/indexes/zstg_moleculeparts.drop.sql
@$LOAD/indexes/zstg_pathwaycomponents.drop.sql
@$LOAD/indexes/zstg_pathwaycurators.drop.sql
@$LOAD/indexes/zstg_pathwayreviewers.drop.sql
@$LOAD/indexes/zstg_pathways.drop.sql


@$LOAD/constraints/zstg_interactioncomponentlabel.disable.sql
@$LOAD/constraints/zstg_interactioncompptmterms.disable.sql
@$LOAD/constraints/zstg_interactioncondition.disable.sql
@$LOAD/constraints/zstg_interactionevidence.disable.sql
@$LOAD/constraints/zstg_interactionreference.disable.sql
@$LOAD/constraints/zstg_interactions.disable.sql
@$LOAD/constraints/zstg_moleculecomponentlabels.disable.sql
@$LOAD/constraints/zstg_moleculecompptmterms.disable.sql
@$LOAD/constraints/zstg_moleculefamilies.disable.sql
@$LOAD/constraints/zstg_moleculenames.disable.sql
@$LOAD/constraints/zstg_moleculeparts.disable.sql
@$LOAD/constraints/zstg_pathwaycomponents.disable.sql
@$LOAD/constraints/zstg_pathwaycurators.disable.sql
@$LOAD/constraints/zstg_pathwayreviewers.disable.sql
@$LOAD/constraints/zstg_pathways.disable.sql

exit;
