package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.ArrayReporterPhysicalLocation;
import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.NucleicAcidPhysicalLocation;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPPhysicalLocation;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.cabio.domain.Transcript;
import gov.nih.nci.cabio.domain.TranscriptPhysicalLocation;
import gov.nih.nci.search.AbsoluteRangeQuery;
import gov.nih.nci.search.FeatureRangeQuery;
import gov.nih.nci.search.GridIdRangeQuery;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.List;

import junit.framework.TestCase;

/**
 * Unit tests for Range Query API in caBIO. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class RangeQueryTest extends TestCase {

    private final CaBioApplicationService appService = AllTests.getService();

    /**
     * Ensure that the API thows the appropriate exception if the target class
     * is invalid (i.e. not a subclass of PhysicalLocation).
     */
    public void testInvalidTargetClass() throws Exception {
        boolean caught = false;
        try {
            GridIdRangeQuery query = new GridIdRangeQuery();
            query.setBigId("hdl://2500.1.PMEUQUCCL5/WX2PXQD7PB");
            appService.search(SNP.class, query);
        }
        catch (ApplicationException e) {
            assertTrue(e.getMessage().contains("must extend"));
            caught = true;
        }

        assertTrue("Illegal target class was allowed",caught);
    }

    /**
     * Ensure that the API throws the appropriate exception if the feature
     * is an invalid class (i.e. does not have a physicalLocationCollection).
     */
    public void testInvalidFeatureClass() throws Exception {
        boolean caught = false;
        try {
            FeatureRangeQuery query = new FeatureRangeQuery();
            query.setFeature(new Taxon());
            appService.search(PhysicalLocation.class, query);
        }
        catch (ApplicationException e) {
            assertTrue(e.getMessage().contains("physicalLocationCollection"));
            caught = true;
        }
        
        assertTrue("Illegal feature class was allowed",caught);
    }
    
    /**
     * Test query for SNPs relative to the given big id of a feature.
     */
    public void testGridQueryWithRelativeSNPs() throws Exception {

        // Transcript 2986605
        String bigId = "hdl://2500.1.PMEUQUCCL5/ZVOGFO5WSV";
        
        GridIdRangeQuery query = new GridIdRangeQuery();
        query.setBigId(bigId);
        query.setAllowPartialMatches(true);
        query.setUpstreamDistance(new Long(1000));
        query.setDownstreamDistance(new Long(0));
        List<SNPPhysicalLocation> results = appService.search(
                SNPPhysicalLocation.class, query);

        assertTrue("Expected at least 5 SNPs",results.size()>5);
    }

    /**
     * Test feature query vs the same query with its physical location.
     * If the feature has only one physical location the results should be 
     * identical.
     */
    public void testFeatureVsLocation() throws Exception {

        // Transcript 2986605
        String bigId = "hdl://2500.1.PMEUQUCCL5/ZVOGFO5WSV";
        Transcript transcript = (Transcript)appService.getDataObject(bigId);
        assertNotNull(transcript);
        
        FeatureRangeQuery query = new FeatureRangeQuery();
        query.setFeature(transcript);
        query.setUpstreamDistance(new Long(2000));
        query.setDownstreamDistance(new Long(0));
        List<SNPPhysicalLocation> results1 = appService.search(
                SNPPhysicalLocation.class, query);

        assertTrue("Expected at least 12 SNPs",results1.size()>11);
        
        // switch to using the location directly
        PhysicalLocation location = 
            transcript.getPhysicalLocationCollection().iterator().next();
        query.setFeature(location);
        List<SNPPhysicalLocation> results2 = appService.search(
                SNPPhysicalLocation.class, query);

        assertTrue("Expected at least 12 SNPs",results2.size()>11);
        
        // compare results
        
        for(SNPPhysicalLocation l1 : results1) {
            boolean found = false;
            for(SNPPhysicalLocation l2 : results2) {
                if (l2.getId().equals(l1.getId())) {
                    found = true;
                }
            }    
            assertTrue("Results not identical",found);
        }
    }
    
    /**
     * Test a range query for exon reporters around a specified SNP.
     */
    public void testFeatureQuery() throws Exception {
        
        SNP snp = new SNP();
        snp.setDBSNPID("rs10873500");
        List snps = appService.search(SNP.class, snp);
        
        assertNotNull(snps);
        assertEquals(1, snps.size());
        snp = (SNP)snps.get(0);
        
        FeatureRangeQuery query = new FeatureRangeQuery();
        query.setFeature(snp);
        query.setUpstreamDistance(new Long(4000));
        query.setDownstreamDistance(new Long(0));
        List<ArrayReporterPhysicalLocation> results = appService.search(
            ArrayReporterPhysicalLocation.class, query);

        assertEquals(5,results.size());
    }

    /**
     * Test a feature query, with a physical location as the feature.
     */
    public void testPhysicalLocationQuery() throws Exception {
        
        SNP snp = new SNP();
        snp.setDBSNPID("rs10873500");
        List locations = appService.search(SNPPhysicalLocation.class, snp);
        
        assertNotNull(locations);
        assertTrue("Expected at least 2 SNP locations",locations.size()>1);
        
        PhysicalLocation location = null;
        for(Object o : locations) {
            PhysicalLocation lo = (PhysicalLocation)o;
            if ("reference".equals(lo.getAssembly())) location = lo;
        }
        
        FeatureRangeQuery query = new FeatureRangeQuery();
        query.setFeature(location);
        query.setUpstreamDistance(new Long(4000));
        query.setDownstreamDistance(new Long(0));
        List<ArrayReporterPhysicalLocation> results = appService.search(
            ArrayReporterPhysicalLocation.class, query);

        assertEquals(5,results.size());
    }
    
    /**
     * Get all features that overlap the sequence BX481253.
     */
    public void testSequencePartialMatches() throws Exception {
        
        GridIdRangeQuery query = new GridIdRangeQuery();
        // NucleicAcidSequence BX481253    
        query.setBigId("hdl://2500.1.PMEUQUCCL5/4VJ7VQKELQ");
        query.setAllowPartialMatches(true);
        List<PhysicalLocation> results = appService.search(query);

        int t=0, n=0, e=0, s=0;
        for(PhysicalLocation location : results) {
            if (location instanceof TranscriptPhysicalLocation) {
                t++;
            }
            else if (location instanceof NucleicAcidPhysicalLocation) {
                n++;
            }
            else if (location instanceof ArrayReporterPhysicalLocation) {
                e++;
            }
            else if (location instanceof SNPPhysicalLocation) {
                s++;
            }
        }
        
        assertTrue("Expected at least 1 transcript", t>=1);
        assertTrue("Expected at least 1 sequence", n>=1);
        assertTrue("Expected at least 1 exon reporter", e>=1);
        assertTrue("Expected at least 2 SNPs", s>=2);
    }
    /**
     * Get all sequences that are overlap Brca1, and all sequences that are 
     * contained inside Brca1's range. The former should have more sequences
     * than the latter. This also tests to ensure the new Gene physical
     * locations are present.
     */
    public void testGenePartialMatches() throws Exception {
        
        GridIdRangeQuery query = new GridIdRangeQuery();
        // Gene SP3 (366 > 341 sequence locations)
        query.setBigId("hdl://2500.1.PMEUQUCCL5/WJDTXHO2CS");
        List<PhysicalLocation> containedResults = appService.search(
            NucleicAcidPhysicalLocation.class, query);

        query.setAllowPartialMatches(true);
        List<PhysicalLocation> partialResults = appService.search(
            NucleicAcidPhysicalLocation.class, query);
        
        assertFalse("containedResults empty",containedResults.isEmpty());
        assertFalse("partialResults empty",partialResults.isEmpty());

        assertTrue("Expected more partial than contained results.",
            partialResults.size()>containedResults.size());
    }
    
    /**
     * Test an absolute location query.
     */
    public void testAbsoluteQuery() throws Exception {

        Taxon taxon = new Taxon();
        taxon.setAbbreviation("Hs");
        Chromosome chromosome = new Chromosome();
        chromosome.setNumber("1");
        chromosome.setTaxon(taxon);
        chromosome = (Chromosome)appService
                .search(Chromosome.class, chromosome).iterator().next();       
        
        AbsoluteRangeQuery query = new AbsoluteRangeQuery();
        query.setAssembly("reference");
        query.setChromosomeId(chromosome.getId());
        query.setStart(new Long(109433764));
        query.setEnd(new Long(109433982));
        List results = appService.search(query);
        
        assertTrue("Expected at least 3 results in this range",
            results.size()>=3);
    }
    

    /**
     * Test an absolute location query but using a chromosome object instead 
     * of just an id.
     */
    public void testQueryChromosomeObject() throws Exception {

        Taxon taxon = new Taxon();
        taxon.setAbbreviation("Hs");
        Chromosome chromosome = new Chromosome();
        chromosome.setNumber("1");
        chromosome.setTaxon(taxon);
        chromosome = (Chromosome)appService
                .search(Chromosome.class, chromosome).iterator().next();
        
        AbsoluteRangeQuery query = new AbsoluteRangeQuery();
        query.setAssembly("reference");
        query.setChromosome(chromosome);
        query.setStart(new Long(109433764));
        query.setEnd(new Long(109433982));
        List results = appService.search(query);
        
        assertTrue("Expected at least 3 results in this range",
            results.size()>=3);
    }
    
    public static void main(String[] argv) throws Exception {
        RangeQueryTest test = new RangeQueryTest();
        test.setUp();
        test.testGridQueryWithRelativeSNPs();
        test.testFeatureVsLocation();
    }

}
