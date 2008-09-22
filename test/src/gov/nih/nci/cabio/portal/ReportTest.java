package gov.nih.nci.cabio.portal;

import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.cabio.domain.GeneDiseaseAssociation;
import gov.nih.nci.cabio.domain.GeneFunctionAssociation;
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

        List<GeneAgentAssociation> results = rs.getGenesByAgent("albumin");
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneAgentAssociation o : results) {
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Agent was not preloaded", o.getAgent());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
        }
    }
    
    public void testDiseaseToGenes() throws Exception {

        List<GeneDiseaseAssociation> results = rs.getGenesByDisease("fibroadenoma");
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneDiseaseAssociation o : results) {
            assertNotNull(o.getGene());
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Disease was not preloaded", o.getDiseaseOntology());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
        }
    }

    public void testGeneAssociations() throws Exception {

        List<GeneFunctionAssociation> results = rs.getGeneAssociations("C4BPA");
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(GeneFunctionAssociation o : results) {
            assertNotNull(o.getGene());
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Evidence was not preloaded", o.getEvidence());
        }
    }
    
    public void testReportersByGene() throws Exception {

        List<ExpressionArrayReporter> results = rs.getReportersByGene("brca2");
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(ExpressionArrayReporter o : results) {
            assertPreloaded("Gene was not preloaded", o.getGene());
            assertPreloaded("Microarray was not preloaded", o.getMicroarray());
        }
    }
    
    public void testReportersBySNP() throws Exception {

        List<SNPArrayReporter> results = rs.getReportersBySNP("rs4242682");
        assertNotNull(results);
        assertFalse(results.isEmpty());
        for(SNPArrayReporter o : results) {
            assertPreloaded("SNP was not preloaded", o.getSNP());
            assertPreloaded("Microarray was not preloaded", o.getMicroarray());
        }
    }
    
}
