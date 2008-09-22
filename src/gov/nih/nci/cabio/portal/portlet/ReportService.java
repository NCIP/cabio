package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.domain.GeneAgentAssociation;
import gov.nih.nci.cabio.domain.GeneDiseaseAssociation;
import gov.nih.nci.cabio.domain.GeneFunctionAssociation;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.List;

/**
 * Convenience class for queries in the canned reports portlet. The queries 
 * defined here do some eager-fetching of results. Note that due to SDK defects,
 * it best to never eager-fetch associations with a cardinality greater than 1.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ReportService {

    private static final String GENES_BY_AGENT_HQL = 
             "select assoc from gov.nih.nci.cabio.domain.GeneAgentAssociation assoc " +
             "left join fetch assoc.gene as gene " +
             "left join  assoc.agent as agent " +
             "left join fetch assoc.evidence " +
             "where (lower(agent.name) like ? or lower(agent.EVSId) like ?)";

    private static final String GENES_BY_DISEASE_HQL = 
             "select assoc from gov.nih.nci.cabio.domain.GeneDiseaseAssociation assoc " +
             "left join fetch assoc.gene as gene " +
             "left join fetch assoc.diseaseOntology as disease " +
             "left join fetch assoc.evidence " +
             "where (lower(disease.name) like ? or lower(disease.EVSId) like ?)";

    private static final String GENE_ASSOCIATIONS_HQL = 
             "select assoc from gov.nih.nci.cabio.domain.GeneFunctionAssociation assoc " +
             "left join fetch assoc.gene as gene " +
             "left join fetch assoc.evidence " +
             "where (lower(gene.symbol) like ? or lower(gene.hugoSymbol) like ?)";

    private static final String REPORTERS_BY_GENE_HQL = 
             "select reporter from gov.nih.nci.cabio.domain.ExpressionArrayReporter reporter " +
             "left join fetch reporter.gene as gene " +
             "left join fetch reporter.microarray " +
             "where (lower(gene.symbol) like ? or lower(gene.hugoSymbol) like ?)";

    private static final String REPORTERS_BY_SNP_HQL = 
             "select reporter from gov.nih.nci.cabio.domain.SNPArrayReporter reporter " +
             "left join fetch reporter.SNP as SNP " +
             "left join fetch reporter.microarray " +
             "where lower(SNP.DBSNPID) = ?";

    private static final String GENES_BY_SYMBOL_HQL = 
             "select gene from gov.nih.nci.cabio.domain.Gene gene " +
             "left join fetch gene.databaseCrossReferenceCollection as dbxr " +
             "left join fetch gene.chromosome " +
             "left join fetch gene.taxon as taxon " +
             "where dbxr.dataSourceName = 'LOCUS_LINK_ID' " +
             "and (lower(gene.hugoSymbol) like ? or lower(gene.symbol) like ?)";
     
    
    private final CaBioApplicationService appService;
    
    /**
     * Constructor 
     * @param appService CaBioApplicationService
     */
    public ReportService(CaBioApplicationService appService) {
        this.appService = appService;
    }
    
    /**
     * Returns all gene associations for a given agent.  
     * @param agentNameOrCui Agent.name or Agent.EVSId
     * @return List of GeneAgentAssociation, with preloaded genes, agents 
     *         and evidences
     * @throws ApplicationException
     */
    public List<GeneAgentAssociation> getGenesByAgent(String agentNameOrCui) 
            throws ApplicationException {

        List<String> params = duplicateId(agentNameOrCui.toLowerCase());
        return appService.query(new HQLCriteria(GENES_BY_AGENT_HQL,params));
    }

    /**
     * Returns all gene associations for a given disease.  
     * @param diseaseNameOrCui Disease.name or Disease.EVSId
     * @return List of GeneDiseaseAssociation, with preloaded genes, agents 
     *         and evidences
     * @throws ApplicationException
     */
    public List<GeneDiseaseAssociation> getGenesByDisease(
            String diseaseNameOrCui) throws ApplicationException {

        List<String> params = duplicateId(diseaseNameOrCui.toLowerCase());
        return appService.query(new HQLCriteria(GENES_BY_DISEASE_HQL,params));
    }
    

    /**
     * Returns all gene associations for a given gene symbol.  
     * @param geneSymbol Gene.symbol or Gene.hugoSymbol
     * @return List of GeneDiseaseAssociation, with preloaded genes and evidences
     * @throws ApplicationException
     */
    public List<GeneFunctionAssociation> getGeneAssociations(
            String geneSymbol) throws ApplicationException {
         
        List<String> params = duplicateId(geneSymbol.toLowerCase());
        return appService.query(new HQLCriteria(GENE_ASSOCIATIONS_HQL,params));
    }
    

    /**
     * Returns all reporters for a given gene symbol.  
     * @param geneSymbol Gene.symbol or Gene.hugoSymbol
     * @return List of ExpressionArrayReporter, with preloaded genes and microarrays
     * @throws ApplicationException
     */
    public List<ExpressionArrayReporter> getReportersByGene(
            String geneSymbol) throws ApplicationException {

        List<String> params = duplicateId(geneSymbol.toLowerCase());
        return appService.query(new HQLCriteria(REPORTERS_BY_GENE_HQL,params));
    }
    
    
    /**
     * Returns all reporters for a given SNP.  
     * @param dbSNPId SNP.DBSNPID
     * @return List of SNPArrayReporter, with preloaded genes and SNPs
     * @throws ApplicationException
     */
    public List<SNPArrayReporter> getReportersBySNP(
            String dbSNPId) throws ApplicationException {

        String lowerId = dbSNPId.toLowerCase();
        List<String> params = new ArrayList<String>();
        params.add(lowerId);
        return appService.query(new HQLCriteria(REPORTERS_BY_SNP_HQL,params));
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

        List<String> params = duplicateId(geneSymbol.toLowerCase());
        return appService.query(new HQLCriteria(GENES_BY_SYMBOL_HQL,params));
    }
    
    /**
     * Shortcut method to create a parameter array with the same parameter twice.
     * @param id
     * @return
     */
    private List<String> duplicateId(String id) {
        List<String> params = new ArrayList<String>();
        params.add(id);
        params.add(id);
        return params;
    }
}
