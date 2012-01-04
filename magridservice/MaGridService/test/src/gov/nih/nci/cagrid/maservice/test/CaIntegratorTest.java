package gov.nih.nci.cagrid.maservice.test;

import gov.nih.nci.cagrid.common.Utils;
import gov.nih.nci.cagrid.cqlquery.CQLQuery;
import gov.nih.nci.cagrid.cqlresultset.CQLQueryResults;
import gov.nih.nci.cagrid.data.DataServiceConstants;
import gov.nih.nci.maservice.client.MaGridServiceClient;

import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;

import junit.framework.TestCase;

import org.junit.Test;

/**
 * Tests the MA information model. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CaIntegratorTest extends TestCase {
    
    static private String  s_GridSvcUrl = "http://magridservice-dev.nci.nih.gov/wsrf/services/cagrid/MaGridService";
    private MaGridServiceClient gridSvcClient;

    public CaIntegratorTest() {
    }

    public void setUp() {               
        try {
            gridSvcClient = new MaGridServiceClient(s_GridSvcUrl);
        } catch (Exception ex) {
            ex.printStackTrace();
        }           
    }

    private CQLQuery loadQuery(String filename) throws Exception {
        InputStream in = getClass().getClassLoader().getResourceAsStream(filename);
        InputStreamReader reader = new InputStreamReader(in);
        CQLQuery query = (CQLQuery)Utils.deserializeObject(reader, CQLQuery.class);
        return query;
    }

    private void printCQLResults(CQLQueryResults results) throws Exception {
        StringWriter w = new StringWriter();
        Utils.serializeObject(
                        results,
                        DataServiceConstants.CQL_RESULT_SET_QNAME, w);          
        System.out.println(w.getBuffer());      
    }
    
    @Test
    public void testRetrieveGenesByAlias() throws Exception {
        CQLQuery query = loadQuery("testRetrieveGenesByAlias.cql");
        CQLQueryResults results = gridSvcClient.query(query);
        System.out.println("testRetrieveGenesByAlias");
        printCQLResults(results);
    }
    
    @Test
    public void testRetrieveGenesBySymbol() throws Exception {
        CQLQuery query = loadQuery("testRetrieveGenesBySymbol.cql");
        CQLQueryResults results = gridSvcClient.query(query);
        System.out.println("testRetrieveGenesBySymbol");
        printCQLResults(results);
    }
    
    @Test
    public void testRetrieveGenesByCrossReferenceIdentifier() throws Exception {
        CQLQuery query = loadQuery("testRetrieveGenesByCrossReferenceIdentifier.cql");
        CQLQueryResults results = gridSvcClient.query(query);
        System.out.println("testRetrieveGenesByCrossReferenceIdentifier");
        printCQLResults(results);
    }

    @Test
    public void testRetrieveGenesByKeyword() throws Exception {
        CQLQuery query = loadQuery("testRetrieveGenesByKeyword.cql");
        CQLQueryResults results = gridSvcClient.query(query);
        System.out.println("testRetrieveGenesByKeyword");
        printCQLResults(results);
    }

    @Test
    public void testRetrieveAllTaxons() throws Exception {
        CQLQuery query = loadQuery("testRetrieveAllTaxons.cql");
        CQLQueryResults results = gridSvcClient.query(query);
        System.out.println("testRetrieveAllTaxons");
        printCQLResults(results);
    }


}
