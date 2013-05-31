/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import junit.framework.TestCase;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.URI;
import org.apache.commons.httpclient.methods.GetMethod;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.w3c.dom.Document;
import org.xml.sax.InputSource;


/**
 * Unit tests for the REST API (a.k.a. HTTP-XML API), concentrating on the 
 * pagination aspects.
 */
public class RESTAPITest extends TestCase {

    private static String GET_XML_URL;

    private static final XPathFactory factory = XPathFactory.newInstance();
    private static final XPath xpath = factory.newXPath();
    
    private static final String RANGE_QUERY_BASE = "query=AbsoluteRangeQuery&AbsoluteRangeQuery[@chromosomeId=19][@start=34000000][@end=34200000]";
    
    static {
        // attempt to get the right URL from the Java client configuration
        ApplicationContext ctx = 
            new ClassPathXmlApplicationContext("application-config-client.xml");
        GET_XML_URL = (String) ctx.getBean("RemoteServerURL") + "/GetXML?";
        System.out.println("REST URL: "+GET_XML_URL);
    }
    
    public void testCytobandFirstPage() throws Exception {
        String query = "query=Cytoband&Cytoband";
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("1",getValue(doc, "//queryResponse/start"));
        assertEquals("200",getValue(doc, "//queryResponse/end"));
    }
    
    public void testCytobandSecondPage() throws Exception {
        String query = "query=Cytoband&Cytoband&startIndex=200&pageSize=200";
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("201",getValue(doc, "//queryResponse/start"));
        assertEquals("400",getValue(doc, "//queryResponse/end"));
    }

    public void testCytobandChunkBorder() throws Exception {
        String query = "query=Cytoband&Cytoband&startIndex=900&pageSize=200";
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("901",getValue(doc, "//queryResponse/start"));
        assertEquals("1100",getValue(doc, "//queryResponse/end"));
    }

    public void testCytoband() throws Exception {
        String query = "query=Cytoband&Cytoband&startIndex=900&pageSize=200";
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("901",getValue(doc, "//queryResponse/start"));
        assertEquals("1100",getValue(doc, "//queryResponse/end"));
    }
    
    public void testRangeQueryFirstPage() throws Exception {
        String query = RANGE_QUERY_BASE;
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("1",getValue(doc, "//queryResponse/start"));
        assertEquals("200",getValue(doc, "//queryResponse/end"));
    }
    
    /**
     * Test for GF14559: 
     * "Overflow error on "next" page of large result set (from range query)"
     */
    public void testRangeQuerySecondPage() throws Exception {
        String query = RANGE_QUERY_BASE+"&startIndex=200&pageSize=200";
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("201",getValue(doc, "//queryResponse/start"));
        assertEquals("400",getValue(doc, "//queryResponse/end"));
    }

    /**
     * Test for GF16868:
     * "Support for pagination with Range Query API"
     */
    public void testRangeQueryChunkBorder() throws Exception {
        String query = RANGE_QUERY_BASE+"&startIndex=900&pageSize=200";
        Document doc = getXML(query);
        assertEquals(query,getValue(doc, "//queryRequest/query/queryString"));
        assertEquals("901",getValue(doc, "//queryResponse/start"));
        assertEquals("1100",getValue(doc, "//queryResponse/end"));
    }
    
    /**
     * Returns the text value of the nodes at the given XPath.
     */
    private String getValue(Document doc, String path) throws Exception {
        XPathExpression expr = xpath.compile(path);
        Object result = expr.evaluate(doc, XPathConstants.STRING);
        return (String)result;
    }

    /**
     * Queries the REST API with the given query string and parses the resulting
     * XML into a DOM document.
     */
    private Document getXML(String query) throws Exception {
        URI uri = new URI(GET_XML_URL+"?"+query, false);
        HttpClient client = new HttpClient();
        HttpMethod method = new GetMethod();
        method.setURI(uri);
        client.executeMethod(method);
        InputSource inputSource = new InputSource(method.getResponseBodyAsStream());
        DocumentBuilderFactory domFactory = DocumentBuilderFactory.newInstance();
        domFactory.setNamespaceAware(true); 
        DocumentBuilder builder = domFactory.newDocumentBuilder();
        return builder.parse(inputSource);
    }
}
