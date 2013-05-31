/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio;

import gov.nih.nci.cabio.domain.Agent;
import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.Clone;
import gov.nih.nci.cabio.domain.CloneRelativeLocation;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneOntology;
import gov.nih.nci.cabio.domain.Histopathology;
import gov.nih.nci.cabio.domain.NucleicAcidSequence;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.Protein;
import gov.nih.nci.cabio.domain.ProteinAlias;
import gov.nih.nci.cabio.domain.Target;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.common.provenance.domain.InternetSource;
import gov.nih.nci.common.provenance.domain.Provenance;
import gov.nih.nci.common.provenance.domain.URLSourceReference;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import junit.framework.TestCase;

/**
 * Tests for different ways to query caBIO. These tests were adapted from the 
 * TestClient program in caCORE 3.2.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class QueryTest extends TestCase {

    private final CaBioApplicationService appService = AllTests.getService();
    
    /**
     * Tests search for Genes starting the letter D. Ensures result list is
     * not empty and that all result Genes have an id and symbol. 
     */
    public void testSearch() throws Exception {

        Gene gene = new Gene();
        gene.setSymbol("D*");
        
        List<Gene> results = appService.search("gov.nih.nci.cabio.domain.Gene",gene);

        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        for (Gene g : results) {
            assertNotNull(g.getId());
            assertNotNull(g.getSymbol());
        }
        
    }
    
    /**
     * Tests a search path using the same name twice. Search for taxon for
     * the Gene NAT2.
     */
    public void testSearchPathDouble() throws Exception {

        Gene gene = new Gene();
        gene.setSymbol("NAT2");
        
        List<Taxon> results = appService.search(
            "gov.nih.nci.cabio.domain.Taxon,gov.nih.nci.cabio.domain.Taxon",
            gene);
        assertNotNull(results);
        assertTrue(results.size()>1);
        
        for (Taxon taxon : results) {
            assertNotNull(taxon.getId());
            assertNotNull(taxon.getAbbreviation());
        }
    }

    /**
     * Tests search with an empty example object (no attributes and no 
     * associations set). Search for chromosomes of the empty gene.
     */
    public void testEmptyObjectQuery() throws Exception {

        Gene gene = new Gene();
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Chromosome", gene);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Chromosome chrom = (Chromosome) iterator.next();
            assertNotNull(chrom.getId());
            assertNotNull(chrom.getNumber());
        }
    }
    
    /**
     * Test search for pathways object by Gene with symbol like "brca*".
     * Ensures result list is not empty and that all result Pathways have 
     * an id, name, displayValue and description. 
     */
    public void testPathwayByGeneQuery() throws Exception {

        Gene gene = new Gene();
        gene.setSymbol("brca*");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Pathway", gene);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Pathway pathway = (Pathway) iterator.next();
            assertNotNull(pathway.getId());
            assertNotNull(pathway.getName());
            assertNotNull(pathway.getDisplayValue());
            assertNotNull(pathway.getDescription());
        }
    }

    /**
     * Tests type 1 nested query. Starting with chromosome 11, search for Genes,
     * then Proteins, then ProteinAliases. Ensure result list is not empty, and
     * that all result ProteinAliases have ids and names.
     */
    public void testType1Query() throws Exception {
        
        Chromosome chrom = new Chromosome();
        chrom.setNumber("11");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.ProteinAlias,"
                    + "gov.nih.nci.cabio.domain.Protein,"
                    + "gov.nih.nci.cabio.domain.Gene", chrom);

        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            ProteinAlias proteinA = (ProteinAlias) iterator.next();
            assertNotNull(proteinA.getId());
            assertNotNull(proteinA.getName());
        }
    }

    /**
     * Tests a query with multiple source objects. Search for chromosomes of
     * genes starting with D and the gene NAT2. Ensure result list is not
     * empty and that all resulting chromosomes have ids and numbers.
     */
    public void testCombinedQuery() throws Exception {

        Gene gene = new Gene();
        gene.setSymbol("NAT2");

        Gene gene2 = new Gene();
        gene2.setSymbol("D*");
        
        List<Gene> geneList = new ArrayList<Gene>();
        geneList.add(gene);
        geneList.add(gene2);
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Chromosome", geneList);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Chromosome chrom = (Chromosome) iterator.next();
            assertNotNull(chrom.getId());
            assertNotNull(chrom.getNumber());
        }
    }
    
    /**
     * Tests search for Agents of Targets starting with "CD".
     */
    public void testType2Query() throws Exception {

        Target target = new Target();
        target.setName("CD*");
        
        List results = appService.search("gov.nih.nci.cabio.domain.Agent",
            target);
        
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Agent agent = (Agent) iterator.next();
            assertNotNull(agent.getId());
        }
    }
    
    /**
     * Tests nested search for Proteins via Genes for the NucleicAcidSequence 
     * with id 1507. Ensure result list is not empty and that all resulting 
     * proteins have ids and names.
     */
    public void testType2CombinedQuery() throws Exception {

        NucleicAcidSequence seq = new NucleicAcidSequence();
        seq.setAccessionNumber("DC407173");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Protein,gov.nih.nci.cabio.domain.Gene",
            seq);

        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Protein protein = (Protein) iterator.next();
            assertNotNull(protein.getId());
            assertNotNull(protein.getName());
        }
    }

    /**
     * Tests search for NucleicAcidSequence of clone L11SNU354-8-G11. 
     */
    public void testType2CombinedQuery2() throws Exception {

        Clone clone = new Clone();
        clone.setName("L11SNU354-8-G11");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.NucleicAcidSequence", clone);
        
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            NucleicAcidSequence seq = (NucleicAcidSequence) iterator.next();
            assertNotNull(seq.getId());
            assertNotNull(seq.getAccessionNumber());
        }
    }

    /**
     * Tests search for Clone L11SNU354-9-F10. 
     */
    public void testType2CombinedQuery3() throws Exception {

        Clone clone = new Clone();
        clone.setName("L11SNU354-9-F10");
        
        List results = appService.search("gov.nih.nci.cabio.domain.Clone",
            clone);

        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Clone c = (Clone) iterator.next();
            assertNotNull(c.getId());
            assertNotNull(c.getName());
        }
    }

    /**
     * Tests nested search from Clone L11SNU354-9-B05, through 
     * NucleicAcidSequence to Gene. Ensures result list is not empty and that 
     * all resulting genes have id and symbol.
     */
    public void testUniDirectionNestedQuery() throws Exception {

        Clone clone = new Clone();
        clone.setName("L11SNU354-9-B05");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Gene, gov.nih.nci.cabio.domain.NucleicAcidSequence",
            clone);
        
        assertNotNull(results);
        assertFalse(results.isEmpty());
    
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Gene gene = (Gene) iterator.next();
            assertNotNull(gene.getId());
            assertNotNull(gene.getSymbol());
        }
    }

    /**
     * Tests many-to-many search from pathways starting with h_C to 
     * Histopathology.
     */
    public void testManyToManyUnidirectional() throws Exception {

        Pathway pathway = new Pathway();
        pathway.setName("h_C*");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.Histopathology", pathway);

        assertNotNull(results);
        assertFalse(results.isEmpty());

        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Histopathology his = (Histopathology) iterator.next();
            assertNotNull(his.getId());
        }
        
    }

    /**
     * Tests search for GeneOntology through Gene, starting at Chromosome Y.
     */
    public void testTwoLevelNestedQuery() throws Exception {
        
        Chromosome chrom = new Chromosome();
        chrom.setNumber("Y");
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.GeneOntology,gov.nih.nci.cabio.domain.Gene",
            chrom); 
        
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            GeneOntology go = (GeneOntology) iterator.next();
            assertNotNull(go.getId());
            assertNotNull(go.getName());
        }
    }
    
    /**
     * Tests search for Genes for Targets starting with "CD".
     */
    public void testManyToOneBidirectional2() throws Exception {

        Target target = new Target();
        target.setName("CD*");
        
        List results = appService.search("gov.nih.nci.cabio.domain.Gene",
            target);
        
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            Gene gene = (Gene) iterator.next();
            assertNotNull(gene.getId());
            assertNotNull(gene.getFullName());
            assertNotNull(gene.getClusterId());
        }
    }

    /**
     * Tests search for NucleicAcidSequences of the CloneRelativeLocation
     * with id 5.
     */
    public void testOneToOneBidirectional() throws Exception {
        
        CloneRelativeLocation crlocation = new CloneRelativeLocation();
        crlocation.setId(new Long(5));
        
        List results = appService.search(
            "gov.nih.nci.cabio.domain.NucleicAcidSequence", crlocation);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        Iterator iterator = results.iterator();
        while (iterator.hasNext()) {
            NucleicAcidSequence seq = (NucleicAcidSequence) iterator.next();
            assertNotNull(seq.getId());
            assertNotNull(seq.getAccessionNumber());
        }
    }
    
    /**
     * Tests Grid Id search for all genes starting with "brca". The attributes 
     * of the Gene object returned by Grid Id are compared to the Gene object
     * returned by the original query.
     */
    public void testGridIdentifier() throws Exception {

        Gene gene = new Gene();
        gene.setSymbol("brca*");
        List results = appService.search("gov.nih.nci.cabio.domain.Gene", gene);
        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        for (int i = 0; i < results.size(); i++) {
            Gene g = (Gene) results.get(i);
            
            assertNotNull(g.getId());
            assertNotNull(g.getSymbol());
            assertNotNull(g.getBigid());

            assertTrue(appService.exist(g.getBigid()));

            Gene dataObject = (Gene) appService.getDataObject(g.getBigid());
            
            assertNotNull(dataObject);
            assertEquals(g.getId(),dataObject.getId());
            assertEquals(g.getSymbol(),dataObject.getSymbol());
            assertEquals(g.getBigid(),dataObject.getBigid());
        }
    }

    /**
     * Tests to ensure data provenance exists for proteins associated with 
     * genes starting with "BRCA".
     */
    public void testProvenance() throws Exception {
        
        Protein pro = new Protein();
        pro.setName("BRCA*");

        List results = appService.search(Protein.class, pro);

        assertNotNull(results);
        assertFalse(results.isEmpty());
        
        for (int i = 0; i < results.size(); i++) {
            Protein protein = (Protein)results.get(i);
            assertNotNull(protein.getId());
            assertNotNull(protein.getName());

            Provenance p = new Provenance();
            p.setFullyQualifiedClassName("gov.nih.nci.cabio.domain.Protein");
            p.setObjectIdentifier(protein.getId().toString());

            List resultList = appService.search(Provenance.class, p);
            assertNotNull(resultList);
            assertTrue((resultList.size() > 0));
            
            Provenance provenance = (Provenance) resultList.get(0);

            InternetSource source = (InternetSource)provenance.getSupplyingSource();
            assertNotNull(source.getOwnerInstitution());
            
            InternetSource immediateSource = (InternetSource)provenance.getImmediateSource();
            assertNotNull(immediateSource.getOwnerInstitution());
            
            InternetSource originalSource = (InternetSource)provenance.getOriginalSource();
            assertNotNull(originalSource.getOwnerInstitution());

            URLSourceReference sourceReference = (URLSourceReference)provenance.getSourceReference();
            assertNotNull(sourceReference.getSourceReferenceType());
            assertNotNull(sourceReference.getSourceURL());
        }
    }
}
