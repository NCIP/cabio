package gov.nih.nci.cabio;

import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.CytobandPhysicalLocation;
import gov.nih.nci.cabio.domain.CytogeneticLocation;
import gov.nih.nci.cabio.domain.ExonArrayReporter;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAlias;
import gov.nih.nci.cabio.domain.GenePhysicalLocation;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.cabio.domain.SNPPhysicalLocation;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.cabio.util.IncIterator;
import gov.nih.nci.cabio.util.ORMTestCase;
import gov.nih.nci.cabio.util.OnceIterator;
import gov.nih.nci.common.domain.DatabaseCrossReference;
import gov.nih.nci.common.util.ReflectionUtils;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.io.BufferedReader;
import java.io.FileReader;
import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.NoSuchElementException;
import java.util.Set;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

/**
 * Unit tests for the Array Annotation API in caBIO.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AnnotationAPITest extends ORMTestCase {
    
    private static final String EXPR_ARRAY = "HG-U133_Plus_2";
    private static final String SNP_ARRAY = "Mapping250K_Sty";
    private static final String EXON_ARRAY = "HuEx-1_0-st-v2";
    
    private static final boolean BENCHMARK_SUBLISTS = false;
    private static final boolean BENCHMARK_ASSOCIATIONS = false;
    
    private static final CaBioApplicationService appService = AllTests.getService();

    private static final ArrayAnnotationService am = new ArrayAnnotationServiceImpl(appService);
    
    private static List<String> genes;
    private static List<String> snps;
    private static List<String> exprReporters;
    private static List<String> exonReporters;
    private static List<String> snpReporters;
    
    @Override
    protected void setUp() throws Exception {
    }
    
    static {
        System.out.println("loading symbol lists...");
        
        try {
        
            // create gene list
            DetachedCriteria criteria = DetachedCriteria.forClass(ExpressionArrayReporter.class);
            criteria.createAlias("gene", "gene");
            criteria.createCriteria("microarray").add(Restrictions.eq("name", EXPR_ARRAY));
            criteria.add(Restrictions.isNotNull("gene.hugoSymbol")).
                    add(Restrictions.sqlRestriction("rownum <= 2200")).
                    addOrder(Order.asc("gene.hugoSymbol"));
            criteria.setProjection(Projections.distinct(Projections.projectionList()
                    .add(Projections.property("gene.hugoSymbol"))
                    ));
            genes = getUniqueSymbols(appService.query(criteria));
            
            // create snp list
            criteria = DetachedCriteria.forClass(SNPArrayReporter.class);
            criteria.createAlias("SNP", "snp");
            criteria.createCriteria("microarray").add(Restrictions.eq("name", SNP_ARRAY));
            criteria.add(Restrictions.isNotNull("snp.DBSNPID")).
                    add(Restrictions.sqlRestriction("rownum <= 2200")).
                    addOrder(Order.asc("snp.DBSNPID"));
            criteria.setProjection(Projections.distinct(Projections.projectionList()
                    .add(Projections.property("snp.DBSNPID"))
                    ));
            snps = getUniqueSymbols(appService.query(criteria));
    
            // create expression reporter list
            criteria = DetachedCriteria.forClass(ExpressionArrayReporter.class);
            criteria.createAlias("gene", "gene");
            criteria.createCriteria("microarray").add(Restrictions.eq("name", EXPR_ARRAY));
            criteria.add(Restrictions.isNotNull("gene.hugoSymbol")).
                    add(Restrictions.sqlRestriction("rownum <= 2200")).
                    addOrder(Order.asc("name"));
            criteria.setProjection(Projections.distinct(Projections.projectionList()
                    .add(Projections.property("name"))
                    ));
            exprReporters = getUniqueSymbols(appService.query(criteria));
    
            // create exon reporter list
            criteria = DetachedCriteria.forClass(ExonArrayReporter.class);
            criteria.createAlias("geneCollection", "genes");
            criteria.createCriteria("microarray").add(Restrictions.eq("name", EXON_ARRAY));
            criteria.add(Restrictions.isNotNull("genes.hugoSymbol")).
                    add(Restrictions.sqlRestriction("rownum <= 2200")).
                    addOrder(Order.asc("name"));
            criteria.setProjection(Projections.distinct(Projections.projectionList()
                    .add(Projections.property("name"))
                    ));
            exonReporters = getUniqueSymbols(appService.query(criteria));
    
            // create snp reporter list
            criteria = DetachedCriteria.forClass(SNPArrayReporter.class);
            criteria.createAlias("SNP", "snp");
            criteria.createCriteria("microarray").add(Restrictions.eq("name", SNP_ARRAY));
            criteria.add(Restrictions.isNotNull("snp.DBSNPID")).
                    add(Restrictions.sqlRestriction("rownum <= 2200")).
                    addOrder(Order.asc("name"));
            criteria.setProjection(Projections.distinct(Projections.projectionList()
                    .add(Projections.property("name"))
                    ));
            snpReporters = getUniqueSymbols(appService.query(criteria));
    
            System.out.println("Test genes: "+genes.size());
            System.out.println("Test SNPs: "+snps.size());
            System.out.println("Test expr reporters: "+exprReporters.size());
            System.out.println("Test exon reporters: "+exonReporters.size());
            System.out.println("Test SNP reporters: "+snpReporters.size());
        
        } catch (ApplicationException e) {
            e.printStackTrace();
        }
    }
    
    private static List<String> getUniqueSymbols(List resultList){

        Map<String,Integer> symbolCount = new HashMap<String,Integer>();
        try {
            for(Object o : resultList) {
                String symbol = (String)o;
                int c = symbolCount.containsKey(symbol) 
                        ? symbolCount.get(symbol) : 0;
                c++;
                symbolCount.put(symbol,c);
            }
        }
        catch (NoSuchElementException e) {
            // hopefully this only happens at the very end and we can ignore it
        }
        
        List<String> unique = new ArrayList<String>();
        for(String symbol : symbolCount.keySet()) {
            if (symbolCount.get(symbol)==1) unique.add(symbol);
        }
        
        return unique;
    }
    
    /**
     * Test getGenesForReporters for HGU133 array with increasing lengths of 
     * reporter lists.
     */
    public void testGetGenesForReporters() throws Exception {

        for(Iterator<List> i = getIterator(exprReporters); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Map<String, Collection<String>> results = am.getGenesForReporters(EXPR_ARRAY, sublist);
            long end = System.currentTimeMillis();
            System.out.println("getGenesForReporters("+sublist.size()+" genes) took "+(end-start)+" ms");
            
            for(String reporter : sublist) {
                assertTrue("Missing reporter in results: "+reporter,results.containsKey(reporter));
                Collection<String> genes = results.get(reporter);
                assertTrue("Reporter has no genes: "+reporter,!genes.isEmpty());            
            }
        }
    }

    /**
     * Test getReportersForGenes with increasing lengths of gene lists.
     */
    public void testGetReportersForGenes() throws Exception {

        for(Iterator<List> i = getIterator(genes); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Map<String, Collection<String>> results = am.getReportersForGenes(EXPR_ARRAY, sublist);
            long end = System.currentTimeMillis();
            System.out.println("getReportersForGenes("+sublist.size()+" genes) took "+(end-start)+" ms");
            
            for(String symbol : sublist) {
                assertTrue("Missing gene in results: "+symbol,results.containsKey(symbol));
                Collection<String> reporters = results.get(symbol);
                assertFalse("Gene has no reporters: "+symbol,reporters.isEmpty());            
            }
        }
    }

    /**
     * Tests getReportersForPlatform for all platforms. Ensures it can iterate
     * over the first element of the returned collection, but does not iterate
     * all elements.
     */
    public void testGetReportersForPlatform() throws Exception {
        
        List arrays = appService.search(Microarray.class, new Microarray());
        for(Object mo : arrays) {
            Microarray microarray = (Microarray)mo;
            String array = microarray.getName();
            long start = System.currentTimeMillis();
            Collection<ArrayReporter> results = am.getReportersForPlatform(array);
            long end = System.currentTimeMillis();
            assertTrue("No reporters for microarray "+array,
                results.iterator().hasNext());
            System.out.println("getReportersForPlatform("+array+") took "+(end-start)+" ms");
        }
    }
    
    /**
     * Test getExpressionReporterAnnotations with increasing lengths of reporter 
     * lists. Ensures all returned ExpressionArrayReporter objects have 
     * preloaded associations as per the Javadoc.
     */
    public void testGetExpressionReporterAnnotations() throws Exception {

        for(Iterator<List> i = getIterator(exprReporters); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Collection<ExpressionArrayReporter> results = am.getExpressionReporterAnnotations(EXPR_ARRAY, sublist);
            Set<String> reporters = new HashSet<String>();
            
            for(ExpressionArrayReporter er : results) {

                assertPreloaded(er, "gene");
                
                assertNotNull("Reporter has no name",er.getName());
                assertNotNull("Reporter has no gene: "+er.getName(),er.getGene());

                if (BENCHMARK_ASSOCIATIONS) {
                    for(Object o : er.getPhysicalLocationCollection()) {
                        PhysicalLocation pl = (PhysicalLocation)o;
                        pl.getChromosome();
                    }
                    
                    for(Object o : er.getCytogeneticLocationCollection()) {
                        CytogeneticLocation cl = (CytogeneticLocation)o;
                        cl.getStartCytoband();
                    }
                }

                reporters.add(er.getName());
            }

            long end = System.currentTimeMillis();
            System.out.println("getExpressionReporterAnnotations("+sublist.size()+" reporters) took "+(end-start)+" ms");

            for(String reporterId : sublist) {
                assertTrue("Requested reporter not in results: "+
                    reporterId,reporters.contains(reporterId));
            }
            
            assertEquals("Result size does not match input size", 
                sublist.size(), results.size());
        }
    }

    /**
     * Test getExonReporterAnnotations with increasing lengths of gene 
     * lists. Ensures all returned ExonArrayReporter objects have 
     * preloaded associations as per the Javadoc.
     */
    public void testGetExonReporterAnnotations() throws Exception {

        for(Iterator<List> i = getIterator(exonReporters); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Collection<ExonArrayReporter> results = 
                am.getExonReporterAnnotations(EXON_ARRAY, sublist);

            Set<String> reporters = new HashSet<String>();
            
            for(ExonArrayReporter er : results) {
                assertNotNull("Reporter has no name",er.getName());

                if (BENCHMARK_ASSOCIATIONS) {
                    for(Gene o : er.getGeneCollection()) {
                        assertNotNull(o.getId());
                    }
                    
                    for(PhysicalLocation o : er.getPhysicalLocationCollection()) {
                        assertNotNull(o.getId());
                    }
                    
                    for(CytogeneticLocation o : er.getCytogeneticLocationCollection()) {
                        assertNotNull(o.getId());
                    }
                }
                
                reporters.add(er.getName());
            }
            
            long end = System.currentTimeMillis();
            System.out.println("getExonReporterAnnotations("+sublist.size()+" reporters) took "+(end-start)+" ms");

            for(String reporterId : sublist) {
                assertTrue("Requested reporter not in results: "+
                    reporterId,reporters.contains(reporterId));
            }
            
            assertEquals("Result size does not match input size", sublist.size(), results.size());
        }
    }

    /**
     * Test getSNPReporterAnnotations with increasing lengths of reporter 
     * lists. Ensures all returned ExonArrayReporter objects have 
     * preloaded associations as per the Javadoc.
     */
    public void testGetSNPReporterAnnotations() throws Exception {

        for(Iterator<List> i = getIterator(snpReporters); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Collection<SNPArrayReporter> results = 
                am.getSNPReporterAnnotations(SNP_ARRAY, sublist);

            Set<String> reporters = new HashSet<String>();
            
            for(SNPArrayReporter er : results) {
                assertNotNull("Reporter has no name",er.getName());
                assertNotNull("Reporter has no SNP: "+er.getName(),er.getSNP());

                if (BENCHMARK_ASSOCIATIONS) {
                    for(PhysicalLocation o : er.getPhysicalLocationCollection()) {
                        assertNotNull(o.getId());
                    }
                    
                    for(CytogeneticLocation o : er.getCytogeneticLocationCollection()) {
                        assertNotNull(o.getId());
                    }
                }
                
                reporters.add(er.getName());
            }

            long end = System.currentTimeMillis();
            System.out.println("getSNPReporterAnnotations("+sublist.size()+" reporters) took "+(end-start)+" ms");
            
            for(String reporterId : sublist) {
                assertTrue("Requested reporter not in results: "+
                    reporterId,reporters.contains(reporterId));
            }
            
            assertEquals("Result size does not match input size", sublist.size(), results.size());
        }
    }

    /**
     * Test getGeneAnnotations with increasing lengths of gene lists. Ensures 
     * all returned Gene objects have preloaded associations as per the Javadoc.
     */
    public void testGetGeneAnnotations() throws Exception {

        for(Iterator<List> i = getIterator(genes); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Collection<Gene> results = am.getGeneAnnotations(sublist);

            // Result size could be bigger if multiple Unigenes have the same symbol
            assertTrue("Result size is smaller than input size", 
                (sublist.size()<=results.size()));
            
            for(Gene gene : results) {
                
                assertNotNull(gene.getChromosome());
                
                assertNotNull("Gene has no symbol: "+gene.getId(),gene.getSymbol());
                assertNotNull("Gene has no chromosome: "+gene.getId(),gene.getChromosome());

                Collection<DatabaseCrossReference> dxr = gene.getDatabaseCrossReferenceCollection();
                assertEquals(1,dxr.size());
                assertEquals("Locus link id was not preloaded","LOCUS_LINK_ID",
                    dxr.iterator().next().getDataSourceName());

                if (BENCHMARK_ASSOCIATIONS) {
                    for(PhysicalLocation o : gene.getPhysicalLocationCollection()) {
                        assertNotNull(o.getId());
                    }
                    
                    for(CytogeneticLocation o : gene.getCytogeneticLocationCollection()) {
                        assertNotNull(o.getId());
                    }
                }
            }

            long end = System.currentTimeMillis();
            System.out.println("getGeneAnnotations("+sublist.size()+" genes) took "+(end-start)+" ms");
        }
    }
    
    /**
     * Test getCytobandPositions for all Human chromosomes. Ensure the cytoband
     * is preloaded, and the cytoband starts with its chromosome number.
     */
    public void testGetCytobandPositions() throws Exception {
        
        // retrieve all human chromosomes
        Taxon taxon = new Taxon();
        taxon.setAbbreviation("Hs");
        List chromosomes = appService.search(Chromosome.class, taxon);

        System.out.println("Number\t#Cytobands\tTime(ms)");
        for (Object o : chromosomes) {
            Chromosome c = (Chromosome)o;

            long start = System.currentTimeMillis();
            Collection<CytobandPhysicalLocation> results = am.getCytobandPositions(c.getNumber());

            if (results.size() > 0) {
                for(CytobandPhysicalLocation location : results) {

                    assertNotNull(location.getCytoband());
                    
                    assertTrue("Cytoband name does not start with its " +
                            "chromosome number: "+ location.getCytoband().getName(),
                            location.getCytoband().getName().toLowerCase().startsWith(
                                c.getNumber().toLowerCase()));
                }
            }
            
            long end = System.currentTimeMillis();
            System.out.println(c.getNumber()+"\t"+results.size()+"\t"+(end-start));
        }
    }

    /**
     * Tests the getMicroarray method for all platforms. Ensures the 
     * name, manufacturer, and description fields are not null.
     */
    public void testGetMicroarray() throws Exception {

        List arrays = appService.search(Microarray.class, new Microarray());
        
        assertFalse("No microarrays found",arrays.isEmpty());
        
        for(Object mo : arrays) {
            Microarray m = (Microarray)mo;
            String array = m.getName();

            long start = System.currentTimeMillis();
            Microarray microarray = am.getMicroarray(array);
            long end = System.currentTimeMillis();
            
            System.out.println("getMicroarray("+array+") took "+(end-start)+" ms");
            
            assertNotNull(microarray.getName());
            assertNotNull(microarray.getManufacturer());
            assertNotNull(microarray.getDescription());
        }
    }

    /**
     * Tests the getGeneForSymbol method. 
     */
    public void testGetGeneForSymbol() throws Exception {
        
        long start = System.currentTimeMillis();
        Collection<Gene> genes = am.getGenesForSymbol("IL5");
        long end = System.currentTimeMillis();
        System.out.println("getGeneForSymbol() took "+(end-start)+" ms");
        
        assertNotNull(genes);
        assertTrue(genes.size()>0);
        
        for(Gene gene : genes) {
            assertNotNull(gene.getHugoSymbol());
        }
    }

    /**
     * Tests the getAliasesForGene method. Ensures the alias name is not null
     * for all returned aliases and that the associated gene is preloaded and
     * correct.
     */
    public void testGetAliasesForGene() throws Exception {
        
        String symbol = "IL2";
        
        long start = System.currentTimeMillis();
        Collection<GeneAlias> aliases = am.getAliasesForGene(symbol);
        long end = System.currentTimeMillis();
        System.out.println("getAliasesForGene() took "+(end-start)+" ms");
        
        assertFalse("Gene has no aliases",aliases.isEmpty());
        
        for(GeneAlias alias : aliases) {
            assertNotNull(alias.getName());
            assertNotNull(alias.getGeneCollection());
            
            // uncomment when SDK defect #12636 is fixed
            GeneAlias orig = (GeneAlias)ReflectionUtils.upwrap(alias);
            Collection<Gene> c = orig.getGeneCollection();
            for(Gene g : c) {
                assertEquals("HUGO symbol mismatch",symbol,g.getHugoSymbol());
            }
        }
    }
    
    /**
     * Tests the getReportersForSnps method.
     */
    public void testGetReportersForSnps() throws Exception {

        for(Iterator<List> i = getIterator(snps); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            HashMap<String, Collection<String>> results = am.getReportersForSnps(SNP_ARRAY,sublist);
            long end = System.currentTimeMillis();
            System.out.println("getReportersForSnps("+sublist.size()+" snps) took "+(end-start)+" ms");

            for(String symbol : sublist) {
                assertTrue("Missing SNP in results: "+symbol,results.containsKey(symbol));
                Collection<String> reporters = results.get(symbol);
                assertTrue("SNP has no reporters: "+symbol,!reporters.isEmpty());            
            }
            
            assertTrue("Result size is smaller than input size", 
                (sublist.size()<=results.size()));
        }
    }

    /**
     * Test the getSNPAnnotations with increasing lengths of SNP lists.
     */
    public void testGetSNPAnnotations() throws Exception {
         
        for(Iterator<List> i = getIterator(snps); i.hasNext(); ) {
            List<String> sublist = i.next();
            
            long start = System.currentTimeMillis();
            Collection<SNP> results = am.getSNPAnnotations(sublist);

            assertEquals("Result size is not equal to input size", 
                sublist.size(),results.size());
            
            for(SNP snp : results) {
                assertNotNull("SNP has no dbSNP id: "+snp.getId(),snp.getDBSNPID());
                
                for(PhysicalLocation o : snp.getPhysicalLocationCollection()) {
                    assertNotNull(o.getId());
                }
                
                for(CytogeneticLocation o : snp.getCytogeneticLocationCollection()) {
                    assertNotNull(o.getId());
                }
            }
            
            long end = System.currentTimeMillis();
            System.out.println("getSNPAnnotations("+sublist.size()+" SNPs) took "+(end-start)+" ms");
        }
    }

    /**
     * Tests getGenesForDbSnpId for a SNP with many related Genes.
     */
    public void testGetGenesForDbSnpId() throws Exception {
        
        long start = System.currentTimeMillis();
        Collection<Gene> results = am.getGenesForDbSnpId("rs200577");
        long end = System.currentTimeMillis();
        assertEquals("Number of genes",6,results.size());
        System.out.println("getGenesForDbSnpId() took "+(end-start)+" ms");
    }
    
    /**
     * Tests getSnpsNearGene on the default reference assembly.
     */
    public void testGetSnpsNearGene() throws Exception {

        String symbol = "A1CF";
        String assembly = "reference";
        
        Long pad = new Long(1);
        long start = System.currentTimeMillis();
        Collection<SNP> results = am.getSnpsNearGene(symbol,pad,pad);
        long end = System.currentTimeMillis();
		assertTrue("Less than 10 SNPs found near Gene",results.size()>10);
        
        verifySNPsNearGene(symbol, pad, assembly, results);
        
        System.out.println("getSnpsNearGene() took "+(end-start)+" ms");
    }
    
    /**
     * Tests getSnpsNearGene on the Celera alternate assembly.
     */
    public void testAlternateAssembly() throws Exception {

        String symbol = "A1CF";
        String assembly = "Celera";
        
        Long pad = new Long(0);
        long start = System.currentTimeMillis();
        Collection<SNP> results = am.getSnpsNearGene(symbol,pad,pad,assembly);
        long end = System.currentTimeMillis();
        assertTrue("Less than 10 SNPs found near Gene",results.size()>10);
        
        verifySNPsNearGene(symbol, pad, assembly, results);
        
        System.out.println("getSnpsNearGene() took "+(end-start)+" ms");
    }

    /**
     * Tests the Annotation API configured for the Mouse. Actually, this is
     * not very useful, since there are no Mouse microarrays in caBIO and 
     * the API only searches by HUGO symbol (which are null for mouse genes).
     * Nevertheless, let's make sure the parameter does something. 
     */
    public void testMouseTaxon() throws Exception {
        
        ArrayAnnotationService am = new ArrayAnnotationServiceImpl(appService, "Mm");
        
        List<CytobandPhysicalLocation> results = am.getCytobandPositions("1");
        
        assertFalse(results.isEmpty());
        
        for(CytobandPhysicalLocation loc : results) {
            assertEquals("Mm",loc.getChromosome().getTaxon().getAbbreviation());
        }
    }

    private void verifySNPsNearGene(String symbol, Long pad, String assembly, 
            Collection<SNP> results) throws Exception {

        long kbpad = pad * 1000;
        
        Collection<Gene> genes = am.getGenesForSymbol(symbol);
        
        // ensure each SNP actually falls in one of the gene CDS ranges
        for(SNP snp : results) {

            boolean inGene = false;
            Collection<SNPPhysicalLocation> spls = snp.getPhysicalLocationCollection();
            for(SNPPhysicalLocation spl : spls) {
                
                if (!spl.getAssembly().equals(assembly)) {
                    continue;
                }
                
                for(Gene gene : genes) {
                    
                    if (!spl.getChromosome().getId().equals(gene.getChromosome().getId())) {
                        continue;   
                    }
                    
                    Collection<GenePhysicalLocation> gpls = 
                        gene.getPhysicalLocationCollection();
                    
                    for(GenePhysicalLocation gpl : gpls) {
                        
                        if (!"CDS".equals(gpl.getFeatureType())) {
                            continue;
                        }
                        if (!spl.getAssembly().equals(gpl.getAssembly())) {
                            continue;
                        }
                        if (gpl.getChromosomalStartPosition()-kbpad > 
                                spl.getChromosomalStartPosition()) {
                            continue;
                        }
                        if (gpl.getChromosomalEndPosition()+kbpad < 
                                spl.getChromosomalEndPosition()) {
                            continue;
                        }
                        // SNP falls inside this exon
                        inGene = true;
                    }
                }
            }
            assertTrue("SNP "+snp.getDBSNPID()+" does not fall within any CDS region of gene "+symbol,inGene);
        }
    }

    private List<String> loadListFromFile(String fileName) throws Exception {

        List<String> result = new ArrayList<String>();
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader(fileName));
            String line = null;
            while ((line=br.readLine()) != null) {
                result.add(line);
            }
        }
        finally {
            if (br != null) br.close();
        }
        
        return result;
    }
    
    private Iterator<List> getIterator(List list) {
        if (BENCHMARK_SUBLISTS) {
            return new IncIterator(list);
        }
        return new OnceIterator(list);
    }
    
    public static void main(String[] argv) throws Exception {
        AnnotationAPITest test = new AnnotationAPITest();
        test.setUp();
        test.testGetReportersForSnps();
    }
}
