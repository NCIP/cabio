package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.httpclient.NameValuePair;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Any global data that must be queried from caBIO is available in this class.
 * One singleton instance is stored in the application context. This class
 * attempts to preload all of the data when an instance is created. If that 
 * fails (for example if the caBIO application server is down when the Portal is
 * started), we will instead attempt to load pieces of data as they are requested.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GlobalQueries {

    private static Log log = LogFactory.getLog(GlobalQueries.class);

    private static final int MIN_ASSEMBLY_COUNT = 100000;
    
    private CaBioApplicationService as; 
        
    private Map<String,List<Chromosome>> taxon2chroms = new HashMap<String,List<Chromosome>>();
    
    private List<Taxon> taxons = new ArrayList<Taxon>();
    
    private List<Microarray> microarrays;
    
    private List<NameValuePair> pathwaySources;
    
    private List<NameValuePair> assemblies;
    
    /**
     * Create a new instance of GlobalQueries and attempt to preload all the 
     * data necessary. Generally this object needs to be created only once
     * for the entire application, and stored in the application context. 
     */
    public GlobalQueries() {
        
        try {
            log.info("Preloading global data...");
            as = (CaBioApplicationService)ApplicationServiceProvider.getApplicationService();
            loadTaxonChromosomes();
            loadMicroarrays();
            loadPathwaySources();
            loadAssemblies();
            log.info("Completed preloading global data.");
            
        }
        catch (Exception e) {
            log.error("Error preloading global data",e);
        }
        
    }
    
    /**
     * Returns a map keyed by Taxon.abbreviation, with values consisting of 
     * lists of Chromosome objects corresponding to each Taxon. This method
     * may do a query if the data was not successfully preloaded when the 
     * portal was started up.
     * @return map of Taxon.abbreviation -> Chromosome list
     */
    public Map<String,List<Chromosome>> getTaxonChromosomes() {
        if (taxon2chroms == null || taxon2chroms.isEmpty()) loadTaxonChromosomes();
        return taxon2chroms;
    }

    /**
     * Returns a list of Taxons in caBIO which have associated Chromosomes. 
     * The last part is important, because there may be Taxons in caBIO 
     * which do NOT have Chromosomes, and are thus not useful to query on. 
     * @return list of Taxon objects
     */
    public List<Taxon> getTaxonValues() {
        if (taxons == null || taxons.isEmpty()) loadTaxonChromosomes();
        if (taxons == null || taxons.isEmpty()) return new ArrayList<Taxon>();
        return taxons;
    }

    /**
     * Returns a list of Microarrays in caBIO.
     * @return list of Microarray objects
     */
    public List<Microarray> getMicroarrays() {
        if (microarrays == null || microarrays.isEmpty()) loadMicroarrays();
        if (microarrays == null || microarrays.isEmpty()) return new ArrayList<Microarray>();
        return microarrays;
    }

    /**
     * Returns a list of Pathway providers in caBIO.
     * @return list of String objects
     */
    public List<NameValuePair> getPathwaySources() {
        if (pathwaySources == null || pathwaySources.isEmpty()) loadPathwaySources();
        if (pathwaySources == null || pathwaySources.isEmpty()) return new ArrayList<NameValuePair>();
        return pathwaySources;
    }

    /**
     * Returns a list of assemblies in caBIO.
     * @return list of assemblies
     */
    public List<NameValuePair> getAssemblies() {
        if (assemblies == null || assemblies.isEmpty()) loadAssemblies();
        if (assemblies == null || assemblies.isEmpty()) return new ArrayList<NameValuePair>();
        return assemblies;
    }

    /**
     * Returns the list of possible GenomicFeature enumeration values.
     * @return Array of GenomicFeature values
     */
    public GenomicFeature[] getClassFilterValues() {
        return GenomicFeature.values();
    }

    private void loadTaxonChromosomes() {

        try {
            log.info("Loading taxon and chromosome data...");
            List<Chromosome> results = as.search(Chromosome.class, new Chromosome());
            for (Chromosome c : results) {
                String taxon = c.getTaxon().getAbbreviation();
                if (!taxon2chroms.containsKey(taxon)) {
                    taxon2chroms.put(taxon, new ArrayList<Chromosome>());
                    taxons.add(c.getTaxon());
                }
                taxon2chroms.get(taxon).add(c);
            }
            
            // sort Taxons 
            Collections.sort(taxons, new Comparator<Taxon>() {
                public int compare(Taxon t1, Taxon t2) {
                    return t1.getAbbreviation().compareTo(t2.getAbbreviation());
                }
            });
            
            // sort each chromosome list
            for(Taxon t : taxons) {
                List<Chromosome> chromosomes = taxon2chroms.get(t.getAbbreviation());
                Collections.sort(chromosomes, new Comparator<Chromosome>() {
                    public int compare(Chromosome c1, Chromosome c2) {
                        String n1 = c1.getNumber();
                        String n2 = c2.getNumber();
                        if (n1.matches("^\\d+$")) {
                            return n2.matches("^\\d+$") ? new Long(n1).compareTo(new Long(n2)) : -1;
                        }
                        else {
                            return n2.matches("^\\d+$") ? 1 : n1.compareTo(n2);
                        }
                    }
                });
            }
            log.info("Done loading taxon and chromosome data.");
        }
        catch (Exception e) {
            log.error("Error loading taxon and chromosome data.",e);
        }
    }
    
    private void loadMicroarrays() {
        
        try {
            log.info("Loading microarray data...");
            microarrays = as.search(Microarray.class, new Microarray());
            log.info("Done loading microarray data.");
        }
        catch (Exception e) {
            log.error("Error loading microarray data.",e);
        }
    }
    
    private void loadPathwaySources() {
        
        try {
            log.info("Loading pathway data...");
            pathwaySources = new ArrayList<NameValuePair>();
            String hql = "select distinct source from gov.nih.nci.cabio.domain.Pathway";
            List<String> sources = as.query(new HQLCriteria(hql));
            for(String source : sources) {
                NameValuePair nv = new NameValuePair(source,source);
                pathwaySources.add(nv);
            }
              
            log.info("Done loading pathway data.");
        }
        catch (Exception e) {
            log.error("Error loading pathway data.",e);
        }
    }
    
    private void loadAssemblies() {
        
        try {
            log.info("Loading assembly data...");

            String hql = "select assembly, count(*) " +
                    "from gov.nih.nci.cabio.domain.PhysicalLocation " +
                    "group by assembly " +
                    "order by count(*) desc ";
            
            List<Object[]> results = as.query(new HQLCriteria(hql,
                QueryUtils.createCountQuery(hql),null));
         
            assemblies = new ArrayList<NameValuePair>();
            
            for(Object[] row : results) {
                String assembly = (String)row[0];                
                Long count = (Long)row[1];                
                if (count >= MIN_ASSEMBLY_COUNT) {                	
                    NameValuePair nv = new NameValuePair(
                        assembly+" ("+count.toString()+" locations)",assembly);
                    assemblies.add(nv);                    
                }
            }            
            log.info("Done loading assembly data.");
        }
        catch (Exception e) {
            log.error("Error loading assembly data.",e);
        }
    }
}
