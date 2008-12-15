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
            assertEquals(agent, o.getAgent().getName().toLowerCase());
            assertPreloaded(o,"gene");
            assertPreloaded(o,"agent");
            assertPreloaded(o,"evidence");
        }
    }

    public void testAgentCuiToGenes() throws Exception {

        String agentCui = "C214";
        List<GeneAgentAssociation> results = rs.getGenesByAgent(agentCui);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneAgentAssociation o : results) {
            assertEquals(agentCui, o.getAgent().getEVSId());
            assertPreloaded(o,"gene");
            assertPreloaded(o,"agent");
            assertPreloaded(o,"evidence");
        }
    }
    
    public void testDiseaseToGenes() throws Exception {

        String disease = "fibroadenoma";
        List<GeneDiseaseAssociation> results = rs.getGenesByDisease(disease);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneDiseaseAssociation o : results) {
            assertNotNull(o.getGene());
            assertEquals(disease, o.getDiseaseOntology().getName().toLowerCase());
            assertPreloaded(o,"gene");
            assertPreloaded(o,"diseaseOntology");
            assertPreloaded(o,"evidence");
        }
    }

    public void testDiseaseCuiToGenes() throws Exception {

        String diseaseCui = "C3744";
        List<GeneDiseaseAssociation> results = rs.getGenesByDisease(diseaseCui);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneDiseaseAssociation o : results) {
            assertNotNull(o.getGene());
            assertEquals(diseaseCui, o.getDiseaseOntology().getEVSId());
            assertPreloaded(o,"gene");
            assertPreloaded(o,"diseaseOntology");
            assertPreloaded(o,"evidence");
        }
    }
    
    public void testGeneAssociations() throws Exception {

        String geneSymbol = "C4BPA";
        List<GeneFunctionAssociation> results = rs.getGeneAssociations(geneSymbol);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneFunctionAssociation o : results) {
            assertNotNull(o.getGene());
            assertTrue(geneSymbol.equalsIgnoreCase(o.getGene().getSymbol())
                ||geneSymbol.equalsIgnoreCase(o.getGene().getHugoSymbol()));
            assertPreloaded(o,"gene");
            assertPreloaded(o,"evidence");
        }
    }
    
    public void testReportersByGene() throws Exception {

        String geneSymbol = "brca2";
        List<ExpressionArrayReporter> results = rs.getReportersByGene(geneSymbol);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(ExpressionArrayReporter o : results) {
            assertTrue((geneSymbol.equalsIgnoreCase(o.getGene().getSymbol())
                ||geneSymbol.equalsIgnoreCase(o.getGene().getHugoSymbol())));
            assertPreloaded(o,"gene");
            assertPreloaded(o,"microarray");
        }
    }
    
    public void testReportersBySNP() throws Exception {

        String dbSNPId = "rs4242682";
        List<SNPArrayReporter> results = rs.getReportersBySNP(dbSNPId);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(SNPArrayReporter o : results) {
            assertEquals(dbSNPId, o.getSNP().getDBSNPID());
            assertPreloaded(o,"SNP");
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
    
    public void testGeneDiseaseAssociation() throws Exception {

        Object o = rs.getDetailObject(GeneDiseaseAssociation.class, 138674L);
        assertNotNull(o);
    }
}
