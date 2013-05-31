/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.common.domain.DatabaseCrossReference;
import gov.nih.nci.common.util.XMLUtility;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.io.StringReader;
import java.io.StringWriter;
import java.util.Iterator;
import java.util.List;

import junit.framework.TestCase;

/**
 * Tests the XMLUtility class by serializing and then deserializing various
 * objects. The original is validated against the deserialized object for 
 * consistency.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class XMLTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
   
    /**
     * Test marshalling of Gene brca2. Ensure unmarshalled object has identical
     * attributes values to the original.
     */
    public void testMarshalGene() throws Exception {
        
		Gene gene = new Gene();
		gene.setSymbol("brca2");
		List results = appService.search(Gene.class, gene);
        assertNotNull(results);
        assertTrue((results.size() > 0));
        
		for (Iterator iterator = results.iterator(); iterator.hasNext();) {                 
            Gene dbObj = (Gene) iterator.next();
            Gene xmlObj = (Gene)marshallUnmarshall(dbObj);
            assertEquals(dbObj.getBigid(),xmlObj.getBigid());
            assertEquals(dbObj.getFullName(),xmlObj.getFullName());
            assertEquals(dbObj.getClusterId(),xmlObj.getClusterId());
            assertEquals(dbObj.getSymbol(),xmlObj.getSymbol());
        }
    }

    /**
     * Test marshalling of SNP rs340863. Ensure unmarshalled object has 
     * identical attributes values to the original.
     */
    public void testMarshalSNP() throws Exception {

        
        SNP snp = new SNP();
        snp.setDBSNPID("rs340863");
  
        List results = appService.search(SNP.class, snp);
        assertNotNull(results);
        assertTrue((results.size() > 0));
        
        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            SNP dbObj = (SNP) iterator.next();
            SNP xmlObj = (SNP) marshallUnmarshall(dbObj);
            assertEquals(dbObj.getBigid(),xmlObj.getBigid());
            assertEquals(dbObj.getId(),xmlObj.getId());
            assertEquals(dbObj.getFlank(),xmlObj.getFlank());
        }
	}

    /**
     * Test marshalling of DatabaseCrossReference TSC0045803. Ensure 
     * unmarshalled object has identical attributes values to the original.
     * 
     * Historically this had trouble with the SNP association because the 
     * association name was the same as the class name. This was fixed in SDK
     * by forcing the name to lowercase if it matches the class name. 
     */
    public void testMarshalDatabaseCrossReference() throws Exception {

        DatabaseCrossReference dbxr = new DatabaseCrossReference();
        dbxr.setCrossReferenceId("TSC0045803");
  
        List results = appService.search(DatabaseCrossReference.class, dbxr);
        assertNotNull(results);
        assertTrue((results.size() > 0));
        
        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            DatabaseCrossReference dbObj = (DatabaseCrossReference) iterator.next();
            DatabaseCrossReference xmlObj = (DatabaseCrossReference) marshallUnmarshall(dbObj);
            assertEquals(dbObj.getCrossReferenceId(),xmlObj.getCrossReferenceId());
            assertEquals(dbObj.getDataSourceName(),xmlObj.getDataSourceName());
        }
    }
    
    /**
     * Marshall the given object into an XML string then unmarshall it back 
     * into an object to return. 
     * 
     * @param obj Object to marshall
     * @return The unmarshalled object
     * @throws Exception
     */
    private Object marshallUnmarshall(Object obj) throws Exception {

        XMLUtility myUtil = new XMLUtility();
        
        StringWriter sw = new StringWriter();
        myUtil.toXML(obj, sw);
        //System.out.println(sw.getBuffer().toString());
        StringReader sr = new StringReader(sw.getBuffer().toString());
        
        // TODO: this validation currently does not work because the
        // schemas are split between multiple files. Everything is 
        // imported correct though, and Eclipse validates correctly.

//        DocumentBuilder parser = 
//            DocumentBuilderFactory.newInstance().newDocumentBuilder();
//        Document document = parser.parse(new InputSource(sr));
//        SchemaFactory factory = 
//            SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
//                
//        Source schemaFile = new StreamSource(
//            Thread.currentThread().getContextClassLoader().getResourceAsStream(
//                obj.getClass().getPackage().getName() + ".xsd"));
//        Schema schema = factory.newSchema(schemaFile);
//        
//        Validator validator = schema.newValidator();
//        validator.validate(new DOMSource(document));
        
        return myUtil.fromXML(sr);
    }
    
}