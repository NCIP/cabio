package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Marker;
import gov.nih.nci.cabio.domain.MarkerRelativeLocation;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.util.List;

import junit.framework.TestCase;

/**
 * Tests for UniSTS-based Marker modeling introduced in 4.1. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class MarkerTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
    
    /**
     * Tests a few cases of the Unigene Gene/Marker association. Expects a 
     * certain minimum number of markers for each of these genes: 
     * Hs.2, Hs.4, Hs.239, Hs.753
     */
    public void testGeneMarker() throws Exception {
        
        Gene gene = new Gene();
        gene.setBigid("hdl://2500.1.PMEUQUCCL5/HEGOZJZIY3"); // Hs.2
        List resultList = appService.search(Marker.class, gene);
        assertTrue("Expected 2 or more markers for Hs.2", resultList.size()>=2);
        
        gene.setBigid("hdl://2500.1.PMEUQUCCL5/S344L2X73O"); // Hs.4
        resultList = appService.search(Marker.class, gene);
        assertTrue("Expected 5 or more markers for Hs.4", resultList.size()>=5);

        gene.setBigid("hdl://2500.1.PMEUQUCCL5/O4I62MUTC4"); // Hs.239
        resultList = appService.search(Marker.class, gene);
        assertTrue("Expected 3 or more markers for Hs.239", resultList.size()>=3);

        gene.setBigid("hdl://2500.1.PMEUQUCCL5/LL4X4DAASZ"); // Hs.753
        resultList = appService.search(Marker.class, gene);
        assertTrue("Expected 1 or more markers for Hs.753", resultList.size()>=1);
    }

    /**
     * Tests marker physical locations. Expects at least 2 locations for 
     * UniSTS marker 54375, one from reference assembly and one from Celera.
     */
    public void testMarkerPhysicalLocations() throws Exception {
        
        Marker marker = new Marker();
        marker.setGeneticMarkerId("54375");
        List<Marker> resultList = appService.search(Marker.class, marker);
        assertEquals("Marker",1,resultList.size());
        marker = resultList.get(0);
        
        boolean reference = false;
        boolean celera = false;
        
        for(PhysicalLocation pl : marker.getPhysicalLocationCollection()) {
            if ("reference".equals(pl.getAssembly())) reference = true;
            if ("Celera".equals(pl.getAssembly())) celera = true;
        }
        
        assertTrue("Expected reference location",reference);
        assertTrue("Expected Celera location",celera);
    }
    
    /**
     * Tests deCODE genetic map with UniSTS source for Markers. Expects two
     * markers (D16S519, D16S3047) for deCODE relative location for SNP 
     * rs8059633. 
     */
    public void testDecodeMap() throws Exception {
        
        // get the deCODE relative location
        MarkerRelativeLocation mrl = new MarkerRelativeLocation();
        mrl.setBigid("hdl://2500.1.PMEUQUCCL5/UT6EOSKUKJ");
        List<MarkerRelativeLocation> resultList = 
            appService.search(MarkerRelativeLocation.class, mrl);
        assertEquals("MarkerRelativeLocation",1,resultList.size());
        mrl = resultList.get(0);
        
        // ensure it has 2 markers
        boolean found1 = false;
        boolean found2 = false;
        for(Marker marker : mrl.getMarkerCollection()) {
            if ("D16S519".equals(marker.getName())) found1 = true;
            if ("D16S3047".equals(marker.getName())) found2 = true;
        }
        
        assertTrue("D16S519 not found",found1);
        assertTrue("D16S3047 not found",found2);
    }
    
    /**
     * Tests SLM1 genetic map with UniSTS source for Markers. Expects two
     * markers (TSC933197, D16S519) for SLM1 relative location for SNP 
     * rs2719712. One is a TSC SNP and one is a UniSTS marker.
     */
    public void testSLM1Map() throws Exception {
        
        // get the SLM1 relative location
        MarkerRelativeLocation mrl = new MarkerRelativeLocation();
        mrl.setBigid("hdl://2500.1.PMEUQUCCL5/H6TJCWTPS7");
        List<MarkerRelativeLocation> resultList = 
            appService.search(MarkerRelativeLocation.class, mrl);
        assertEquals("MarkerRelativeLocation",1,resultList.size());
        mrl = resultList.get(0);
        
        // ensure it has 2 markers
        boolean found1 = false;
        boolean found2 = false;
        for(Marker marker : mrl.getMarkerCollection()) {
            if ("933197".equals(marker.getGeneticMarkerId()) && 
                    "TSC".equalsIgnoreCase(marker.getType())) found1 = true;
            if ("D16S519".equals(marker.getName()) && 
                    "UNISTS".equalsIgnoreCase(marker.getType())) found2 = true;
        }
        
        assertTrue("933197 not found",found1);
        assertTrue("D16S519 not found",found2);
    }
    
    /**
     * Tests microsatellite mapping with UniSTS source for Markers. Expects a
     * single marker (D16S2640) for downstream microsatellite relative location 
     * for SNP rs12599908.
     */
    public void testMicrosatellite() throws Exception {

        // get the relative location
        MarkerRelativeLocation mrl = new MarkerRelativeLocation();
        mrl.setBigid("hdl://2500.1.PMEUQUCCL5/YTDAKZIF6H");
        List<MarkerRelativeLocation> resultList = 
            appService.search(MarkerRelativeLocation.class, mrl);
        assertEquals("MarkerRelativeLocation",1,resultList.size());
        mrl = resultList.get(0);

        // ensure it has its marker
        assertEquals("markerCollection",1,mrl.getMarkerCollection().size());
        boolean found = false;
        for(Marker marker : mrl.getMarkerCollection()) {
            if ("D16S2640".equals(marker.getName()) && 
                    "UNISTS".equalsIgnoreCase(marker.getType())) found = true;
        }
        
        assertTrue("Microsatellite marker not found",found);
    }
}
