/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

    package gov.nih.nci.cabio;

import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.List;

import junit.framework.TestCase;

import org.junit.Test;

/**
 * Test CQL queries against caBIO.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CaIntegratorTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();

    private ApplicationService getApplicationService() {
        return appService;
    }
    
    @Test
    public void testRetrieveGenesByAlias() throws Exception {
        
        List<String> params = new ArrayList<String>();
        params.add("human");
        params.add("%brca1%");
        params.add("%brca2%");
        
        String hql = "SELECT DISTINCT g.symbol, g.fullName, " +
                " t.commonName, g.hugoSymbol " + 
                "FROM gov.nih.nci.cabio.domain.GeneAlias a " +
                "INNER JOIN a.geneCollection g " +
                "INNER JOIN g.taxon t " + 
                "WHERE t.commonName LIKE ?" +
                "AND (lower(a.name) LIKE ? " + 
                "OR lower(a.name) LIKE ?) ";
        
        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrieveGenesByAlias");
        printResults(results);
    }

    @Test
    public void testRetrieveGenesBySymbol() throws Exception {
        
        List<String> params = new ArrayList<String>();
        params.add("human");
        params.add("%brca1%");
        params.add("%brca2%");
        
        String hql = "SELECT DISTINCT gene.symbol, gene.fullName, " +
        		"gene.taxon.commonName " + 
        		"FROM gov.nih.nci.cabio.domain.Gene gene " + 
        		"WHERE gene.symbol is not null " + 
        		"AND gene.taxon.commonName LIKE ? " + 
        		"AND (lower(gene.symbol) LIKE ? OR lower(gene.hugoSymbol) LIKE ?) ";

        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrieveGenesBySymbol");
        printResults(results);
    }

    @Test
    public void testRetrieveGenesByCrossReferenceIdentifier() throws Exception {
        
        List<String> params = new ArrayList<String>();
        params.add("human");
        params.add("%ENSG00000139618%".toLowerCase());
        params.add("%ENSG00000012048%".toLowerCase());
        
        String hql = "SELECT DISTINCT o.gene.symbol, o.gene.fullName, " +
        		"o.gene.taxon.commonName " + 
        		"FROM gov.nih.nci.common.domain.DatabaseCrossReference o " + 
        		"WHERE o.gene.symbol is not null " + 
        		"and o.gene.taxon.commonName LIKE ? " + 
        		"AND (lower(o.crossReferenceId) LIKE ? " +
        		"OR lower(o.crossReferenceId) LIKE ?) ";

        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrieveGenesByCrossReferenceIdentifier");
        printResults(results);
    }
    
    @Test
    public void testRetrieveGenesByKeyword() throws Exception {
        
        List<String> params = new ArrayList<String>();
        params.add("human");
        params.add("%Breast%".toLowerCase());
        params.add("%cancer%".toLowerCase());
        
        String hql = "SELECT DISTINCT o.symbol, o.fullName, o.taxon.commonName " + 
        		"FROM gov.nih.nci.cabio.domain.Gene o " + 
        		"WHERE o.symbol is not null " + 
        		"and o.taxon.commonName LIKE ? " + 
        		"AND (lower(o.fullName) LIKE ? " +
                "AND lower(o.fullName) LIKE ?)";

        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrieveGenesByKeyword");
        printResults(results);
    }
    
    @Test
    public void testRetrievePathwayByKeyword() throws Exception {
        
        List<String> params = new ArrayList<String>();
        params.add("human");
        params.add("%BRCA1%".toLowerCase());
        params.add("%BRCA1%".toLowerCase());
        params.add("%BRCA1%".toLowerCase());
        params.add("%BRCA2%".toLowerCase());
        params.add("%BRCA2%".toLowerCase());
        params.add("%BRCA2%".toLowerCase());
        
        String hql = "SELECT o.name, o.id, o.displayValue, o.description " + 
        		"FROM gov.nih.nci.cabio.domain.Pathway o " + 
        		"WHERE o.name is not null " + 
        		"and o.taxon.commonName LIKE ? " + 
        		"AND (lower(o.name) LIKE ? " +
        		"OR lower(o.displayValue) LIKE ? " +
        		"OR lower(o.description) LIKE ?) " +
                "AND (lower(o.name) LIKE ? " +
                "OR lower(o.displayValue) LIKE ? " +
                "OR lower(o.description) LIKE ?) ";

        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrievePathwayByKeyword");
        printResults(results);
    }
    
    @Test
    public void testRetrieveAllTaxons() throws Exception {
        
        List<String> params = new ArrayList<String>();
        
        String hql = "SELECT DISTINCT t.commonName, t.scientificName " + 
        		"FROM gov.nih.nci.cabio.domain.Taxon t";

        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrieveAllTaxons");
        printResults(results);
    }
    
    private void printResults(List<Object[]> results) {
        for(Object[] row : results) {
            for(Object r : row) {
                System.out.print(r);
                System.out.print("\t");
            }
            System.out.println();
        }
    }
}
