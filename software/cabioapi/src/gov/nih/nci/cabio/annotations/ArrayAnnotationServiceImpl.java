package gov.nih.nci.cabio.annotations;

import gov.nih.nci.cabio.annotations.query.ExonReporterAnnotationsQuery;
import gov.nih.nci.cabio.annotations.query.ExprReporterAnnotationsQuery;
import gov.nih.nci.cabio.annotations.query.GeneAnnotationsQuery;
import gov.nih.nci.cabio.annotations.query.GenesForReportersQuery;
import gov.nih.nci.cabio.annotations.query.ReportersForGenesQuery;
import gov.nih.nci.cabio.annotations.query.ReportersForSNPQuery;
import gov.nih.nci.cabio.annotations.query.SNPAnnotationsQuery;
import gov.nih.nci.cabio.annotations.query.SNPReporterAnnotationsQuery;
import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.CytobandPhysicalLocation;
import gov.nih.nci.cabio.domain.ExonArrayReporter;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAlias;
import gov.nih.nci.cabio.domain.GenePhysicalLocation;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.cabio.domain.SNPPhysicalLocation;
import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.TreeSet;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.FetchMode;
import org.hibernate.Hibernate;
import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Disjunction;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;

/**
 * Implementation of the ArrayAnnotationService with user-specified taxon. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ArrayAnnotationServiceImpl implements ArrayAnnotationService {

    private static final Logger log = Logger.getLogger(ArrayAnnotationServiceImpl.class);

    private static final String DEFAULT_ASSEMBLY = "reference";
    
    private static final String GET_SNPS_NEAR_GENE_HQL = 
            "select pl from gov.nih.nci.cabio.domain.GenePhysicalLocation pl " +
            "left join pl.gene as gene " +
            "left join pl.gene.taxon as taxon " +
            "left join fetch pl.chromosome " +
            "where pl.chromosome = gene.chromosome " +
            "and pl.featureType = 'CDS' " + 
            "and pl.assembly = ? " +
            "and (gene.hugoSymbol = ? or gene.symbol = ?) " +
            "and taxon.abbreviation = ? ";

    private final CaBioApplicationService appService;
    
    private String taxon = "Hs"; 

    
    /**
     * Constructor defaults to Human annotations.
     * @param appService CaBioApplicationService
     */
	public ArrayAnnotationServiceImpl(CaBioApplicationService appService) {
        this.appService = appService;
    }
    
    /**
     * Constructor for a specified taxon. 
     * @param appService CaBioApplicationService
     * @param taxon value from Taxon.abbreviation
     */
    public ArrayAnnotationServiceImpl(CaBioApplicationService appService, 
            String taxon) {
        this.appService = appService;
        this.taxon = taxon;
    }
        
    public Map<String, Collection<String>> getGenesForReporters(
			String arrayPlatform, Collection<String> reporterIds) 
            throws ApplicationException {

		if (arrayPlatform == null) {
			throw new IllegalArgumentException("Array Platform type cannot be null");
		}
		if (reporterIds == null || reporterIds.isEmpty()) {
			throw new IllegalArgumentException("Reporter list must not be empty");
		}
        
        GenesForReportersQuery query = new GenesForReportersQuery(
            arrayPlatform, reporterIds);
        query.execute(appService);
        
		return query.getResults();
	}
    
	public Map<String, Collection<String>> getReportersForGenes(
            String arrayPlatform, Collection<String> geneSymbols) 
            throws ApplicationException {
        
        if (arrayPlatform == null) {
            throw new IllegalArgumentException("Array Platform type cannot be null");
        }
        if (geneSymbols == null || geneSymbols.isEmpty()) {
            throw new IllegalArgumentException("Gene list must not be empty");
        }
        
        ReportersForGenesQuery query = new ReportersForGenesQuery(
            arrayPlatform, geneSymbols);
        query.execute(appService);
		return query.getResults();
	}
	
    public Collection<ArrayReporter> getReportersForPlatform(
            String arrayPlatform) throws ApplicationException {

        Microarray microarray = new Microarray();
        microarray.setName(arrayPlatform);
        List results = appService.search(Microarray.class, microarray);
        microarray = (Microarray)results.iterator().next();
        
        if (microarray == null) {
            throw new ApplicationException(
                "Microarray with name '"+arrayPlatform+"' not found.");
        }
        
        return microarray.getArrayReporterCollection();
    }
    
    public Collection<ExpressionArrayReporter> getExpressionReporterAnnotations(
            String arrayPlatform, Collection<String> reporterIds) 
            throws ApplicationException {

        if (arrayPlatform == null) {
            throw new IllegalArgumentException("Array Platform type cannot be null");
        }
        if (reporterIds == null || reporterIds.isEmpty()) {
            throw new IllegalArgumentException("Reporter list must not be empty");
        }
        
        ExprReporterAnnotationsQuery query = new ExprReporterAnnotationsQuery(
            arrayPlatform, reporterIds);
        query.execute(appService);
        
        return query.getResults();
    }
    
    public Collection<ExonArrayReporter> getExonReporterAnnotations(
            String arrayPlatform, Collection<String> reporterIds) 
            throws ApplicationException {

        if (arrayPlatform == null) {
            throw new IllegalArgumentException("Array Platform type cannot be null");
        }
        if (reporterIds == null || reporterIds.isEmpty()) {
            throw new IllegalArgumentException("Reporter list must not be empty");
        }
        
        ExonReporterAnnotationsQuery query = new ExonReporterAnnotationsQuery(
            arrayPlatform, reporterIds);
        query.execute(appService);
        
        return query.getResults();
    }

    public Collection<SNPArrayReporter> getSNPReporterAnnotations(
            String arrayPlatform, Collection<String> reporterIds) 
            throws ApplicationException {

        if (arrayPlatform == null) {
            throw new IllegalArgumentException("Array Platform type cannot be null");
        }
        if (reporterIds == null || reporterIds.isEmpty()) {
            throw new IllegalArgumentException("Reporter list must not be empty");
        }
        
        SNPReporterAnnotationsQuery query = new SNPReporterAnnotationsQuery(
            arrayPlatform, reporterIds);
        query.execute(appService);
        
        return query.getResults();
    }
        
    public Collection<Gene> getGeneAnnotations(
                Collection<String> geneSymbols) throws ApplicationException{

        if (geneSymbols == null || geneSymbols.isEmpty()) {
            throw new IllegalArgumentException("Gene symbol list must not be empty");
        }
        
        GeneAnnotationsQuery query = new GeneAnnotationsQuery(geneSymbols, taxon);
        query.execute(appService);
        
        return query.getResults();
	}

    public List<CytobandPhysicalLocation> getCytobandPositions(
            String chromosomeNumber) 
            throws ApplicationException {
        return getCytobandPositions(chromosomeNumber, DEFAULT_ASSEMBLY);
    }
    
	public List<CytobandPhysicalLocation> getCytobandPositions(
            String chromosomeNumber, String assembly) 
            throws ApplicationException {
        
        DetachedCriteria criteria = 
            DetachedCriteria.forClass(CytobandPhysicalLocation.class);

        criteria.setFetchMode("cytoband", FetchMode.JOIN);
        criteria.setFetchMode("chromosome", FetchMode.JOIN);
        
        criteria.add(Restrictions.eq("assembly", assembly));
        
        criteria.createCriteria("chromosome").
            add(Restrictions.eq("number", chromosomeNumber)).
            createCriteria("taxon").
            add(Restrictions.eq("abbreviation", taxon));     
        
        List<CytobandPhysicalLocation> results = appService.query(criteria);
        return results;
	}
    
    public Microarray getMicroarray(String platformName) throws ApplicationException {
        
        Microarray microarray = new Microarray();
        microarray.setName(platformName);
        Iterator gi = appService.search(Microarray.class, microarray).iterator();
        if (gi.hasNext()) {
            return (Microarray)gi.next();
        }
        return null;
    }

    public Collection<Gene> getGenesForSymbol(String hugoSymbol) 
            throws ApplicationException {
                
        DetachedCriteria criteria = DetachedCriteria.forClass(Gene.class);
        
        criteria.createCriteria("taxon").add(Restrictions.eq("abbreviation", taxon));
        criteria.add(Restrictions.eq("hugoSymbol", hugoSymbol).ignoreCase());
        
        Collection<Gene> result = appService.query(criteria);
        return result;
    }

    public Collection<GeneAlias> getAliasesForGene(String symbol) 
            throws ApplicationException {
        
        DetachedCriteria criteria = DetachedCriteria.forClass(Gene.class);

        criteria.setFetchMode("geneAliasCollection", FetchMode.JOIN)
                .setResultTransformer(Criteria.DISTINCT_ROOT_ENTITY);

        criteria.add(Restrictions.eq("hugoSymbol", symbol).ignoreCase());
        criteria.createCriteria("taxon").add(Restrictions.eq("abbreviation", taxon));

        List<Gene> genes = appService.query(criteria);
        if (genes.isEmpty()) throw new ApplicationException(
            "No gene exists with HUGO symbol "+symbol);

        List<GeneAlias> results = new ArrayList<GeneAlias>();
        for(Gene g : genes) {
            results.addAll(g.getGeneAliasCollection());
        }
        
        return results;
    }
    
    public HashMap<String, Collection<String>> getReportersForSnps(
                String arrayPlatform, List<String> dbSnpIds) 
                throws ApplicationException {
        
        if (arrayPlatform == null) { 
            throw new IllegalArgumentException("Array Platform type cannot be null");
        }
        if (dbSnpIds == null || dbSnpIds.isEmpty()) {
            throw new IllegalArgumentException("SNP list must not be empty");
        }
        
        ReportersForSNPQuery query = new ReportersForSNPQuery(
            arrayPlatform, dbSnpIds);
        query.execute(appService);
        
        return query.getResults();
    }
    
    public Collection<SNP> getSNPAnnotations(List<String> dbSnpIds) 
            throws ApplicationException {
        
        if (dbSnpIds == null || dbSnpIds.isEmpty()) {
            throw new IllegalArgumentException("SNP list must not be empty");
        }
        
        SNPAnnotationsQuery query = new SNPAnnotationsQuery(dbSnpIds);
        query.execute(appService);
        
        return query.getResults();
    }
    
    public Collection<Gene> getGenesForDbSnpId(String dbSnpId) 
            throws ApplicationException {

        DetachedCriteria criteria = 
            DetachedCriteria.forClass(Gene.class).
            createCriteria("geneRelativeLocationCollection").
            createCriteria("SNP").add(Restrictions.eq("DBSNPID", dbSnpId));
        
        List<Gene> results = appService.query(criteria);
        return results;
    }
    
    public Collection<SNP> getSnpsNearGene(String symbol, Long kbUpstream, 
            Long kbDownstream) throws ApplicationException {
        return getSnpsNearGene(symbol, kbUpstream, kbDownstream, DEFAULT_ASSEMBLY);
    }
    
    public Collection<SNP> getSnpsNearGene(String symbol, 
            Long kbUpstream, Long kbDownstream, String assembly) throws ApplicationException {

        List params = new ArrayList();
        params.add(assembly);
        params.add(symbol);
        params.add(symbol);
        params.add(taxon);
        
        Collection<GenePhysicalLocation> result = appService.query(
            new HQLCriteria(GET_SNPS_NEAR_GENE_HQL,
                QueryUtils.createCountQuery(GET_SNPS_NEAR_GENE_HQL),params));

        if (result == null || result.isEmpty()) 
            throw new ApplicationException("No genes found for symbol "+symbol);
        
        Collection<GenomeRange> rawRanges = new TreeSet<GenomeRange>();
        
        Long upPad = kbUpstream * 1000;
        Long downPad = kbDownstream * 1000;
        Long chromosomeId = null;
        
        // construct all padded ranges
        for(GenePhysicalLocation pl : result) {
            if (chromosomeId == null) chromosomeId = pl.getChromosome().getId();

            rawRanges.add(new GenomeRange(
                pl.getChromosomalStartPosition() - upPad,
                pl.getChromosomalEndPosition() + downPad));
        }

        // combine overlapping ranges
        Collection<GenomeRange> ranges = new ArrayList<GenomeRange>();
        GenomeRange last = null;
        for(GenomeRange gr : rawRanges) {
            if ((last == null) || (last.getEnd() < gr.getStart()-1)) {
                ranges.add(gr);    
                last = gr;
            }
            else if (gr.getEnd() > last.getEnd()) {
                last.setEnd(gr.getEnd());
            }
        }

        // query for SNPs on the given assembly in the combined ranges        
        DetachedCriteria dc = DetachedCriteria.forClass(SNP.class)
                .createCriteria("physicalLocationCollection")
                .add(Restrictions.eq("assembly",assembly));
        
        Disjunction or = Restrictions.disjunction();
        for(GenomeRange gr : ranges) {
            or.add(Restrictions.and(
                    Restrictions.ge("chromosomalStartPosition",gr.getStart()), 
                    Restrictions.le("chromosomalEndPosition",gr.getEnd())));
        }
        
        dc.add(or).addOrder(Order.asc("chromosomalStartPosition")).add( 
                Restrictions.sqlRestriction("{alias}.chromosome_id = ?", 
                chromosomeId, Hibernate.LONG));
        
        List<SNP> results = appService.query(dc);
        return results;
    }
    
    /**
     * Used to calculate overlapping genome ranges.
     */
    private class GenomeRange implements Comparable {
        
        private final Long start;
        private Long end;
        
        public GenomeRange(Long start, Long end) {
            super();
            this.start = start;
            this.end = end;
        }
        
        public Long getEnd() {
            return end;
        }
        
        public Long getStart() {
            return start;
        }
        
        public void setEnd(Long end) {
            this.end = end;
        }

        @Override
        public int hashCode() {
            final int PRIME = 31;
            int result = 1;
            result = PRIME * result + ((end == null) ? 0 : end.hashCode());
            result = PRIME * result + ((start == null) ? 0 : start.hashCode());
            return result;
        }

        @Override
        public boolean equals(Object o) {
            return (start.equals(((GenomeRange)o).getStart()) 
                    && end.equals(((GenomeRange)o).getEnd()));
        }

        public int compareTo(Object o) {
            int c = start.compareTo(((GenomeRange)o).getStart());
            if (c != 0) return c;
            return end.compareTo(((GenomeRange)o).getEnd());
        }
    }
}
