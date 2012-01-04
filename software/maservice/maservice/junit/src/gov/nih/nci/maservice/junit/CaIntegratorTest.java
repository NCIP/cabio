package gov.nih.nci.maservice.junit;

import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

/**
 * Tests the MA information model. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CaIntegratorTest extends MaTestBase {

    @Test
    public void testRetrieveGenesByAlias() throws Exception {
        
        List<String> params = new ArrayList<String>();
        params.add("human");
        params.add("%brca1%");
        params.add("%brca2%");
                
        String hql = "SELECT DISTINCT g.symbol.value, g.fullName.value, " +
        		" g.organism.commonName.value, a.id " + 
        		"FROM gov.nih.nci.maservice.domain.GeneAlias a " +
        		"INNER JOIN a.gene g " +
        		"INNER JOIN g.organism o " + 
                "WHERE o.commonName.value LIKE ?" +
                "AND (lower(a.identifier.extension) LIKE ? " + 
                "OR lower(a.identifier.extension) LIKE ?) ";
        
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
        
        String hql = "SELECT DISTINCT gene.symbol.value, " +
                "  gene.fullName.value, " +
                "  gene.organism.commonName.value  " + 
                "FROM gov.nih.nci.maservice.domain.Gene gene " + 
                "WHERE gene.symbol.value is not null " + 
                "AND gene.organism.commonName.value LIKE ? " + 
                "AND (lower(gene.symbol.value) LIKE ? " +
                "  OR lower(gene.symbol.value) LIKE ?) ";

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
        
        String hql = "SELECT DISTINCT o.gene.symbol.value, o.gene.fullName.value, " +
                "o.gene.organism.commonName.value " + 
                "FROM gov.nih.nci.maservice.domain.GeneIdentifier o " +
                "WHERE o.gene.symbol.value is not null " + 
                "and o.gene.organism.commonName.value LIKE ? " + 
                "AND (lower(o.identifier.extension) LIKE ? " +
                "OR lower(o.identifier.extension) LIKE ?) ";
        
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
        
        String hql = "SELECT DISTINCT o.symbol.value, o.fullName.value, " +
        		"o.organism.commonName.value " + 
                "FROM gov.nih.nci.maservice.domain.Gene o " + 
                "WHERE o.symbol.value is not null " + 
                "and o.organism.commonName.value LIKE ? " + 
                "AND (lower(o.fullName.value) LIKE ? " +
                "AND lower(o.fullName.value) LIKE ?)";

        List<Object[]> results = 
            getApplicationService().query(new HQLCriteria(hql.toString(), params));
        
        System.out.println("testRetrieveGenesByKeyword");
        printResults(results);
    }
    
    @Test
    public void testRetrieveAllTaxons() throws Exception {
        
        List<String> params = new ArrayList<String>();
        
        String hql = "SELECT DISTINCT o.commonName.value, o.scientificName.value " + 
                "FROM gov.nih.nci.maservice.domain.Organism o";

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
