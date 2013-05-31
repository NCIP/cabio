/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cagrid.cabio.test;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Protein;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.cabio.domain.NucleicAcidSequence;
import gov.nih.nci.cabio.pathways.PhysicalEntity;
import gov.nih.nci.cabio.pathways.ProteinEntity;
import gov.nih.nci.cabio.pathways.FamilyMember;
import gov.nih.nci.cabio.pathways.ComplexComponent;
import gov.nih.nci.cagrid.cabio.client.CaBIO42GridSvcClient;
import gov.nih.nci.cagrid.common.Utils;
import gov.nih.nci.cagrid.cqlquery.CQLQuery;
import gov.nih.nci.cagrid.cqlquery.Association;
import gov.nih.nci.cagrid.cqlquery.Attribute;
import gov.nih.nci.cagrid.cqlresultset.CQLQueryResults;
import gov.nih.nci.cagrid.data.DataServiceConstants;
import gov.nih.nci.cagrid.data.utilities.CQLQueryResultsIterator;
import gov.nih.nci.common.domain.DatabaseCrossReference;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.StringWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.xml.XMLConstants;
import javax.xml.namespace.QName;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.Source;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.w3c.dom.Document;

/**
 * 
 * @version $Revision: 1.1 $
 * @author Jim Sun
 * 
 */
public class CaBIOClientTestCase extends TestCase {
	static private String  s_GridSvcUrl = "http://localhost:8080/wsrf/services/cagrid/CaBIO42GridSvc"; 
	//static private String  s_GridSvcUrl = "http://cabiogrid42-dev.nci.nih.gov/wsrf/services/cagrid/CaBIO42GridSvc";
	private CaBIO42GridSvcClient gridSvcClient;

	public CaBIOClientTestCase() {

	}

	public CaBIOClientTestCase(String name) {
		super(name);
	}

	public void setUp() {				
		try {
			gridSvcClient = new CaBIO42GridSvcClient(s_GridSvcUrl);
		} catch (Exception ex) {
			ex.printStackTrace();
		}			
	}

	/**
	 * Compares Java client with Grid client.
	 * 
	 */
	public void testGetGenesByDBXRef() {
		// Get gene from grid service
		List gGeneList = new ArrayList();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"resources/gene1.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);
			CQLQueryResultsIterator iterator = getIterator(results, Gene.class.getName());
			
			while (iterator.hasNext()) 
			{
				Gene gene = (Gene)iterator.next();
				gGeneList.add(gene);
				System.out.println("Gene Id: " + gene.getId());
			}

			int numGGenes = gGeneList.size();
			assertTrue("No genes retrieved", numGGenes > 0);
			
		} catch (Exception ex) {
			ex.printStackTrace();
			fail("Failed to query grid service for genes: " + ex.getMessage());
		}
	}

	public void testGetTaxonByGene() {
		System.out.println("============= testGetTaxonByGene =======================================");
		// Get gene from grid service
		List gXRefList = new ArrayList();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/TaxonGeneAssoc.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);									
			CQLQueryResultsIterator iterator = getIterator(results, null);
			
			while (iterator.hasNext()) {
				gXRefList.add(iterator.next());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		for (Iterator i = gXRefList.iterator(); i.hasNext();) {
			Taxon x = (Taxon) i.next();
			System.out.println("testGetTaxonByGene Taxon Id: " + x.getId());
		}
	}
	
	public void testGetDBXRefsByGene() {
		System.out.println("================= testGetDBXRefsByGene ===============================");		
		// Get gene from grid service
		List gXRefList = new ArrayList();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/dbxref1.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);
			CQLQueryResultsIterator iterator = new CQLQueryResultsIterator(
					results,
					new FileInputStream(
							"src/gov/nih/nci/cagrid/cabio/client/client-config.wsdd"));
			
			while (iterator.hasNext()) {
				gXRefList.add(iterator.next());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
			//fail("Failed to query grid service for xrefs: " + ex.getMessage());
		}
		int numGXRefs = gXRefList.size();
		//assertTrue("No xrefs retrieved", numGXRefs > 0);
		
		//Map map = new HashMap();
		for (Iterator i = gXRefList.iterator(); i.hasNext();) {
			DatabaseCrossReference x = (DatabaseCrossReference) i.next();
			System.out.println("testGetDBXRefsByGene DCR Id: " + x.getId());
			//map.remove(x.getId());
		}
		//assertTrue("Different xrefs retrieved", map.size() == 0);
	}

	public void testNASAsBaseClass() {
		System.out.println("============= testNASAsBaseClass =======================================");
		// Get gene from grid service
		List nasList = new ArrayList();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/nas.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);									
			CQLQueryResultsIterator iterator = getIterator(results, null);
			
			while (iterator.hasNext()) {
				nasList.add(iterator.next());
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}

		for (Iterator i = nasList.iterator(); i.hasNext();) {
			NucleicAcidSequence x = (NucleicAcidSequence) i.next();
			System.out.println("testNASAsBaseClass NucleicAcidSequence Id: " + x.getId());
		}
	}
	
	public void testValidXml() {
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/query_1.xml", CQLQuery.class);
			CQLQueryResults results = this.gridSvcClient.query(query);
			
			StringWriter w = new StringWriter();
			Utils
					.serializeObject(
							results,
							DataServiceConstants.CQL_RESULT_SET_QNAME, w);			
			System.out.println(w.getBuffer());			
			
			CQLQueryResultsIterator iterator = new CQLQueryResultsIterator(
					results,
					new FileInputStream(
							"src/gov/nih/nci/cagrid/cabio/client/client-config.wsdd"));
			
			DocumentBuilderFactory df = DocumentBuilderFactory.newInstance();
			df.setNamespaceAware(true);
			DocumentBuilder parser = df.newDocumentBuilder();
			
			while (iterator.hasNext()) {
				Gene gene = (Gene) iterator
						.next();
				StringWriter w2 = new StringWriter();
				Utils
						.serializeObject(
								gene,
								new QName(
										"gme://caCORE.caBIO/4.0/gov.nih.nci.cabio.domain",
										"Gene"),								
								w2,
								new FileInputStream(
										"src/gov/nih/nci/cagrid/cabio/client/client-config.wsdd"));
				
				//System.out.println(w2.getBuffer());											
				Document document = parser.parse(new ByteArrayInputStream(w2
						.getBuffer().toString().getBytes()));
				document.getDocumentElement().setAttribute("xmlns:xsi", "http://www.w3.org/2001/XMLSchema-instance");
				//document.getDocumentElement().setAttribute("xsi:schemaLocation", "gme://caCORE.caCORE/3.2/gov.nih.nci.cabio.domain file:///C:/temp/caGridTest/TestSvc/CaBIO32GridSvc/schema/CaBIO32GridSvc/gov.nih.nci.cabio.domain.xsd");
				
				SchemaFactory factory = SchemaFactory
						.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
				Source schemaFile = new StreamSource(new File(
						"schema/CaBIO40GridSvc/gov.nih.nci.cabio.domain.xsd"));
				Schema schema = factory.newSchema(schemaFile);
				Validator validator = schema.newValidator();
				validator.validate(new DOMSource(document));
			}
			System.out.println("The QueryResult XML validation successful!!!");
		} catch (Exception ex) {
			ex.printStackTrace();
			fail("Error encountered: " + ex.getMessage());
		}
	}

	/**
	 * Compares Java client with Grid client.
	 * 
	 */
	public void testGetProteinByIDs() {
		// Get gene from grid service
		List proteinList = new ArrayList();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/protein1.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);
			CQLQueryResultsIterator iterator = getIterator(results, Protein.class.getName());
			
			while (iterator.hasNext()) 
			{
				Protein protein = (Protein)iterator.next();
				proteinList.add(protein);
				System.out.println("Protein Id: " + protein.getId());
			}

			int num = proteinList.size();
			assertTrue("No proteins retrieved", num > 0);
			
		} catch (Exception ex) {
			ex.printStackTrace();
			fail("Failed to query grid service for proteins: " + ex.getMessage());
		}
	}

	/**
	 * Test PID data: retrieve the Entity Names.
	 * 
	 */
	public void testGetPhysicalEntities() {
		System.out.println("================= testGetPhysicalEntities ===============================");		
		// Get gene from grid service
		List<PhysicalEntity> peList = new ArrayList<PhysicalEntity>();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/PhysicalEntity-EntitynameAssoc.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);

			CQLQueryResultsIterator iterator = getIterator(results, ProteinEntity.class.getName());
			
			PhysicalEntity pe = null; 
			while (iterator.hasNext()) 
			{
				pe = (PhysicalEntity)iterator.next();
				peList.add(pe);
				System.out.println("PhysicalEntity Id: " + pe.getId());
			}
            
			//Collection<FamilyMember> fam = pe.getMemberCollection();
			
			int num = peList.size();
			assertTrue("No PhysicalEntity retrieved", num > 0);
			
			if ( num <=0 )  return;
			
			// now query for protein.getMembersCollection()
			System.out.println("================= testGetPhysicalEntities: ComplexComponent ===============================");			
			List<ComplexComponent> ccList = new ArrayList<ComplexComponent>();
	        query = new gov.nih.nci.cagrid.cqlquery.CQLQuery();
	        gov.nih.nci.cagrid.cqlquery.Object target = new gov.nih.nci.cagrid.cqlquery.Object();
	        
	        target.setName(gov.nih.nci.cabio.pathways.PhysicalParticipant.class.getName());
	        String roleName = "physicalEntity";
	        Association assoc = new Association(roleName);
	        assoc.setName("gov.nih.nci.cabio.pathways.PhysicalEntity");
	        Attribute idAttribute = 
	            new gov.nih.nci.cagrid.cqlquery.Attribute(
	            "id",
	            gov.nih.nci.cagrid.cqlquery.Predicate.EQUAL_TO, pe.getId().toString());
	        assoc.setAttribute(idAttribute);
	        target.setAssociation(assoc);
	        query.setTarget(target);
			
	        results = gridSvcClient.query(query);
			iterator = getIterator(results, ComplexComponent.class.getName()); 

			ComplexComponent cc = null; 
			while (iterator.hasNext()) 
			{
				cc = (ComplexComponent)iterator.next();
				ccList.add(cc);
				System.out.println("ComplexComponent Id: " + cc.getId());
			}
			
		} catch (Exception ex) {
			ex.printStackTrace();
			fail("Failed to query grid service for PID: PhysicalEntity: " + ex.getMessage());
		}
	}

	/**
	 * Test PID data: retrieve the FamilyMember by PhysicalEntity id.
	 * 
	 */
	public void testGetFamilyMembers() {
		System.out.println("================= testGetFamilyMembers ===============================");
		// Get gene from grid service
		List<FamilyMember> peList = new ArrayList<FamilyMember>();
		try {
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"test/resources/FamilyMember-ProteinEntityAssoc.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);

			CQLQueryResultsIterator iterator = getIterator(results, FamilyMember.class.getName());

			FamilyMember fm = null; 
			while (iterator.hasNext()) 
			{
				fm = (FamilyMember)iterator.next();
				peList.add(fm);
				System.out.println("FamilyMember Id: " + fm.getId());
			}

			int num = peList.size();
			
			assertTrue("No FamilyMembers retrieved", num > 0);
			
		} catch (Exception ex) {
			ex.printStackTrace();
			fail("Failed to query grid service for PID: FamilyMembers: " + ex.getMessage());
		}
			
	}
		
	private CQLQueryResultsIterator getIterator(CQLQueryResults results, String targetClassname) throws Exception 
	{
		System.out.println("");
		StringWriter w = new StringWriter();
		Utils.serializeObject(
						results,
						DataServiceConstants.CQL_RESULT_SET_QNAME, w);			
		System.out.println(w.getBuffer());			
		
		if ( targetClassname != null)
		{
		    results.setTargetClassname(targetClassname);
		}
		CQLQueryResultsIterator iterator = new CQLQueryResultsIterator(
				results,
				new FileInputStream(
						"src/gov/nih/nci/cagrid/cabio/client/client-config.wsdd"));	
		
		return iterator;
	}
	
	public static void main(String[] args) {
	    System.out.println("Running the Grid Service Test");
		try{
			if(!(args.length < 2)){
				if(!args[0].equals("-url")){
					usage();
					System.exit(1);
				}
			    s_GridSvcUrl = args[1];  	
				junit.textui.TestRunner.run(suite());				
			} else {
				usage();
				System.exit(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
			System.exit(1);
		}		
	}
	public static void usage(){
		System.out.println(CaBIO42GridSvcClient.class.getName() + " -url <service url>");
	}

	public static Test suite() {
		TestSuite suite = new TestSuite();		
	    suite.addTest(new CaBIOClientTestCase("testGetTaxonByGene"));
		suite.addTest(new CaBIOClientTestCase("testGetDBXRefsByGene"));
	    suite.addTest(new CaBIOClientTestCase("testGetPhysicalEntities"));
	    suite.addTest(new CaBIOClientTestCase("testGetFamilyMembers"));
	    
	    //suite.addTest(new CaBIOClientTestCase("testNASAsBaseClass"));
    	//suite.addTest(new CaBIOClientTestCase("testGetGenesByDBXRef"));
		//suite.addTest(new CaBIOClientTestCase("testValidXml"));	    
		return suite;
	}
}