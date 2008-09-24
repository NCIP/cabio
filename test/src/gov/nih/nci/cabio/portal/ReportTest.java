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
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Agent was not preloaded", o.getAgent());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
        }
    }

    public void testAgentCuiToGenes() throws Exception {

        String agentCui = "C214";
        List<GeneAgentAssociation> results = rs.getGenesByAgent(agentCui);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneAgentAssociation o : results) {
            assertEquals(agentCui, o.getAgent().getEVSId());
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Agent was not preloaded", o.getAgent());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
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
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Disease was not preloaded", o.getDiseaseOntology());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
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
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Disease was not preloaded", o.getDiseaseOntology());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
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
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
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
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Microarray was not preloaded", o.getMicroarray());
        }
    }
    
    public void testReportersBySNP() throws Exception {

        String dbSNPId = "rs4242682";
        List<SNPArrayReporter> results = rs.getReportersBySNP(dbSNPId);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(SNPArrayReporter o : results) {
            assertEquals(dbSNPId, o.getSNP().getDBSNPID());
            assertPreloaded("SNP was not preloaded", o.getSNP());
            assertPreloaded("Microarray was not preloaded", o.getMicroarray());
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
}
