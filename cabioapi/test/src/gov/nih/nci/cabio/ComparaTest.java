package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.ConstrainedRegion;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GenePhysicalLocation;
import gov.nih.nci.cabio.domain.MultipleAlignment;
import gov.nih.nci.search.FeatureRangeQuery;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.List;

import junit.framework.TestCase;

/**
 * Tests for data from Compara in the caBIO model.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ComparaTest extends TestCase {
    
    private final CaBioApplicationService appService = AllTests.getService();
    
    /**
     * Tests the 12-way multiple alignment to ensure is exists within the
     * MultipleAlignment object, that is has 12 associated taxons, and that it
     * has some associated regions (locations).
     */
    public void test12WayAlignment() throws Exception {

        MultipleAlignment ma = new MultipleAlignment();
        ma.setName("*12 amniota vertebrates*");
        List<MultipleAlignment> results = 
            appService.search(MultipleAlignment.class, ma);
        
        assertEquals("Expected one result for "+ma.getName(),results.size(),1);
        ma = results.get(0);
        
        assertEquals("Expected 12 taxons",12,
            ma.getTaxonCollection().size());
        
        assertTrue("Expected more than 100000 constrained regions",
            ma.getConservedPhysicalLocationCollection().size() > 100000);
    }

    /**
     * Tests range query involving constrained regions around BRCA2.
     */
    public void testRangeQueryForConstrainedRegions() throws Exception {

        String bigId = "hdl://2500.1.PMEUQUCCL5/QGSYEORJAM";
        Gene gene = (Gene)appService.getDataObject(bigId);
        
        GenePhysicalLocation location = null;
        for(GenePhysicalLocation gpl : gene.getPhysicalLocationCollection()) {
            if ("GENE".equals(gpl.getFeatureType()) && "Primary_Assembly".equals(gpl.getAssembly())) {
                location = gpl;
                break;
            }
        }
        
        assertNotNull("Gene has no Primary_Assembly location",location);
        
        FeatureRangeQuery query = new FeatureRangeQuery();
        query.setFeature(location);
        query.setUpstreamDistance(new Long(0));
        query.setDownstreamDistance(new Long(0));
        List<ConstrainedRegion> results = appService.search(
                ConstrainedRegion.class, query);
        
        assertFalse("No constrained regions found",results.isEmpty());
        
        for(ConstrainedRegion cr : results) {
            assertNotNull(cr.getMultipleAlignment());
            assertTrue(cr.getChromosomalEndPosition()
                >= location.getChromosomalStartPosition());
        }
        
    }
}
