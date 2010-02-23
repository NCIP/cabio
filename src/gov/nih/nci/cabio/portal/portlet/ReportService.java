package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.ArrayReporterPhysicalLocation;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.cabio.domain.GeneDiseaseAssociation;
import gov.nih.nci.cabio.domain.GeneFunctionAssociation;
import gov.nih.nci.cabio.domain.GeneOntology;
import gov.nih.nci.cabio.domain.GenePhysicalLocation;
import gov.nih.nci.cabio.domain.MarkerPhysicalLocation;
import gov.nih.nci.cabio.domain.NucleicAcidPhysicalLocation;
import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.cabio.domain.SNPPhysicalLocation;
import gov.nih.nci.cabio.domain.TranscriptPhysicalLocation;
import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.common.util.ReflectionUtils;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Convenience class for Templated Searches. The queries defined here do 
 * some eager-fetching of results. Note that due to an SDK limitation, it 
 * best to never eager-fetch associations with a cardinality greater than 1 
 * (i.e. any collection).
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class ReportService {

    private static Log log = LogFactory.getLog(ReportService.class);
    
    private static final String PHYSICAL_LOCATION_HQL = 
             "select loc from gov.nih.nci.cabio.domain.PhysicalLocation loc " +
             "left outer join fetch loc.chromosome as chrom " +
             "where ";
    
    private static final String GENES_BY_AGENT_HQL = 
             "select assoc from gov.nih.nci.cabio.domain.GeneAgentAssociation assoc " +
             "left outer join fetch assoc.gene as gene " +
             "left outer join fetch assoc.agent as agent " +
             "where ";

    private static final String GENES_BY_AGENT_EVIDENCE_HQL = 
        "select assoc from gov.nih.nci.cabio.domain.GeneAgentAssociation assoc " +
        "left join fetch assoc.gene as gene " +
        "left join fetch assoc.agent as agent " +
        "left join fetch assoc.evidenceCollection as evidence " +
        "where ";
    
    private static final String GENES_BY_AGENT_HQL_WHERE_NAME = 
             "lower(agent.name) like ?";

    private static final String GENES_BY_AGENT_HQL_WHERE_CUI = 
             "lower(agent.EVSId) like ?";
     
    private static final String GENES_BY_DISEASE_HQL = 
             "select assoc from gov.nih.nci.cabio.domain.GeneDiseaseAssociation assoc " +
             "left outer join fetch assoc.gene as gene " +
             "left outer join fetch assoc.diseaseOntology as disease " +
             "where ";

    private static final String GENES_BY_DISEASE_EVIDENCE_HQL = 
        "select assoc from gov.nih.nci.cabio.domain.GeneDiseaseAssociation assoc " +
        "left join fetch assoc.gene as gene " +
        "left join fetch assoc.diseaseOntology as disease " +
        "left join fetch assoc.evidenceCollection as evidence " +
        "where ";

    private static final String GENES_BY_DISEASE_HQL_WHERE_NAME = 
             "lower(disease.name) like ?";

    private static final String GENES_BY_DISEASE_HQL_WHERE_CUI = 
             "lower(disease.EVSId) like ?";
    
    private static final String GENE_ASSOCIATIONS_HQL = 
             "select assoc from gov.nih.nci.cabio.domain.GeneFunctionAssociation assoc " +
             "left outer join fetch assoc.gene as gene " +
             "left outer join gene.geneAliasCollection alias " +
             "where ";

    private static final String GENE_ASSOCIATIONS_EVIDENCE_HQL = 
            "select assoc from gov.nih.nci.cabio.domain.GeneFunctionAssociation assoc " +
            "left join fetch assoc.evidenceCollection as evidence " +
            "left join fetch assoc.gene as gene " +
            "left outer join gene.geneAliasCollection alias " +
            "where ";
    
    private static final String GENE_ASSOCIATIONS_HQL_WHERE = 
            "(lower(gene.symbol) like ? or lower(alias.name) like ?)";

    private static final String EVIDENCE_NEGATION_STATUS_WHERE = 
                                       "evidence.negationStatus=?";
    private static final String EVIDENCE_CELLLINE_STATUS_WHERE = 
                              "evidence.celllineStatus=?";
    private static final String EVIDENCE_SENTENCE_STATUS_WHERE = 
            "evidence.sentenceStatus=?";
    
    private static final String REPORTERS_BY_GENE_HQL = 
             "select reporter from gov.nih.nci.cabio.domain.ExpressionArrayReporter reporter " +
             "left outer join fetch reporter.microarray " +
             "left outer join fetch reporter.gene as gene " +
             "left outer join gene.geneAliasCollection alias " +
             "where ";
    
    private static final String REPORTERS_BY_GENE_HQL_WHERE = 
             "(lower(gene.symbol) like ? or lower(alias.name) like ?)";

    private static final String REPORTERS_BY_SNP_HQL = 
             "select reporter from gov.nih.nci.cabio.domain.SNPArrayReporter reporter " +
             "left outer join fetch reporter.SNP as SNP " +
             "left outer join fetch reporter.microarray " +
             "where ";
    
    private static final String REPORTERS_BY_SNP_HQL_WHERE = 
             "lower(SNP.DBSNPID) = ?";

    private static final String GENES_BY_SYMBOL_HQL = 
             "select gene from gov.nih.nci.cabio.domain.Gene gene " +
             "left outer join gene.geneAliasCollection alias " +
             "left outer join fetch gene.chromosome " +
             "left outer join fetch gene.taxon as taxon " +
             "where ";
             
    private static final String GENES_BY_SYMBOL_HQL_WHERE = 
            "(lower(gene.symbol) like ? or lower(alias.name) like ?)";

     private static final String GO_BY_SYMBOL_HQL = 
             "select distinct geneOntology from gov.nih.nci.cabio.domain.GeneOntology geneOntology " +
             "left outer join geneOntology.geneCollection as genes " +
             "left outer join genes.proteinCollection as proteins " +
             "where "; 

    private static final String GO_BY_PROTEIN_NAME_HQL_WHERE = 
             "lower(proteins.name) like ?";

    private static final String GO_BY_PROTEIN_ACCESSION_HQL_WHERE = 
             "lower(proteins.primaryAccession) like ?";
     
    private static final String PATHWAY_BY_SYMBOL_HQL = 
            "select pathway from gov.nih.nci.cabio.domain.Pathway pathway " +
            "left join fetch pathway.taxon as taxon " +
            "left join pathway.geneCollection as genes " +
            "left outer join genes.geneAliasCollection alias " +
            "where ";

    private static final String PATHWAY_BY_SYMBOL_HQL_WHERE = 
            "(lower(genes.symbol) like ? or lower(alias.name) like ?)";
    
    private static final String PATHWAY_BY_PROTEIN_HQL = 
            "select pathway from gov.nih.nci.cabio.domain.Pathway pathway " +
            "left join fetch pathway.taxon as taxon " +
            "left join pathway.geneCollection as genes " +
            "left join genes.proteinCollection as proteins " +
            "where ";
    
    private static final String PATHWAY_BY_PROTEIN_NAME_HQL = 
    		"lower(proteins.name) like ?";
    		
    private static final String PATHWAY_BY_PROTEIN_PRIMARY_ACCESSION_HQL =
            "lower(proteins.primaryAccession) like ?";
            
		 
    private final CaBioApplicationService appService;
    
    private Map<Class, String> detailObjectHQL = new HashMap<Class, String>();
    
    static public String EVIDENCE_SENTENCE_STATUS_FINISHED = "finished";    
    static public String EVIDENCE_CELLLINE_DATA = "yes";
    
    /**
     * Constructor 
     * @param appService CaBioApplicationService
     */
    public ReportService(CaBioApplicationService appService) {
        this.appService = appService;

        detailObjectHQL.put(GenePhysicalLocation.class, PHYSICAL_LOCATION_HQL);
        detailObjectHQL.put(ArrayReporterPhysicalLocation.class, PHYSICAL_LOCATION_HQL);
        detailObjectHQL.put(NucleicAcidPhysicalLocation.class, PHYSICAL_LOCATION_HQL);
        detailObjectHQL.put(SNPPhysicalLocation.class, PHYSICAL_LOCATION_HQL);
        detailObjectHQL.put(MarkerPhysicalLocation.class, PHYSICAL_LOCATION_HQL);
        detailObjectHQL.put(TranscriptPhysicalLocation.class, PHYSICAL_LOCATION_HQL);
        
        detailObjectHQL.put(GeneAgentAssociation.class, GENES_BY_AGENT_HQL);
        detailObjectHQL.put(GeneDiseaseAssociation.class, GENES_BY_DISEASE_HQL);
        detailObjectHQL.put(GeneFunctionAssociation.class, GENE_ASSOCIATIONS_HQL);
        detailObjectHQL.put(ExpressionArrayReporter.class, REPORTERS_BY_GENE_HQL);
        detailObjectHQL.put(SNPArrayReporter.class, REPORTERS_BY_SNP_HQL);
        detailObjectHQL.put(Gene.class, GENES_BY_SYMBOL_HQL);
        detailObjectHQL.put(Pathway.class, PATHWAY_BY_SYMBOL_HQL);
    }
    
    /**
     * Returns the Collection association for the specified object and rolename.
     * @param clazz A caBIO bean class 
     * @param id Internal caBIO id of the object
     * @param targetAssoc rolename of the association to follow 
     * @return Object with certain associations preloaded
     * @throws ApplicationException
     */
    public List getDetailObjects(Class clazz, Long id, String targetAssoc) 
            throws Exception {

        if (!clazz.getPackage().getName().startsWith("gov.nih.nci.cabio.")) {
            throw new ApplicationException("Invalid class specified.");
        }
        
        Object criteria = clazz.newInstance();
        ReflectionUtils.set(criteria, "id", id);
        List results = appService.getAssociation(criteria, targetAssoc);
                
        if (results.isEmpty()) return null;
        return results;
    }

    /**
     * Returns the detail object graph for the specified class/id combination.
     * @param clazz A caBIO bean class 
     * @param id Internal caBIO id of the object
     * @return Object with certain associations preloaded
     * @throws ApplicationException
     */
    public Object getDetailObject(Class clazz, Long id) 
            throws ApplicationException {
        
        String hql =detailObjectHQL.get(clazz);

        if (hql == null) {
            hql = "from "+clazz.getName()+" o where o.id = ?";
        }
        else {
            Matcher m = Pattern.compile("^select (\\w+?) from.*").matcher(hql);
            m.find();
            String target = m.group(1);
            hql += target + ".id = ?";
        }
        
        List<Long> params = new ArrayList<Long>();
        params.add(id);
        List results = appService.query(new HQLCriteria(hql, params));
                
        if (results.isEmpty()) return null;
        return results.iterator().next();
    }
    
    /**
     * Returns all gene associations for a given agent.  
     * @param agentNameOrCui Agent.name or Agent.EVSId
     * @return List of GeneAgentAssociation, with preloaded genes and agents
     * @throws ApplicationException
     */
    public List<GeneAgentAssociation> getGenesByAgent(String agentNameOrCui) 
            throws ApplicationException {

        String nameOrCui = convertInput(agentNameOrCui);
        List<String> params = getListWithId(nameOrCui);
        
        String hql = GENES_BY_AGENT_HQL;
        if (nameOrCui.matches("^c(\\d+)%?$")) {
            hql += GENES_BY_AGENT_HQL_WHERE_CUI;
        }
        else {
            hql += GENES_BY_AGENT_HQL_WHERE_NAME;
        }

        return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }


    /**
     * Returns all gene associations for a given agent.  
     * @param agentNameOrCui Agent.name or Agent.EVSId
     * @param negationStatus   Evidence.negationStatus
     * @param finishedSentence Evidence.finishedSentence
     * @param celllineStatus   Evidence.celllineStatus          
     * @return List of GeneAgentAssociation, with preloaded genes and agents
     * @throws ApplicationException
     */
    public List<GeneAgentAssociation> getGenesByAgentWithEvidenceProperties(
    		String agentNameOrCui, String negationStatus, 
            String finishedSentence, String celllineStatus) 
            throws ApplicationException {

        String nameOrCui = convertInput(agentNameOrCui);
        List<String> params = getListWithId(nameOrCui);
        
        String hql = GENES_BY_AGENT_EVIDENCE_HQL;
        if (nameOrCui.matches("^c(\\d+)%?$")) {
            hql += GENES_BY_AGENT_HQL_WHERE_CUI;
        }
        else {
            hql += GENES_BY_AGENT_HQL_WHERE_NAME;
        }

        hql += composeEvidencePropertiesWhereClause(negationStatus, 
	            finishedSentence, celllineStatus, params);
        
        return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }
        
    /**
     * Returns all gene associations for a given disease.  
     * @param diseaseNameOrCui Disease.name or Disease.EVSId
     * @return List of GeneDiseaseAssociation, with preloaded genes and diseases
     * @throws ApplicationException
     */
    public List<GeneDiseaseAssociation> getGenesByDisease(
            String diseaseNameOrCui) throws ApplicationException {

        String nameOrCui = convertInput(diseaseNameOrCui);
        List<String> params = getListWithId(nameOrCui);

        String hql = GENES_BY_DISEASE_HQL;
        if (nameOrCui.matches("^c(\\d+)%?$")) {
            hql += GENES_BY_DISEASE_HQL_WHERE_CUI;
        }
        else {
            hql += GENES_BY_DISEASE_HQL_WHERE_NAME;
        }

        return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }
    
    /**
     * Returns all gene associations for a given disease
     * @param diseaseNameOrCui Disease.name or Disease.EVSId
     * @param negationStatus   Evidence.negationStatus
     * @param finishedSentence Evidence.finishedSentence
     * @param celllineStatus   Evidence.celllineStatus     
     * @return List of GeneDiseaseAssociation, with preloaded genes and diseases
     * @throws ApplicationException
     */
    public List<GeneDiseaseAssociation> getGenesByDiseaseWithEvidenceProperties(
                    String diseaseNameOrCui, String negationStatus, 
                    String finishedSentence, String celllineStatus) throws ApplicationException {

        String nameOrCui = convertInput(diseaseNameOrCui);
        List<String> params = getListWithId(nameOrCui);

        String hql = GENES_BY_DISEASE_EVIDENCE_HQL;
        if (nameOrCui.matches("^c(\\d+)%?$")) {
            hql += GENES_BY_DISEASE_HQL_WHERE_CUI;
        }
        else {
            hql += GENES_BY_DISEASE_HQL_WHERE_NAME;
        }

        hql += composeEvidencePropertiesWhereClause(negationStatus, 
	            finishedSentence, celllineStatus, params);
        
        return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }

    
    /**
     * Returns all gene associations for a given gene symbol.  
     * @param geneSymbol Gene.symbol or Gene.hugoSymbol
     * @param negationStatus   Evidence.negationStatus
     * @param finishedSentence Evidence.finishedSentence
     * @param celllineStatus   Evidence.celllineStatus     
     * @return List of GeneDiseaseAssociation, with preloaded genes 
     * @throws ApplicationException
     */
    public List<GeneFunctionAssociation> getGeneAssociationsWithEvidenceProperties(
            String geneSymbol, String negationStatus, String finishedSentence, String celllineStatus) throws ApplicationException {
         
        String hql = GENE_ASSOCIATIONS_EVIDENCE_HQL                      
                     + GENE_ASSOCIATIONS_HQL_WHERE;
        String symbol = convertInput(geneSymbol);
        List<String> params = getListWithId(symbol);
        params.add(symbol);
        
        hql += composeEvidencePropertiesWhereClause(negationStatus, 
        		            finishedSentence, celllineStatus, params);
        
        return filterDuplicates(appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params)));
    }
    
    /**
     * @param negationStatus   Evidence.negationStatus
     * @param finishedSentence Evidence.finishedSentence
     * @param celllineStatus   Evidence.celllineStatus
     * @param params the parameters for HQL query
     * @return where clause for the Evidence properties 
     */
    private String composeEvidencePropertiesWhereClause(String negationStatus, 
    		                       String finishedSentence, String celllineStatus,
    		                       List<String> params)
    {
    	StringBuffer evWhere = new StringBuffer();
    	
        if ( "yes".equalsIgnoreCase( negationStatus) || "no".equalsIgnoreCase(negationStatus))
        {
        	evWhere.append(" and " +  EVIDENCE_NEGATION_STATUS_WHERE);
	        params.add(negationStatus);          	
        } // otherwise, query for all the negationStatus
        
        if ( "on".equalsIgnoreCase(finishedSentence))
        {
        	evWhere.append(" and " + EVIDENCE_SENTENCE_STATUS_WHERE);
	        params.add(EVIDENCE_SENTENCE_STATUS_FINISHED);
        } 
        
        if ( "on".equalsIgnoreCase(celllineStatus))
        {
        	evWhere.append(" and " + EVIDENCE_CELLLINE_STATUS_WHERE);
	        params.add(EVIDENCE_CELLLINE_DATA);
        }

    	return evWhere.toString();
    }
    
    /**
     * Returns all gene associations for a given gene symbol.  
     * @param geneSymbol Gene.symbol or Gene.hugoSymbol
     * @return List of GeneDiseaseAssociation, with preloaded genes 
     * @throws ApplicationException
     */
    public List<GeneFunctionAssociation> getGeneAssociations(
            String geneSymbol) throws ApplicationException {
         
        String hql = GENE_ASSOCIATIONS_HQL+GENE_ASSOCIATIONS_HQL_WHERE;
        String symbol = convertInput(geneSymbol);
        List<String> params = getListWithId(symbol);
        params.add(symbol);
        return filterDuplicates(appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params)));
    }

    
    /**
     * Returns all reporters for a given gene symbol.  
     * @param geneSymbol Gene.symbol or Gene.hugoSymbol
     * @return List of ExpressionArrayReporter, with preloaded genes and microarrays
     * @throws ApplicationException
     */
    public List<ExpressionArrayReporter> getReportersByGene(
            String geneSymbol) throws ApplicationException {

        String hql = REPORTERS_BY_GENE_HQL+REPORTERS_BY_GENE_HQL_WHERE;
        String symbol = convertInput(geneSymbol);
        List<String> params = getListWithId(symbol);
        params.add(symbol);
        return filterDuplicates(appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params)));
    }
    
    
    /**
     * Returns all reporters for a given SNP.  
     * @param dbSNPId SNP.DBSNPID
     * @return List of SNPArrayReporter, with preloaded genes and SNPs
     * @throws ApplicationException
     */
    public List<SNPArrayReporter> getReportersBySNP(
            String dbSNPId) throws ApplicationException {

        String hql = REPORTERS_BY_SNP_HQL+REPORTERS_BY_SNP_HQL_WHERE;
        List<String> params = new ArrayList<String>();
        params.add(dbSNPId.toLowerCase().trim());
        return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }
    
    
    /**
     * Returns all genes for a given symbol.  
     * @param geneSymbol
     * @return List of Genes, with preloaded taxons, chromosomes, and the 
     *         locus link id in DatabaseCrossReference. 
     * @throws ApplicationException
     */
    public List<Gene> getGenesBySymbol(
            String geneSymbol) throws ApplicationException {

        String hql = GENES_BY_SYMBOL_HQL+GENES_BY_SYMBOL_HQL_WHERE;
        String symbol = convertInput(geneSymbol);
        List<String> params = getListWithId(symbol);
        params.add(symbol);
        return filterDuplicates(appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params)));
    }
   
    /**
     * Returns all gene ontology associations for a given protein name or accession.  
     * @param proteinNameAccession
     * @return List of GeneOntologies. 
     * @throws ApplicationException
     */
    public List<GeneOntology> getGoByProtein(
            String proteinNameAccession) throws ApplicationException {

        String hql = GO_BY_SYMBOL_HQL+GO_BY_PROTEIN_NAME_HQL_WHERE+" OR "+GO_BY_PROTEIN_ACCESSION_HQL_WHERE;
        List<String> params = getListWithId(convertInput(proteinNameAccession));
        params.add(convertInput(proteinNameAccession));
        return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }
    
    
    /**
     * Returns all pathways for a given name.
     * @param pathwayName (Name of the pathway)
     * @return List of Pathways. 
     * @throws ApplicationException
     */
    public List<Pathway> getPathwaysByName(
            String pathwayName) throws ApplicationException {
        
        String inputName = pathwayName.trim();
        
        if ("".equals(inputName)) return new ArrayList<Pathway>();
        
        Pathway pathway = new Pathway();
        pathway.setName(inputName);
        
        return appService.search(Pathway.class, pathway);
    }
    
          
    /**
     * Returns all pathways for a given protein name or accession.
     * @param proteinNameAccession (protein Name or accession)
     * @return List of Pathways. 
     * @throws ApplicationException
     */
    public List<Pathway> getPathwaysByProtein(
            String proteinNameAccession) throws ApplicationException {
        
       String inputNameAccession = proteinNameAccession.trim();

       String hql = PATHWAY_BY_PROTEIN_HQL+PATHWAY_BY_PROTEIN_NAME_HQL+" OR "+PATHWAY_BY_PROTEIN_PRIMARY_ACCESSION_HQL;
        List<String> params = getListWithId(convertInput(inputNameAccession));
        params.add(convertInput(inputNameAccession));        
       return appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params));
    }
 
  
    /**
     * Returns all pathways for a given source.
     * @param pathwayName (Source of the pathway)
     * @return List of Pathways. 
     * @throws ApplicationException
     */
    public List<Pathway> getPathwaysBySource(
            String pathwaySource) throws ApplicationException {
        
        String inputSource = pathwaySource.trim();
        
        if ("".equals(inputSource)) return new ArrayList<Pathway>();
        
        Pathway pathway = new Pathway();
        pathway.setSource(inputSource);
        
        return appService.search(Pathway.class, pathway);
    }
    
    /**
     * Returns all pathways for a given symbol.  
     * @param geneSymbol (Gene Symbol)
     * @return List of Pathways. 
     * @throws ApplicationException
     */
     public List<Pathway> getPathwaysByGeneSymbol(
            String geneSymbol) throws ApplicationException {

        String hql = PATHWAY_BY_SYMBOL_HQL+PATHWAY_BY_SYMBOL_HQL_WHERE;
        String symbol = convertInput(geneSymbol);
        List<String> params = getListWithId(symbol);
        params.add(symbol);
        return filterDuplicates(appService.query(new HQLCriteria(hql,
            QueryUtils.createCountQuery(hql),params)));
     }

     /**
      * Filters duplicate objects based on id. The objects must all have a 
      * getId() method.
      * @param objects
      * @return
      */
     private List filterDuplicates(List<Object> objects) throws ApplicationException {
         Map map = new LinkedHashMap();
         try {
             for(Object o : objects) {
                 map.put(ReflectionUtils.get(o, "id"), o);
             }
         }
         catch (Exception e) {
             throw new ApplicationException(e);
         }
         return new ArrayList(map.values());
     }
     
     /**
      * Converts input for use in HQL. Converts to lower case and replaces
      * star (*) wildcards with amperstand (%) wildcards.
      * @param input
      * @return converted input
      */
     private String convertInput(String input) {
         return input.toLowerCase().trim().replaceAll("\\*", "%");
     }

     /**
      * Shortcut method to create a parameter array with the same parameter twice.
      * @param id
      * @return
      */
     private List<String> getListWithId(String id) {
         List<String> params = new ArrayList<String>();
         params.add(id);
         return params;
     }
}
