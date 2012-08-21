package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.common.util.SVGManipulator;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import junit.framework.TestCase;

/**
 * Tests for the SVGManipulator utility class that allows end users to 
 * manipulate caBIO protein images.   
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class SVGTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
   
    private static final String GENE_URL = 
        "http://127.0.0.1:8080/cabio40/GetHTML?query=Gene&amp;GeneAlias[@name=%%]";
    
    /**
     * Test disabling of all gene nodes in pathway "h_freePathway".
     */
    public void testDisableGenes() throws Exception {
                
        Pathway pw = new Pathway();
        pw.setName("h_freePathway");
        List results = appService.search(Pathway.class, pw);
        
        assertNotNull(results);
        assertTrue((results.size() == 1));
        
        Pathway returnedPw = (Pathway) results.get(0);
        SVGManipulator svgM = new SVGManipulator(returnedPw);

        String s1 = svgM.getSvgString();
        
        svgM.reset();
        svgM.disableAllGenes();

        String s2 = svgM.getSvgString();
        
        int s1o = countOccurrences(s1,"<g nci_cmap:objectName");
        int s1t = countOccurrences(s1,"#TransparentFilter");
        int s2o = countOccurrences(s2,"<g nci_cmap:objectName");
        int s2t = countOccurrences(s2,"#TransparentFilter");
        
        // number of objects stays the same
        assertEquals(s1o,s2o);
        
        // no disabled objects at first
        assertEquals(0,s1t);

        // all objects disabled
        assertEquals(s2o,s2t);
    }
    
    /**
     * Test disabling of all nodes in pathway "h_egfPathway".
     */
    public void testDisableNodes() throws Exception {
        
        Pathway pw = new Pathway();
        pw.setName("h_egfPathway");
        List results = appService.search(Pathway.class, pw);
        
        assertNotNull(results);
        assertTrue((results.size() == 1));
        
        Pathway returnedPw = (Pathway) results.get(0);
        SVGManipulator svgM = new SVGManipulator(returnedPw);

        String s1 = svgM.getSvgString();
        
        svgM.reset();
        svgM.disableAllNodes();

        String s2 = svgM.getSvgString();
        
        int s1o = countOccurrences(s1,"<g nci_cmap:objectName");
        int s1t = countOccurrences(s1,"#TransparentFilter");
        int s2o = countOccurrences(s2,"<g nci_cmap:objectName");
        int s2t = countOccurrences(s2,"#TransparentFilter");

        // number of objects stays the same
        assertEquals(s1o,s2o);

        // no disabled objects at first
        assertEquals(0,s1t);

        // at least disable all the genes, maybe more nodes
        assertTrue(s2t>=s1o);
    }

    /**
     * Test changing gene colors in different ways in pathway "h_freePathway".
     * In particular, SOD1 and TNF are colored and then reset.  
     */
    public void testGeneColors() throws Exception {

        Pathway pw = new Pathway();
        pw.setName("h_freePathway");
        List results = appService.search(Pathway.class, pw);
        
        assertNotNull(results);
        assertTrue((results.size() == 1));
        
        Pathway returnedPw = (Pathway) results.get(0);
        SVGManipulator svgM = new SVGManipulator(returnedPw);
        
        // Reset SVG diagram to it's Original state and change
        // the display colors for each gene
        svgM.reset();
        Gene[] genes = new Gene[2];
        String[] colors = new String[2];

        Gene gene1 = new Gene();
        gene1.setClusterId(new Long(443914));
        gene1.setSymbol("SOD1");
        List resultList1 = appService.search(Gene.class, gene1);
        assertTrue(resultList1.size() > 0);
        genes[0] = (Gene) resultList1.get(0);

        Gene gene2 = new Gene();
        gene2.setClusterId(new Long(241570));
        gene2.setSymbol("TNF");
        List resultList2 = appService.search(Gene.class, gene2);
        assertTrue(resultList2.size() > 0);
        genes[1] = (Gene) resultList2.get(0);

        colors[0] = "255,50,50";
        colors[1] = "0,255,255";
        svgM.setSvgColors(genes, colors);
        
        // Retrieve Color for each Gene
        assertEquals(colors[0], svgM.getSvgColor(genes[0]));
        assertEquals(colors[1], svgM.getSvgColor(genes[1]));
        
        svgM.reset();

        // Change the color of a Gene in the SVG diagram
        Map geneColors = new HashMap();
        geneColors.put("nfkb", "0,255,255");
        geneColors.put("gpx", "0,255,255");
        svgM.setSvgColors(geneColors);
    }

    /**
     * Tests setting a URL for genes in the "h_WNVpathway" pathway.
     */
    public void testGeneInfoLocation() throws Exception {

        Pathway pw = new Pathway();
        pw.setName("h_WNVpathway");
        List results = appService.search(Pathway.class, pw);
        
        assertNotNull(results);
        assertTrue((results.size() == 1));
        
        Pathway returnedPw = (Pathway) results.get(0);
        SVGManipulator svgM = new SVGManipulator(returnedPw);
        
        svgM.setGeneInfoLocation(GENE_URL);
            
        String s = svgM.getSvgString();
        assertTrue(s.contains(GENE_URL.substring(0, GENE_URL.indexOf("%%"))));
    }

    /**
     * Taken from http://www.dreamincode.net/code/snippet901.htm
     */
    private int countOccurrences(String arg1, String arg2) {
         int count = 0;
         int index = 0;
         while ((index = arg1.indexOf(arg2, index)) != -1) {
              ++index;
              ++count;
         }
         return count;
    }
}
