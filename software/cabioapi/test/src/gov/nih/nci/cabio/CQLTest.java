package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.ProteinSequence;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.query.cql.CQLAssociation;
import gov.nih.nci.system.query.cql.CQLAttribute;
import gov.nih.nci.system.query.cql.CQLGroup;
import gov.nih.nci.system.query.cql.CQLLogicalOperator;
import gov.nih.nci.system.query.cql.CQLObject;
import gov.nih.nci.system.query.cql.CQLPredicate;
import gov.nih.nci.system.query.cql.CQLQuery;

import java.util.Iterator;
import java.util.List;

import junit.framework.TestCase;

/**
 * Test CQL queries against caBIO.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CQLTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
    
    /**
     * Scenario 1: Using basic search.
     * Retrieving Genes based on symbol.
     * @throws Exception
     */
    public void testBasicQuery() throws Exception {
        
        CQLQuery cqlQuery = new CQLQuery();
        CQLObject target = new CQLObject();
        target.setName("gov.nih.nci.cabio.domain.Gene");
        CQLAttribute attribute = new CQLAttribute();
        attribute.setName("symbol");
        attribute.setValue("%il%");
        attribute.setPredicate(CQLPredicate.LIKE);
        target.setAttribute(attribute);

        cqlQuery.setTarget(target);

        List results = appService.query(cqlQuery);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            Gene g = (Gene) iterator.next();
            assertNotNull(g.getSymbol());
            assertNotNull(g.getTaxon().getScientificName());
            assertNotNull(g.getFullName());
        }
    }

    /**
     * Scenario 2: Using basic search.
     * Query for a Gene and Taxon associations.
     * @throws Exception
     */
    public void testAssociationQuery() throws Exception {

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

        List results = appService.query(cqlQuery);
        assertNotNull(results);
        assertTrue((results.size() > 0));
        
        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            Gene g = (Gene) iterator.next();
            assertNotNull(g.getSymbol());
            assertNotNull(g.getTaxon().getScientificName());
            assertNotNull(g.getFullName());
        }
    }
    

    /**
     * Scenario 3: Search Pathway for a given Gene.
     * @throws Exception
     */
    public void testAssociationQuery2() throws Exception {

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
        
        List results = appService.query(cqlQuery);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            Pathway p = (Pathway) iterator.next();
            assertNotNull(p.getDisplayValue());
        }
    }

    /**
     * Scenario 3: Search ProteinSequence
     * @throws Exception
     */
    public void testAssociationQuery3() throws Exception {

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

        List results = appService.query(cqlQuery);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            ProteinSequence ps = (ProteinSequence) iterator.next();
            assertNotNull(ps.getId());
            assertNotNull(ps.getLength());
        }
    }
}
