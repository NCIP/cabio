package gov.nih.nci.cabio;

import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.SearchResult;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.List;

import junit.framework.TestCase;

/**
 * Tests the FreestyleLM Search API.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class FreestyleLMTest extends TestCase {

    private final CaBioApplicationService appService = AllTests.getService();
    
    /**
     * Executes a search for the string "12q12" and verifies that the results
     * contains at least one Cytoband object and at least one Evidence object.
     * Checks to ensure the Cytoband.name and Evidence.sentence contain the 
     * query string.
     */
    public void testBasicSearch() throws Exception {
        
        String keyword = "13q12";
        
        SearchQuery searchQuery = new SearchQuery();
        searchQuery.setKeyword(keyword);

        List results = appService.search(searchQuery);
        
        boolean cytobandFound = false;
        boolean evidenceFound = false;
        
        for(Object o : results) {
            SearchResult res = (SearchResult)o;
            if (res.getClassName().endsWith("Cytoband")) {
                cytobandFound = true;
                String value = (String)res.getProperties().get("name");
                assertTrue(value.contains(keyword));
                
            }
            if (res.getClassName().endsWith("Evidence")) {
                evidenceFound = true;
                String value = (String)res.getProperties().get("sentence");
                assertTrue(value.contains(keyword));
            }
        }
        
        assertTrue("No Cytoband objects returned", cytobandFound);
        assertTrue("No Evidence objects returned", evidenceFound);
    }

}