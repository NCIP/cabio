package gov.nih.nci.cagrid.maservice.test;

import gov.nih.nci.iso21090.St;
import gov.nih.nci.maservice.client.MaGridServiceClient;
import gov.nih.nci.maservice.domain.AgentAssociation;
import gov.nih.nci.maservice.domain.Gene;
import gov.nih.nci.maservice.stubs.types.MolecularAnnotationServiceException;
import gov.nih.nci.maservice.util.GeneSearchCriteria;
import gov.nih.nci.cagrid.common.Utils;
import gov.nih.nci.cagrid.cqlquery.CQLQuery;
import gov.nih.nci.cagrid.cqlresultset.CQLQueryResults;
import gov.nih.nci.cagrid.data.DataServiceConstants;
import gov.nih.nci.cagrid.data.utilities.CQLQueryResultsIterator;

import java.io.FileInputStream;
import java.io.StringWriter;
import java.rmi.RemoteException;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;


public class MaGridServiceTestCase extends TestCase {
	static private String  s_GridSvcUrl = "http://localhost:8080/wsrf/services/cagrid/MaGridService"; 
	//static private String  s_GridSvcUrl = "http://magridservice-dev.nci.nih.gov/wsrf/services/cagrid/MaGridService";
	private MaGridServiceClient gridSvcClient;

	public MaGridServiceTestCase() {

	}

	public MaGridServiceTestCase(String name) {
		super(name);
	}

	public void setUp() {				
		try {
			gridSvcClient = new MaGridServiceClient(s_GridSvcUrl);
			System.out.println("Connected to Grid Service @" + s_GridSvcUrl);
		} catch (Exception ex) {
			ex.printStackTrace();
		}			
	}

	
	/**
	 * Compares Java client with Grid client.
	 * 
	 */
	public void testGetGenesBySymbol() throws Exception
	{
		System.out.println("##################################");
		System.out.println("# test GetGeneBySymbol operation");
		System.out.println("##################################");
		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("Brca1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		Gene[] genes = gridSvcClient.getGenesBySymbol(geneSearchCriteria);
		
		if ( genes!=null && genes.length > 0)
		{
			System.out.println( "Gene Symbol: " + genes[0].getSymbol().getValue()
					            + ", Full Name: " + genes[0].getFullName().getValue());
			getGeneIdentifierCollection(genes[0]); 
		}
	}

	public void testGetAgentAssociation() throws RemoteException
	{
		System.out.println("##################################");
		System.out.println("# test GetAgentAssociation operation");
		System.out.println("##################################");

		GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
		St symbolOrAlias = new St();
		symbolOrAlias.setValue("BRCA1");
		geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
		AgentAssociation[] aas = gridSvcClient.getAgentAssociations(geneSearchCriteria);
		
                
		if ( aas!=null && aas.length > 0)
		{
                       System.out.println("Total found: " + aas.length ); 
     		       System.out.println( "Agent Association: " + aas[0].getSource().getValue());
		}
	}

	public void testGetAgentAssociationWithMAException() throws RemoteException
	{
		try
		{
  		        System.out.println("##################################");
  		        System.out.println("# test testGetAgentAssociationWithMAException");
 		        System.out.println("##################################");

			GeneSearchCriteria geneSearchCriteria = new GeneSearchCriteria();
			St symbolOrAlias = new St();
			symbolOrAlias.setValue("BRCAXXX1");
			geneSearchCriteria.setSymbolOrAlias(symbolOrAlias);
			AgentAssociation[] aas = gridSvcClient.getAgentAssociations(geneSearchCriteria);		
		}
		catch ( Exception e)
		{
			if ( e instanceof MolecularAnnotationServiceException){
				MolecularAnnotationServiceException mae = (MolecularAnnotationServiceException)e;
				System.out.println("MAException throwed as expected: ");
				System.out.println("Message: " + mae.getMessage());
				System.out.println("FaultString: " + mae.getFaultString());
				System.out.println("ErrorCode: " + mae.getErrorCode().get_any()[0].getValue());
				System.out.println("Description: " + mae.getDescription()[0].get_value());
				System.out.println("Originator: " + mae.getOriginator().toString());
			}
			//e.printStackTrace();
		}
	}
	
	public void testQuery() throws RemoteException
	{
		System.out.println("##################################");
		System.out.println("# test Query operation");
		System.out.println("##################################");

		List gList = new ArrayList();
		try
		{
			CQLQuery query = new CQLQuery();
	
			gov.nih.nci.cagrid.cqlquery.Object target = 
			    new gov.nih.nci.cagrid.cqlquery.Object();
			target.setName("gov.nih.nci.maservice.domain.Gene");
			query.setTarget(target);
			            
			gov.nih.nci.cagrid.cqlquery.Association assoc =  
			    new gov.nih.nci.cagrid.cqlquery.Association();
			assoc.setName("gov.nih.nci.iso21090.St");
			assoc.setRoleName("symbol");
			target.setAssociation(assoc);
	
			gov.nih.nci.cagrid.cqlquery.Attribute attr =  
			    new gov.nih.nci.cagrid.cqlquery.Attribute();
			attr.setName("value");
			attr.setValue("BRCA1");
			attr.setPredicate(gov.nih.nci.cagrid.cqlquery.Predicate.LIKE);
			assoc.setAttribute(attr);
			CQLQueryResults results = gridSvcClient.query(query);
								
			CQLQueryResultsIterator iterator = this.getIterator(results, Gene.class.getName());

			int cnt=0;
			while (iterator.hasNext()) {
				Gene x = (Gene) iterator.next();
				System.out.println("testQuery Gene Id: " + x.getId().getExtension() + " Symbol:" + x.getSymbol().getValue() + ", Fullname:"+ x.getFullName().getValue());
				
				if ( cnt == 0 )
				{
					getGeneIdentifierCollection(x);
				}
				cnt++;
			}
		} catch ( Exception ex)
		{
			ex.printStackTrace();
		}
		
	}

	public void testQueryFromXMLFile() throws RemoteException
	{
		System.out.println("##################################");
		System.out.println("# test Query operation from XML File");
		System.out.println("##################################");

		List gList = new ArrayList();
		try
		{	
			CQLQuery query = (CQLQuery) Utils.deserializeDocument(
					"resources/gene.xml", CQLQuery.class);
			CQLQueryResults results = gridSvcClient.query(query);
								
			CQLQueryResultsIterator iterator = this.getIterator(results, Gene.class.getName());

			int cnt=0;
			while (iterator.hasNext()) {
				Gene x = (Gene) iterator.next();
				System.out.println("testQuery Gene Id: " + x.getId().getExtension() + " Symbol:" + x.getSymbol().getValue() + ", Fullname:"+ x.getFullName().getValue());
				
				cnt++;
			}
		} catch ( Exception ex)
		{
			ex.printStackTrace();
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
						"src/gov/nih/nci/cagrid/maservice/client/client-config.wsdd"));	
		
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
	
	private void getGeneIdentifierCollection(Gene gene) throws Exception
	{
	   // for each each, get its associated GeneIdentifiers	
		CQLQuery query = new CQLQuery();
		
		gov.nih.nci.cagrid.cqlquery.Object target = 
		    new gov.nih.nci.cagrid.cqlquery.Object();
		target.setName("gov.nih.nci.maservice.domain.GeneIdentifier");
		query.setTarget(target);

		gov.nih.nci.cagrid.cqlquery.Association associatedGene =  
		    new gov.nih.nci.cagrid.cqlquery.Association();
		associatedGene.setName("gov.nih.nci.maservice.domain.Gene");
		associatedGene.setRoleName("gene");
		target.setAssociation(associatedGene);

		gov.nih.nci.cagrid.cqlquery.Association assocSt =  
		    new gov.nih.nci.cagrid.cqlquery.Association();
		assocSt.setName("gov.nih.nci.iso21090.St");
		assocSt.setRoleName("symbol");
		associatedGene.setAssociation(assocSt);
		
		gov.nih.nci.cagrid.cqlquery.Attribute attr =  
		    new gov.nih.nci.cagrid.cqlquery.Attribute();
		attr.setName("value");
		attr.setValue( gene.getSymbol().getValue());
		attr.setPredicate(gov.nih.nci.cagrid.cqlquery.Predicate.EQUAL_TO);
		assocSt.setAttribute(attr);
		
		CQLQueryResults results = gridSvcClient.query(query);

		StringWriter w = new StringWriter();
		Utils
				.serializeObject(
						results,
						DataServiceConstants.CQL_RESULT_SET_QNAME, w);			
		System.out.println(w.getBuffer());			
		
	}
	
	public static void usage(){
		System.out.println(MaGridServiceClient.class.getName() + " -url <service url>");
	}

	public static Test suite() {
		TestSuite suite = new TestSuite();		
	    suite.addTest(new MaGridServiceTestCase("testGetGenesBySymbol"));
            suite.addTest(new MaGridServiceTestCase("testGetAgentAssociation"));
            suite.addTest(new MaGridServiceTestCase("testGetAgentAssociationWithMAException"));
	    suite.addTest(new MaGridServiceTestCase("testQuery"));
	    suite.addTest(new MaGridServiceTestCase("testQueryFromXMLFile"));
		return suite;
	}
}
