/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.ProteinSequence;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.system.applicationservice.ApplicationService;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import junit.framework.TestCase;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

/**
 * Examples from the Developer Guide. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class DevGuideTest extends TestCase {

    private final ApplicationService appService = AllTests.getService();
    
    /**
     * Scenario 1: Using basic search. 
     * Retrieving Genes based on symbol and using Gene class as the Target.
     * @throws Exception
     */
    public void testBasicSearch() throws Exception {
        Gene gene = new Gene();
        gene.setSymbol("brca*");

        List results = appService.search(Gene.class, gene);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            Gene g = (Gene) iterator.next();
            assertNotNull(g.getId());
            assertNotNull(g.getSymbol());
            assertNotNull(g.getTaxon().getScientificName());
            assertNotNull(g.getFullName());
        }
    }

    /**
     * Scenario 2: Building compound criteria.
     * Retrieving a List of Pathway objects for a particular Taxon and a Gene.
     * @throws Exception
     */
    public void testCompoundCriteria() throws Exception {
        
        Pathway pathway = new Pathway();
    
        Taxon taxon = new Taxon();
        taxon.setAbbreviation("hs");
    
        Gene gene = new Gene();
        gene.setTaxon(taxon);
    
        List<Gene> geneList = new ArrayList<Gene>();
        geneList.add(gene);
    
        pathway.setGeneCollection(geneList);
        pathway.setTaxon(taxon);
    
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Pathway", pathway);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            Pathway pw = (Pathway) iterator.next();
            assertNotNull(pw.getId());
            assertNotNull(pw.getName());
            assertNotNull(pw.getDisplayValue());
        }
    }

    /**
     * Scenario 3: Building a Nested search.
     * @throws Exception
     */
    public void testNestedSearch() throws Exception {

        Gene gene = new Gene();
        gene.setSymbol("tp53");

        List results = appService.search(
            "gov.nih.nci.cabio.domain.ProteinSequence,gov.nih.nci.cabio.domain.Protein",
            gene);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            ProteinSequence ps = (ProteinSequence) iterator.next();
            assertNotNull(ps.getId());
            assertNotNull(ps.getCheckSum());
            assertNotNull(ps.getLength());
        }
    }
    
    /**
     * Scenario 4: Detached Criteria.
     * Creating an Hibernate's Detached Criteria by directly using Hibernate API.
     * @throws Exception
     */
    public void testDetachedCriteria() throws Exception {

        DetachedCriteria criteria = DetachedCriteria.forClass(Pathway.class);
        criteria.add(Restrictions.like("name", "%_prc2%"));

        List results = appService.query(criteria);
        assertNotNull(results);
        assertTrue((results.size() > 0));

        for (Iterator iterator = results.iterator(); iterator.hasNext();) {
            Pathway pathway = (Pathway) iterator.next();
            assertNotNull(pathway.getDescription());
            assertNotNull(pathway.getDisplayValue());
        }
    }
    
}
