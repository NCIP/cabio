package gov.nih.nci.cabio.portal;

import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.cabio.domain.GeneDiseaseAssociation;
import gov.nih.nci.cabio.domain.GeneFunctionAssociation;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.cabio.portal.portlet.ReportService;
import gov.nih.nci.cabio.util.ORMTestCase;

import java.util.List;

/**
 * Tests for each method in ReportService.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ReportTest extends ORMTestCase {

    private final ReportService rs = AllTests.getReportService();

    public void testAgentToGenes() throws Exception {

        String agent = "albumin";
        List<GeneAgentAssociation> results = rs.getGenesByAgent(agent);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneAgentAssociation o : results) {
                        
            assertNotNull(o.getGene());
            assertPreloaded(o,"gene");
            
            assertNotNull(o.getAgent());
            assertPreloaded(o,"agent");
            assertEquals(agent, o.getAgent().getName().toLowerCase());
        }
    }
    
    public void testAgentToGenesEvidence() throws Exception {

        String agent = "albumin";
        List<GeneAgentAssociation> results1 = 
            rs.getGenesByAgentWithEvidenceProperties(agent, "", "", "");
        assertNotNull(results1);
        assertFalse(results1.isEmpty());
        
        List<GeneAgentAssociation> results2 = 
            rs.getGenesByAgentWithEvidenceProperties(agent, "on", "", "");
        assertNotNull(results2);

        List<GeneAgentAssociation> results3 = 
            rs.getGenesByAgentWithEvidenceProperties(agent, "", "on", "");
        assertNotNull(results2);
        
        List<GeneAgentAssociation> results4 = 
            rs.getGenesByAgentWithEvidenceProperties(agent, "", "", "on");
        assertNotNull(results2);
        
        assertTrue(results2.size() > results1.size());
        assertTrue(results3.size() > results1.size());
        assertTrue(results4.size() > results1.size());
    }

    public void testAgentCuiToGenes() throws Exception {

        String agentCui = "C214";
        List<GeneAgentAssociation> results = rs.getGenesByAgent(agentCui);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneAgentAssociation o : results) {
            
            assertNotNull(o.getGene());
            assertPreloaded(o,"gene");
            
            assertNotNull(o.getAgent());
            assertPreloaded(o,"agent");
            assertEquals(agentCui, o.getAgent().getEVSId());
        }
    }
    
    public void testDiseaseToGenes() throws Exception {

        String disease = "fibroadenoma";
        List<GeneDiseaseAssociation> results = rs.getGenesByDisease(disease);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneDiseaseAssociation o : results) {
            
            assertNotNull(o.getGene());
            assertPreloaded(o,"gene");
            
            assertNotNull(o.getDiseaseOntology());
            assertPreloaded(o,"diseaseOntology");
            assertEquals(disease, o.getDiseaseOntology().getName().toLowerCase());
        }
    }

    public void testDiseaseCuiToGenes() throws Exception {

        String diseaseCui = "C3744";
        List<GeneDiseaseAssociation> results = rs.getGenesByDisease(diseaseCui);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneDiseaseAssociation o : results) {
            
            assertNotNull(o.getGene());
            assertPreloaded(o,"gene");

            assertNotNull(o.getDiseaseOntology());
            assertEquals(diseaseCui, o.getDiseaseOntology().getEVSId());
            assertPreloaded(o,"diseaseOntology");
        }
    }
    
    public void testGeneAssociations() throws Exception {

        String geneSymbol = "C4BPA";
        List<GeneFunctionAssociation> results = rs.getGeneAssociations(geneSymbol);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneFunctionAssociation o : results) {
            
            assertNotNull(o.getGene());
            assertPreloaded(o,"gene");
            assertTrue(geneSymbol.equalsIgnoreCase(o.getGene().getSymbol())
                ||geneSymbol.equalsIgnoreCase(o.getGene().getHugoSymbol()));
        }
    }
    
    public void testReportersByGene() throws Exception {

        String geneSymbol = "brca2";
        List<ExpressionArrayReporter> results = rs.getReportersByGene(geneSymbol);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(ExpressionArrayReporter o : results) {
            
            assertNotNull(o.getGene());
            assertPreloaded(o,"gene");
            assertTrue((geneSymbol.equalsIgnoreCase(o.getGene().getSymbol())
                ||geneSymbol.equalsIgnoreCase(o.getGene().getHugoSymbol())));
            
            assertNotNull(o.getMicroarray());
            assertPreloaded(o,"microarray");
        }
    }
    
    public void testReportersBySNP() throws Exception {

        String dbSNPId = "rs4242682";
        List<SNPArrayReporter> results = rs.getReportersBySNP(dbSNPId);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(SNPArrayReporter o : results) {

            assertNotNull(o.getSNP());
            assertPreloaded(o,"SNP");
            assertEquals(dbSNPId, o.getSNP().getDBSNPID());
            
            assertNotNull(o.getMicroarray());
            assertPreloaded(o,"microarray");
        }
    }

    public void testPathwaysByName() throws Exception {

        String pathwayName = "h_ephA4Pathway";
        List<Pathway> results = rs.getPathwaysByName(pathwayName);
        assertNotNull(results);
        assertEquals(1, results.size());
        for(Pathway o : results) {
            assertEquals(pathwayName,o.getName());
        }
    }
    
    public void testPathwayDetails() throws Exception {

        String pathwayName = "h_ephA4Pathway";
        List<Pathway> results = rs.getPathwaysByName(pathwayName);
        assertNotNull(results);
        assertEquals(1, results.size());
        Pathway pathway = results.get(0);
        
        Pathway p = (Pathway)rs.getDetailObject(Pathway.class, pathway.getId());
        assertNotNull(p);
        assertEquals(p.getBigid(), pathway.getBigid());
        assertEquals(p.getDisplayValue(), pathway.getDisplayValue());
        assertPreloaded(p, "taxon");
    }

}
