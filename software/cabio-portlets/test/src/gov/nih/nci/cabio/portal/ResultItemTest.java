/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal;

import gov.nih.nci.cabio.domain.DiseaseOntology;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAlias;
import gov.nih.nci.cabio.domain.GeneDiseaseAssociation;
import gov.nih.nci.cabio.domain.GenePhysicalLocation;
import gov.nih.nci.cabio.domain.Protein;
import gov.nih.nci.cabio.portal.portlet.ClassUtils;
import gov.nih.nci.cabio.portal.portlet.ReportService;
import gov.nih.nci.cabio.portal.portlet.ResultItem;
import gov.nih.nci.cabio.util.ORMTestCase;
import gov.nih.nci.common.domain.DatabaseCrossReference;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

/**
 * Tests for the ResultItem class and its peculiar path syntax.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ResultItemTest extends ORMTestCase {

    private final ReportService rs = AllTests.getReportService();

    private static final String symbol = "brca2";
    
    private Collection<Gene> getGenes() throws Exception {

        List<Gene> results = rs.getGenesBySymbol(symbol);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        return results;
    }

    public void testSpecialAttributes() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            String className = (String)r.get("_className");
            String querystr = (String)r.get("_querystr");
            assertEquals("_className return value was wrong",Gene.class.getName(),className);
            assertEquals("_obj return value was wrong",o,r.get("_obj"));
            assertNotNull("_displayMap was null",r.get("displayMap"));
            assertNotNull("_querystr was null",querystr);
            assertTrue("_querystr return value was wrong",querystr.startsWith("?query="));
        }
    }

    public void testGetClasses() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            
            List<Class> classes = 
                r.getClasses("geneFunctionAssociationCollection" +
                		"[class=GeneDiseaseAssociation].diseaseOntology");
            assertEquals(3,classes.size());
            
            assertEquals(Gene.class.getName(),
                ClassUtils.removeEnchancer(classes.get(0)));
            
            assertEquals(GeneDiseaseAssociation.class.getName(),
                ClassUtils.removeEnchancer(classes.get(1)));
            
            assertEquals(DiseaseOntology.class.getName(),
                ClassUtils.removeEnchancer(classes.get(2)));
        }
    }
    
    public void testSimpleAttribute() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            String s = (String)r.get("symbol");
            assertTrue(symbol.equalsIgnoreCase(s));
        }
    }
    
    public void testAssociatedOneAttribute() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            String taxon = (String)r.get("taxon.abbreviation");
            assertTrue("Hs".equals(taxon) || "Mm".equals(taxon));
        }
    }

    public void testAssociatedManyAttribute() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            String aliases = (String)r.getDisplayMap().get("geneAliasCollection.name");
            List<String> aliasPool = new ArrayList<String>();
            for(String alias : aliases.split(", ")) {
                aliasPool.add(alias);
            }
            for(GeneAlias geneAlias : o.getGeneAliasCollection()) {
                String a = geneAlias.getName();
                assertTrue("Alias was not given: "+geneAlias.getName(),
                    aliasPool.contains(geneAlias.getName()));
                aliasPool.remove(geneAlias.getName());
            }
            
            assertTrue(aliasPool.size()+" extra aliases given",aliasPool.isEmpty());
        }
    }

    public void testAssociation() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            Object ac = r.get("databaseCrossReferenceCollection");
            assertTrue(ac instanceof Collection);
            Collection dbxrs = (Collection)ac;
            Object ao = dbxrs.iterator().next();
            assertTrue(ao instanceof DatabaseCrossReference);
        }
    }

    public void testAssociationConstrainedByAttrValue() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            Object ac = r.get("physicalLocationCollection[featureType=GENE]");
            assertTrue(ac instanceof Collection);
            Collection pls = (Collection)ac;
            for (Object ao : pls) {
                assertTrue(ao instanceof GenePhysicalLocation);
                GenePhysicalLocation pl = (GenePhysicalLocation)ao;
                assertEquals("GENE",pl.getFeatureType());
            }
        }
    }
    
    public void testAssociationConstrainedByClass() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            Object ac = r.get("geneFunctionAssociationCollection[class=GeneDiseaseAssociation]");
            assertTrue(ac instanceof Collection);
            Collection pls = (Collection)ac;
            for (Object ao : pls) {
                assertTrue(ao instanceof GeneDiseaseAssociation);
            }
        }
    }
    
    public void testAssociationConstrainedByPosition() throws Exception {
        for(Gene o : getGenes()) {
            ResultItem r = new ResultItem(o);
            Object ac = r.get("proteinCollection[0]");
            assertTrue(ac instanceof Protein);
            assertEquals(o.getProteinCollection().iterator().next(), ac);
        }
    }
}
