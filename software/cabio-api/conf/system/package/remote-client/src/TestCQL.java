/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.ProteinSequence;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import gov.nih.nci.system.query.cql.CQLAssociation;
import gov.nih.nci.system.query.cql.CQLAttribute;
import gov.nih.nci.system.query.cql.CQLGroup;
import gov.nih.nci.system.query.cql.CQLLogicalOperator;
import gov.nih.nci.system.query.cql.CQLObject;
import gov.nih.nci.system.query.cql.CQLPredicate;
import gov.nih.nci.system.query.cql.CQLQuery;

import java.util.Iterator;
import java.util.List;

/**
 * TestClient.java demonstartes various ways to execute CQL searches using 
 * the Application Service Layer.
 * 
 * @author caBIO Team
 */
public class TestCQL {

	public static void main(String[] args) throws Exception {
		System.out.println("*** TestCQL...");

		ApplicationService appService =
		    ApplicationServiceProvider.getApplicationService();

		// Scenario 1: Using basic search
		// Retrieving Genes based on symbol
		try {
			System.out.println("\n___________________________________________________________________");
			System.out.println("Test Case 1: Query for a Gene ");
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

			CQLQuery cqlQuery = new CQLQuery();
			CQLObject target = new CQLObject(); // Create Gene Object
			target.setName("gov.nih.nci.cabio.domain.Gene");
			CQLAttribute attribute = new CQLAttribute();
			attribute.setName("symbol");
			attribute.setValue("%il%");
			attribute.setPredicate(CQLPredicate.LIKE);
			target.setAttribute(attribute);

			cqlQuery.setTarget(target);

			List resultList = appService.query(cqlQuery);
			// Iterate through retrieved list of objects
			for (Iterator resultsIterator = resultList.iterator(); resultsIterator
					.hasNext();) {
				Gene returnedGene = (Gene) resultsIterator.next();
				System.out.println("Symbol: " + returnedGene.getSymbol()
						+ "\n" + "\tTaxon:"
						+ returnedGene.getTaxon().getScientificName()
						+ "\n" + "\tName " + returnedGene.getFullName()
						+ "\n");
			}
        } 
        catch (Exception e) {
            System.out.println("TestCQL Test Case 1 Failed");
            e.printStackTrace();
        }
        
		// Scenario 2: Using basic search
		// Retrieving Genes based on symbol
		try {
			System.out.println("\n___________________________________________________________________");
			System.out.println("Test Case 2: Query for a Gene and Taxon associations");
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

			CQLQuery cqlQuery = new CQLQuery();
			CQLObject target = new CQLObject();
			target.setName("gov.nih.nci.cabio.domain.Gene");

			CQLAttribute attribute = new CQLAttribute();
			attribute.setName("symbol");
			attribute.setValue("brca%");
			attribute.setPredicate(CQLPredicate.LIKE);

			// Create Taxon Object Query
			CQLAssociation association1 = new CQLAssociation();
			association1.setName("gov.nih.nci.cabio.domain.Taxon");
			CQLAttribute attribute1 = new CQLAttribute();
			attribute1.setName("abbreviation");
			attribute1.setValue("%hs%");
			attribute1.setPredicate(CQLPredicate.LIKE);
			association1.setAttribute(attribute1);

			// Create Taxon Object Query
			CQLAssociation association2 = new CQLAssociation();
			association2.setName("gov.nih.nci.cabio.domain.Taxon");
			CQLAttribute attribute2 = new CQLAttribute();
			attribute2.setName("abbreviation");
			attribute2.setValue("%m%");
			attribute2.setPredicate(CQLPredicate.LIKE);
			association2.setAttribute(attribute2);

			// Create Group(Collection) of Taxon Object Query
			CQLGroup group = new CQLGroup();
			group.addAssociation(association1);
			group.addAssociation(association2);
			group.setLogicOperator(CQLLogicalOperator.OR);
			target.setAttribute(attribute);
			target.setGroup(group);

			cqlQuery.setTarget(target);

			List resultList = appService.query(cqlQuery);
			// Iterate through retrieved list of objects
			for (Iterator resultsIterator = resultList.iterator(); resultsIterator
					.hasNext();) {
				Gene returnedGene = (Gene) resultsIterator.next();
				System.out.println("Symbol: "
						+ returnedGene.getSymbol() + "\n" + "\tTaxon:"
						+ returnedGene.getTaxon().getScientificName()
						+ "\n" + "\tName " + returnedGene.getFullName()
						+ "\n");
			}
            
        } catch (Exception e) {
            System.out.println("TestCQL Test Case 2 Failed");
            e.printStackTrace();
        }

		// Scenario 3: Search Pathway for a given Gene
		try {
			System.out.println("\n___________________________________________________________________");
			System.out.println("Test Case 3: Search Pathway for a given Gene");
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

			CQLQuery cqlQuery = new CQLQuery();
			CQLObject target = new CQLObject();
			target.setName("gov.nih.nci.cabio.domain.Pathway");

			// Create Gene Object Query
			CQLAssociation association1 = new CQLAssociation();
			association1.setName("gov.nih.nci.cabio.domain.Gene");
			CQLAttribute attribute1 = new CQLAttribute();
			attribute1.setName("symbol");
			attribute1.setValue("IL5");
			attribute1.setPredicate(CQLPredicate.EQUAL_TO);
			association1.setAttribute(attribute1);

			// Create Taxon Object Query
			CQLAssociation association2 = new CQLAssociation();
			association2.setName("gov.nih.nci.cabio.domain.Taxon");
			CQLAttribute attribute2 = new CQLAttribute();
			attribute2.setName("abbreviation");
			attribute2.setValue("%hs%");
			attribute2.setPredicate(CQLPredicate.LIKE);
			association2.setAttribute(attribute2);

			// Set Relatonship between Gene and Taxon
			association1.setAssociation(association2);

			// Set Relatonship between Pathway and Gene
			// Role name is required as it can not be determined using
			// reflection
			association1.setTargetRoleName("geneCollection");
			target.setAssociation(association1);

			cqlQuery.setTarget(target);
			List resultList = appService.query(cqlQuery);
			// Iterate through retrieved list of objects
			for (Iterator resultsIterator = resultList.iterator(); resultsIterator
					.hasNext();) {
				Pathway returnedPathway = (Pathway) resultsIterator
						.next();
				System.out.println(returnedPathway.getDisplayValue());
			}
        } 
        catch (Exception e) {
            System.out.println("TestCQL Test Case 3 Failed");
            e.printStackTrace();
        }
        
		// Scenario 4: Search ProteinSequence
		try {
			System.out.println("\n___________________________________________________________________");
			System.out.println("Test Case 4: Search ProteinSequence");
			System.out.println("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~");

			CQLQuery cqlQuery = new CQLQuery();
			CQLObject target = new CQLObject();
			target.setName("gov.nih.nci.cabio.domain.ProteinSequence");

			// Create Gene Object Query
			CQLAssociation association1 = new CQLAssociation();
			association1.setName("gov.nih.nci.cabio.domain.Gene");
			CQLAttribute attribute1 = new CQLAttribute();
			attribute1.setName("symbol");
			attribute1.setValue("TP53");
			attribute1.setPredicate(CQLPredicate.EQUAL_TO);
			association1.setAttribute(attribute1);

			// Create Protein Object Query
			CQLAssociation association2 = new CQLAssociation();
			association2.setName("gov.nih.nci.cabio.domain.Protein");

			// Set Relatonship between Gene and Protein
			// Role name is required as it can not be determined using
			// reflection
			association1.setTargetRoleName("geneCollection");
			association2.setAssociation(association1);

			// Set Relatonship between Protein and ProteinSequence
			// Example of using relationship from target to source
			association1.setSourceRoleName("proteinSequence");
			target.setAssociation(association2);

			cqlQuery.setTarget(target);

			List resultList = appService.query(cqlQuery);
			// Iterate through retrieved list of objects
			for (Iterator resultsIterator = resultList.iterator(); resultsIterator
					.hasNext();) {
				ProteinSequence returnedProtSeq = (ProteinSequence) resultsIterator
						.next();
				System.out.println("Id: " + returnedProtSeq.getId()
						+ "\tLength: " + returnedProtSeq.getLength());
			}
        } 
        catch (Exception e) {
            System.out.println("TestCQL Test Case 4 Failed");
            e.printStackTrace();
        }
        
	}
}
