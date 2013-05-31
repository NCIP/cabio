/*L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L*/

-- Match species in Taxon

merge into ZSTG_DRUGBANK_TARGETS d using (select * from TAXON where PERFERED = 1) t
   on (d.SPECIES_ABBR = t.ABBREVIATION)
   when matched then update set d.CABIO_TAXON_ID = t.TAXON_ID;

-- Match targets in Gene

insert into ZSTG_DRUGBANK_TARGET_GENES
select distinct t.TARGET_ID, g.GENE_ID 
    from ZSTG_DRUGBANK_TARGETS t, GENE_TV g
    where lower(g.SYMBOL) = lower(t.GENE_NAME)
    and g.TAXON_ID = t.CABIO_TAXON_ID;

commit;
ANALYZE TABLE ZSTG_DRUGBANK_DRUGS COMPUTE STATISTICS;
ANALYZE TABLE ZSTG_DRUGBANK_TARGETS COMPUTE STATISTICS;
ANALYZE TABLE ZSTG_DRUGBANK_TARGET_GENES COMPUTE STATISTICS;
ANALYZE TABLE ZSTG_DRUGBANK_DRUG_TARGETS COMPUTE STATISTICS;
ANALYZE TABLE ZSTG_DRUGBANK_DRUG_ALIASES COMPUTE STATISTICS;

-- Create agent id sequence

DROP SEQUENCE AGENT_SEQ;
DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(AGENT_ID)+1 INTO N FROM AGENT;
    Execute immediate ('CREATE SEQUENCE AGENT_SEQ START WITH '||N);
END;
/

-- Merge new drug data into Agent

merge into AGENT a using ZSTG_DRUGBANK_DRUGS d
    on (lower(a.AGENT_NAME) = lower(d.GENERIC_NAME))
    when matched then update set
        a.DRUGBANK_ACCESSION = d.Drug_id,
        a.EVS_ID = d.EVS_Id,
        a.ABSORPTION = d.Absorption,
        a.BIOTRANSFORMATION = d.Biotransformation,
        a.CAS_NUMBER = d.CAS_Registry_Number,
        a.CHEMICAL_FORMULA = d.Chemical_Formula,
        a.HALF_LIFE = d.Half_Life,
        a.INDICATION = d.Indication,
        a.IUPAC_NAME = d.Chemical_IUPAC_Name,
        a.MECHANISM_OF_ACTION = d.Mechanism_Of_Action,
        a.MOLECULAR_WEIGHT = to_number(d.Molecular_Weight_Avg),
        a.PHARMACOLOGY = d.Pharmacology,
        a.PROTEIN_BINDING = d.Protein_Binding,
        a.PUBCHEM_CID = to_number(d.PubChem_Compound_ID),
        a.PUBCHEM_SID = to_number(d.PubChem_Substance_ID),
        a.SMILES_CODE = d.Smiles_String_canonical,
        a.TOXICITY = d.Toxicity
    when not matched then insert 
        (a.AGENT_ID, a.DRUGBANK_ACCESSION, a.AGENT_NAME, a.EVS_ID, a.ABSORPTION, 
        a.BIOTRANSFORMATION, a.CAS_NUMBER, a.CHEMICAL_FORMULA, 
        a.HALF_LIFE, a.INDICATION, a.IUPAC_NAME, a.MECHANISM_OF_ACTION, 
        a.MOLECULAR_WEIGHT, a.PHARMACOLOGY, a.PROTEIN_BINDING, 
        a.PUBCHEM_CID, a.PUBCHEM_SID, a.SMILES_CODE, a.TOXICITY) 
    values 
        (AGENT_SEQ.NEXTVAL, d.Drug_id, d.Generic_Name, d.EVS_Id, d.Absorption, 
        d.Biotransformation, d.CAS_Registry_Number, d.Chemical_Formula, 
        d.Half_Life, d.Indication, d.Chemical_IUPAC_Name, d.Mechanism_Of_Action, 
        d.Molecular_Weight_Avg, d.Pharmacology, d.Protein_Binding, 
        d.PubChem_Compound_ID, d.PubChem_Substance_ID, d.Smiles_String_canonical, d.Toxicity);

commit;
ANALYZE TABLE agent COMPUTE STATISTICS;

-- Insert drug aliases

DROP SEQUENCE AGENT_ALIAS_SEQ;
CREATE SEQUENCE AGENT_ALIAS_SEQ;

insert into AGENT_ALIAS (ID, TYPE, NAME)
select AGENT_ALIAS_SEQ.nextVal, ALIAS_TYPE, ALIAS_NAME 
from (
    select distinct z.ALIAS_TYPE, z.ALIAS_NAME
    from AGENT a, ZSTG_DRUGBANK_DRUG_ALIASES z
    where a.DRUGBANK_ACCESSION = z.DRUG_ID
);

insert into AGENT_AGENT_ALIAS (AGENT_ID, AGENT_ALIAS_ID)
select a.AGENT_ID, aa.ID
from AGENT a, AGENT_ALIAS aa, ZSTG_DRUGBANK_DRUG_ALIASES z
where aa.TYPE = z.ALIAS_TYPE
and aa.NAME = z.ALIAS_NAME
and a.DRUGBANK_ACCESSION = z.DRUG_ID;

commit;
ANALYZE TABLE agent_agent_alias COMPUTE STATISTICS;
ANALYZE TABLE agent_alias COMPUTE STATISTICS;

-- Clone the Cancer Gene Index tables for caBIO 4.3 and up

insert into GENE_FUNCTION_ASSOCIATION_43 
    (ID, GENE_ID, AGENT_ID, HISTOLOGYCODE_ID, ROLE_ID, 
     EVIDENCE_ID, DISCRIMINATOR, BIG_ID, SOURCE)
select ID, GENE_ID, AGENT_ID, HISTOLOGYCODE_ID, ROLE_ID, 
    EVIDENCE_ID, DISCRIMINATOR, BIG_ID, 'Cancer Gene Index' 
from GENE_FUNCTION_ASSOCIATION;

insert into EVIDENCE_43 (ID, PUBMED_ID, NEGATION_STATUS, 
    CELLLINE_STATUS, COMMENTS, SENTENCE_STATUS, SENTENCE, BIG_ID) 
select ID, PUBMED_ID, NEGATION_STATUS, 
    CELLLINE_STATUS, COMMENTS, SENTENCE_STATUS, SENTENCE, BIG_ID
from EVIDENCE;

commit;

-- Populate the many-to-many correlation table introduced in 4.3

insert into GENE_FUNCTION_ASSOC_EVIDENCE (GENE_FUNCTION_ASSOC_ID, EVIDENCE_ID)
select distinct ID, EVIDENCE_ID
from GENE_FUNCTION_ASSOCIATION_43;

commit;

-- Insert references

DROP SEQUENCE EVIDENCE_SEQ;
DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(ID)+1 INTO N FROM EVIDENCE;
    Execute immediate ('CREATE SEQUENCE EVIDENCE_SEQ START WITH '||N);
END;
/

insert into EVIDENCE_43 (ID, PUBMED_ID, SOURCE)
select EVIDENCE_SEQ.nextVal, pubmed_id, 'DrugBank' from ( 
    select distinct to_number(pubmed_id) pubmed_id 
    from ZSTG_DRUGBANK_DRUG_TARGETS where pubmed_id is not null
);

commit;
column columnload new_value load_tablspc;
select globals.get_production_tablespace as columnload from dual;
CREATE INDEX EVIDENCE43_INDEX ON EVIDENCE_43
(PUBMED_ID, SOURCE)
NOLOGGING
TABLESPACE &load_tablspc
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          64K
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

ANALYZE TABLE EVIDENCE_43 COMPUTE STATISTICS;

-- Insert drug gene associations

create or replace view ZSTG_DRUGBANK_DRUG_TARGETS_VW as
    select distinct Target_Id, Drug_id from ZSTG_DRUGBANK_DRUG_TARGETS;
    
DROP SEQUENCE GFA_SEQ;
DECLARE
    N NUMBER(10);
BEGIN
    SELECT MAX(ID)+1 INTO N FROM GENE_FUNCTION_ASSOCIATION_43;
    Execute immediate ('CREATE SEQUENCE GFA_SEQ START WITH '||N);
END;
/

insert into GENE_FUNCTION_ASSOCIATION_43 
    (ID, AGENT_ID, GENE_ID, ROLE_ID, DISCRIMINATOR, SOURCE)
select GFA_SEQ.nextVal, agent_id, gene_id, 
    'Chemical_or_Drug_Has_Target_Gene_Product','GeneAgentAssociation','DrugBank'
from (
    select distinct a.AGENT_ID agent_id, tg.cabio_gene_id gene_id
    from AGENT a, ZSTG_DRUGBANK_DRUG_TARGETS_VW dt, 
        ZSTG_DRUGBANK_TARGETS t, ZSTG_DRUGBANK_TARGET_GENES tg
    where a.DRUGBANK_ACCESSION = dt.drug_id
    and dt.target_id = t.target_id
    and t.target_id = tg.target_id
);

commit;

insert into GENE_FUNCTION_ASSOC_EVIDENCE (GENE_FUNCTION_ASSOC_ID, EVIDENCE_ID)
select distinct gfa.id, e.id
from GENE_FUNCTION_ASSOCIATION_43 gfa, ZSTG_DRUGBANK_TARGET_GENES tg, AGENT a, 
     ZSTG_DRUGBANK_DRUG_TARGETS dt, EVIDENCE_43 e
where gfa.gene_id = tg.cabio_gene_id
and gfa.agent_id = a.agent_id
and gfa.source = 'DrugBank'
and dt.drug_id = a.DRUGBANK_ACCESSION
and dt.target_id = tg.target_id
and dt.pubmed_id = e.pubmed_id
and e.source = 'DrugBank';

commit;

ANALYZE TABLE GENE_FUNCTION_ASSOC_EVIDENCE COMPUTE STATISTICS;
ANALYZE TABLE GENE_FUNCTION_ASSOCIATION_43 COMPUTE STATISTICS;
ANALYZE TABLE EVIDENCE_43 COMPUTE STATISTICS;

-- enable indexes and constraints

@$LOAD/constraints/gene_function_assoc_evidence.enable.sql
@$LOAD/constraints/agent.enable.sql
@$LOAD/constraints/agent_agent_alias.enable.sql
@$LOAD/constraints/agent_alias.enable.sql
@$LOAD/constraints/gene_function_association_43.enable.sql
@$LOAD/constraints/evidence_43.enable.sql

@$LOAD/indexes/gene_function_assoc_evidence.cols.sql
@$LOAD/indexes/agent.cols.sql
@$LOAD/indexes/agent_agent_alias.cols.sql
@$LOAD/indexes/agent_alias.cols.sql
@$LOAD/indexes/gene_function_association_43.cols.sql
@$LOAD/indexes/evidence_43.cols.sql

@$LOAD/indexes/gene_function_assoc_evidence.lower.sql
@$LOAD/indexes/agent.lower.sql
@$LOAD/indexes/agent_agent_alias.lower.sql
@$LOAD/indexes/agent_alias.lower.sql
@$LOAD/indexes/gene_function_association_43.lower.sql
@$LOAD/indexes/evidence_43.lower.sql

EXIT;
