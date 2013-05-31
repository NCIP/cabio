/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.cabio.domain.Agent;
import gov.nih.nci.cabio.domain.AgentAlias;
import gov.nih.nci.cabio.domain.Evidence;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.Collection;
import java.util.List;

/**
 * Demonstrates how to aggregate Drugbank data from caBIO into a Drug Card 
 * format similar to the one produced by the Drugbank website 
 * (http://www.drugbank.ca). 
 * 
 * @author caBIO Team
 */
public class TestDrugbank {

    private static CaBioApplicationService as;
    
    public static void main(String[] args) throws Exception {
        
        as = (CaBioApplicationService) 
            ApplicationServiceProvider.getApplicationService(); 

        String accession = "DB00106";
        if (args.length > 0) {
            accession = args[0];
        }
        
        printDrugCard(accession);
    }
    
    private static final void printDrugCard(String accession) 
            throws ApplicationException  {

        Agent a = getAgent(accession);
        
        if (a == null) {
            System.out.println("Drug wth accession "+accession+" not found in caBIO.");
            return;
        }
        
        Collection<AgentAlias> aas = a.getAgentAliasCollection();

        System.out.println("Drug information about "+accession+" in caBIO.");
        System.out.println("Compare output to http://www.drugbank.ca/drugs/"+accession);
        
        System.out.println("\n== Drugbank attributes ==");
        System.out.println("Primary Accession Number: "+a.getDrugbankAccession());
        System.out.println("Name: "+a.getName());
        System.out.println("Synonyms: ");
        for(AgentAlias aa : aas) {
            if ("Synonym".equals(aa.getType())) System.out.println("  "+aa.getName());
        }
        System.out.println("Brand Names: ");
        for(AgentAlias aa : aas) {
            if ("Trade Name".equals(aa.getType())) System.out.println("  "+aa.getName());
        }
        System.out.println("Chemical IUPAC Name: "+a.getIUPACName());
        System.out.println("Chemical Formula: "+a.getChemicalFormula());
        System.out.println("CAS Registry Number: "+a.getCasNumber());
        System.out.println("PubChem Compound: http://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?cid="+a.getPubchemCompoundId());
        System.out.println("PubChem Substance: http://pubchem.ncbi.nlm.nih.gov/summary/summary.cgi?sid="+a.getPubchemSubstanceId());
        System.out.println("Average Molecular Weight: "+a.getMolecularWeight());
        System.out.println("Canonical SMILES: "+a.getSMILESCode());
        System.out.println("Indication: "+a.getIndication());
        System.out.println("Pharmacology: "+a.getPharmacology());
        System.out.println("Mechanism of Action: "+a.getMechanismOfAction());
        System.out.println("Absorption: "+a.getAbsorption());
        System.out.println("Toxicity: "+a.getToxicity());
        System.out.println("Protein Binding: "+a.getPercentProteinBinding());
        System.out.println("Biotransformation: "+a.getBiotransformation());
        System.out.println("Half Life: "+a.getHalfLife());
        
        System.out.println("\n== caBIO attributes ==");
        System.out.println("EVS Id: "+a.getEVSId());
        System.out.println("Grid Id: "+a.getBigid());
        System.out.println("NSC Number: "+a.getNSCNumber());
        System.out.println("Comment: "+a.getComment());
        System.out.println("Source: "+a.getSource());
        System.out.println("Is CMAP agent: "+a.getIsCMAPAgent());
        
        System.out.println("\n== Targets ==");
        
        int i=0;
        for(GeneAgentAssociation gaa : a.getGeneFunctionAssociationCollection()) {
            
            if (!"DrugBank".equals(gaa.getSource())) continue;

            if (i > 0) System.out.println();
            
            i++;
            
            Gene g = gaa.getGene();
            Collection<Evidence> es = gaa.getEvidenceCollection();

            System.out.println("Target "+i+" Name: "+g.getFullName());
            System.out.println("Target "+i+" Gene Name: "+g.getSymbol());
            System.out.println("Target "+i+" HUGO Symbol: "+g.getHugoSymbol());
            System.out.println("Target "+i+" Drug References: ");
            for(Evidence e : es) {
                System.out.println("  http://www.ncbi.nlm.nih.gov/pubmed/"+e.getPubmedId());
            }
        }

    }
    
    private static final Agent getAgent(String accession) 
            throws ApplicationException {

        Agent a = new Agent();
        a.setDrugbankAccession(accession);
        List<Agent> results = as.search(Agent.class, a);
        if (results.isEmpty()) return null;
        return results.get(0);
    }
        
}