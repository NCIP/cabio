package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Agent;
import gov.nih.nci.cabio.domain.Evidence;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.Collection;
import java.util.List;

import junit.framework.TestCase;

/**
 * Tests for data from Drugbank in the caBIO model.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class DrugbankTest extends TestCase {
    
    private final CaBioApplicationService appService = AllTests.getService();
    
    /**
     * Test a drug which was not in caBIO in 4.2, one that is new from Drugbank.
     * @throws Exception
     */
    public void testNewDrugAndTarget() throws Exception {

        Agent a = new Agent();
        a.setDrugbankAccession("DB02857");
        List<Agent> results = appService.search(Agent.class, a);
        
        assertEquals("Number of results",1,results.size());

        a = results.get(0);
        
        assertTrue("Expected DB02857 to be Guanosine",
            "Guanosine".equalsIgnoreCase(a.getName()));
        
        assertNotNull(a.getEVSId());
        assertNotNull(a.getCasNumber());
        assertNotNull(a.getChemicalFormula());
        
        Collection<GeneAgentAssociation> gfas = a.getGeneFunctionAssociationCollection();
        assertFalse(gfas.isEmpty());
        
        GeneAgentAssociation np = null;
        for (GeneAgentAssociation gfa : gfas) {
            if ("NP".equals(gfa.getGene().getSymbol())) {
                np = gfa;
                break;
            }
        }
        
        assertNotNull("Gene target NP not found for DB02857", np);
        assertEquals("Chemical_or_Drug_Has_Target_Gene_Product",np.getRole());
        
        boolean found = false; 
        for(Evidence e : np.getEvidenceCollection()) {
            System.out.println();
            if (17016423 == e.getPubmedId()) {
                found = true;
                break;
            }
        }
        
        assertTrue("Evidence not found for target NP, drug DB02857",found);
    }

    /**
     * Test a drug that existed in caBIO in 4.2, and has been augmented with 
     * Drugbank attributes.
     * @throws Exception
     */
    public void testOldDrug() throws Exception {

        Agent a = new Agent();
        a.setName("progesterone");
        List<Agent> results = appService.search(Agent.class, a);
        
        assertEquals("Number of results",1,results.size());

        a = results.get(0);

        assertEquals("DB00396", a.getDrugbankAccession());
        
        assertNotNull(a.getAbsorption());
        assertNotNull(a.getBiotransformation());
        assertNotNull(a.getCasNumber());
        assertNotNull(a.getEVSId());
        assertNotNull(a.getHalfLife());
        assertNotNull(a.getIndication());
        assertNotNull(a.getIUPACName());
        assertNotNull(a.getMechanismOfAction());
        assertNotNull(a.getMolecularWeight());
        assertNotNull(a.getNSCNumber());
        assertNotNull(a.getPercentProteinBinding());
        assertNotNull(a.getPharmacology());
        assertNotNull(a.getPubchemCompoundId());
        assertNotNull(a.getPubchemSubstanceId());
        assertNotNull(a.getSMILESCode());
        
        assertTrue("More aliases expected for progesterone",
            a.getAgentAliasCollection().size()>50);

        assertTrue("Expected at least one PathwayEntity for progesterone",
            a.getPathwayEntityCollection().size()>0);
    }

    /**
     * Test the source attribute of the GeneAgentAssociation.
     * @throws Exception
     */
    public void testSource() throws Exception {
        
        GeneAgentAssociation gaa = new GeneAgentAssociation();

        List<GeneAgentAssociation> allResults = 
            appService.search(GeneAgentAssociation.class, gaa);
        assertFalse(allResults.isEmpty());
        
        gaa.setSource("DrugBank");
        List<GeneAgentAssociation> drugbankResults = 
            appService.search(GeneAgentAssociation.class, gaa);
        assertFalse(drugbankResults.isEmpty());
        
        gaa.setSource("Cancer Gene Index");
        List<GeneAgentAssociation> cgiResults = 
            appService.search(GeneAgentAssociation.class, gaa);
        assertFalse(cgiResults.isEmpty());
        
        // These assertions may need to be reevaluated in the future
        assertTrue(drugbankResults.size() < cgiResults.size());
        assertEquals(allResults.size(), drugbankResults.size() + cgiResults.size());
    }
}
