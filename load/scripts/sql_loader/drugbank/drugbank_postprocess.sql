
-- Match drugs in Agent 

merge into ZSTG_DRUGBANK_DRUGS d using AGENT a 
    on (lower(a.AGENT_NAME) = lower(d.GENERIC_NAME))
    when matched then update set d.CABIO_AGENT_ID = a.AGENT_ID;

-- Match species in Taxon

merge into ZSTG_DRUGBANK_TARGETS d using (select * from TAXON where PERFERED = 1) t
   on (d.SPECIES_ABBR = t.ABBREVIATION)
   when matched then update set d.CABIO_TAXON_ID = t.TAXON_ID;

-- Match targets in Gene

insert into ZSTG_DRUGBANK_TARGET_GENES
select t.TARGET_ID, g.GENE_ID 
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
    on (a.AGENT_ID = d.CABIO_AGENT_ID)
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

-- TODO: Insert drug gene associations





commit;
ANALYZE TABLE gene_function_association COMPUTE STATISTICS;
ANALYZE TABLE gene_function_assoc_evidence COMPUTE STATISTICS;
ANALYZE TABLE evidence COMPUTE STATISTICS;

-- enable indexes and constraints

@$LOAD/indexes/gene_function_association.lower.sql
@$LOAD/indexes/gene_function_assoc_evidence.lower.sql
@$LOAD/indexes/evidence.lower.sql
@$LOAD/indexes/agent.lower.sql
@$LOAD/indexes/agent_agent_alias.lower.sql
@$LOAD/indexes/agent_alias.lower.sql

@$LOAD/indexes/gene_function_association.cols.sql
@$LOAD/indexes/gene_function_assoc_evidence.cols.sql
@$LOAD/indexes/evidence.cols.sql
@$LOAD/indexes/agent.cols.sql
@$LOAD/indexes/agent_agent_alias.cols.sql
@$LOAD/indexes/agent_alias.cols.sql

@$LOAD/constraints/gene_function_association.enable.sql
@$LOAD/constraints/gene_function_assoc_evidence.enable.sql
@$LOAD/constraints/evidence.enable.sql
@$LOAD/constraints/agent.enable.sql
@$LOAD/constraints/agent_agent_alias.enable.sql
@$LOAD/constraints/agent_alias.enable.sql


