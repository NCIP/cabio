package gov.nih.nci.cabio.portal;

import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.cabio.portal.portlet.GlobalQueries;
import gov.nih.nci.cabio.util.ORMTestCase;

import java.util.List;

/**
 * Test the global queries which are executed at portlet startup time.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GlobalQueriesTest extends ORMTestCase {

    private GlobalQueries q;
    
    @Override
    protected void setUp() throws Exception {
        this.q = new GlobalQueries();
    }

//    public void testAssemblyValues() throws Exception {
//        assertNotNull(q.getAssemblyValues());
//    }

    public void testClassFilterValues() throws Exception {
        assertNotNull(q.getClassFilterValues());
    }

    public void testTaxonValues() throws Exception {
        assertNotNull(q.getTaxonValues());
        assertEquals(2,q.getTaxonValues().size());
    }

    public void testMicroarrays() throws Exception {
        assertNotNull(q.getMicroarrays());
    }

    public void testTaxonChromosomes() throws Exception {
        assertNotNull(q.getTaxonChromosomes());
        for(Taxon t : q.getTaxonValues()) {
            List<Chromosome> chroms = q.getTaxonChromosomes().get(t);
            assertNotNull(chroms);
        }
    }
}
