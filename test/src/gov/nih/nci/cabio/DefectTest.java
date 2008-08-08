package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.HomologousAssociation;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.common.provenance.domain.Provenance;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.util.List;

import junit.framework.TestCase;

/**
 * Each of the test cases here represents one caBIO defect in GForge. The
 * tests will succeed if the bug has been fixed.  
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class DefectTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
    
    /**
     * Test for merged SNPs.
     * Until bug has been fixed, fails with "SNP is null"
     * @throws Exception
     */
    public void testGF6418() throws Exception {

        SNPArrayReporter reporter = new SNPArrayReporter();
        reporter.setName("SNP_A-1705928");
        List resultList = appService.search(SNPArrayReporter.class, reporter);
    
        assertEquals("Reporters",1,resultList.size());
        reporter = (SNPArrayReporter)resultList.get(0);

        SNP snp = reporter.getSNP();
        assertNotNull("SNP is null",snp);
        assertEquals("rs1015834",snp.getDBSNPID());
    }
    
    /**
     * CGLIB Enhancement failed error.
     * @throws Exception
     */
    public void testGF8543() throws Exception {
        Provenance p = new Provenance();
        p.setFullyQualifiedClassName("gov.nih.nci.cabio.domain.Protein");
        p.setObjectIdentifier("2364");
        List resultList = appService.search(Provenance.class, p);
        assertEquals("results",1,resultList.size());
    }

    /**
     * HomologousAssociation remodeling. 
     * @throws Exception
     */
    public void testGF7767() throws Exception {

        Gene gene = new Gene();
        gene.setBigid("hdl://2500.1.PMEUQUCCL5/DXZ7ZIOFOE"); // Hs.194143 (BRCA1)
        List resultList = appService.search(Gene.class, gene);
        assertEquals("results",1,resultList.size());
        gene = (Gene)resultList.get(0);
        
        HomologousAssociation ha = gene.getHomologousAssociationCollection().iterator().next();
        
        assertEquals(gene.getId(),ha.getGene().getId());
        assertEquals("Mm",ha.getHomologousGene().getTaxon().getAbbreviation());
    }
    
//    /**
//     * Aggregate GO associations. 
//     * TODO: write test case
//     * @throws Exception
//     */
//    public void testGF7769() throws Exception {
//    }
//    
//    /**
//     * Incorrect association among Library/Gene/Histopathology. 
//     * TODO: this should be rewritten
//     * @throws Exception
//     */
//    public void testGF9264() throws Exception {
//
//        // get first Library's first Histopathology
//        Library library = new Library();
//        library.setId(new Long(1));
//        List resultList = appService.search(Histopathology.class, library);
//        assertEquals("libraries",1,resultList.size());
//        Histopathology histopath = (Histopathology)resultList.get(0);
//        
//        // get Genes
//        Gene gene1 = histopath.getGeneCollection().iterator().next();
//        
//        // get Genes thru Organ
//        Gene gene2 = histopath.getOrganOntology().getGeneCollection().iterator().next();
//        
//        // both should have libraryCollections containing the original library
//        boolean found1 = false;
//        boolean found2 = false;
//        
//        for(Library l : gene1.getLibraryCollection()) {
//            if (l.getId().equals(library.getId())) {
//                found1 = true;
//            }
//        }
//        
//        assertTrue("Histopathology-Gene association incorrect",found1);
//
//        for(Library l : gene2.getLibraryCollection()) {
//            if (l.getId().equals(library.getId())) {
//                found2 = true;
//            }
//        }
//        
//        assertTrue("Histopathology-OrganOntology-Gene association incorrect",found2);
//    }
}
