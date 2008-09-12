package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.Taxon;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public class StaticQueries {

    private static Log log = LogFactory.getLog(StaticQueries.class);
    
    private static final String GET_DISTINCT_ASSEMBLIES_HQL = 
        "select distinct assembly from gov.nih.nci.cabio.domain.PhysicalLocation";
    
    private static CaBioApplicationService as; 
        
    private static Map<String,List<Chromosome>> taxon2chroms = new HashMap<String,List<Chromosome>>();
    
    private static List<Taxon> taxons = new ArrayList<Taxon>();

    private static List<String> assemblyValues;
    
    private static List<Microarray> microarrays;
    
    static {

        log.info("Loading static data...");
        
        try {
            as = (CaBioApplicationService)ApplicationServiceProvider.getApplicationService();
            
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

            // load assembly values
            assemblyValues = new ArrayList<String>();
            assemblyValues.add("reference");
            // TODO: add index for assembly
            //assemblyValues = as.query(new HQLCriteria(GET_DISTINCT_ASSEMBLIES_HQL));
            Collections.sort(assemblyValues);
            
            // load microarrays
            microarrays = as.search(Microarray.class, new Microarray());
            
            log.info("Completed loading static data.");
        }
        catch (Exception e) {
            log.error("Error creating AbsoluteRangeQueryAction",e);
        }
    }
    
    public static Map<String,List<Chromosome>> getTaxonChromosomes() {
        return taxon2chroms;
    }
    
    public static List<Taxon> getTaxonValues() {
        return taxons;
    }

    public static List<String> getAssemblyValues() {
        return assemblyValues;
    }

    public static List<Microarray> getMicroarrays() {
        return microarrays;
    }
    
}
