package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.portal.portlet.Results;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class GeneBySymbolQueryAction extends Action {

    private static Log log = LogFactory.getLog(GeneBySymbolQueryAction.class);
    
    private CaBioApplicationService as;
    private ArrayAnnotationService aas;
    
    public GeneBySymbolQueryAction() throws Exception {
        this.as = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();
        this.aas = new ArrayAnnotationServiceImpl(as);
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        GeneBySymbolQueryForm f = (GeneBySymbolQueryForm)form;
	        
//            String[] geneSymbols = f.getGeneSymbol().split("\\s*,\\s*");
//            Collection<Gene> results = aas.getGeneAnnotations(geneList);

	        String symbol = f.getGeneSymbol().toLowerCase();
	        
            log.info("gene: "+symbol);
            log.info("page: "+f.getPage());

            String HQL = 
                     "select gene from gov.nih.nci.cabio.domain.Gene gene " +
                     "left join fetch gene.databaseCrossReferenceCollection as dbxr " +
                     "left join fetch gene.chromosome " +
                     "left join fetch gene.geneAliasCollection " +
                     "left join fetch gene.taxon as taxon " +
                     "where dbxr.dataSourceName = 'LOCUS_LINK_ID' " +
                     "and (lower(gene.hugoSymbol) like ? or lower(gene.symbol) like ?)";
             

            List<String> params = new ArrayList<String>();
            params.add(symbol);
            params.add(symbol);
            
            List<Gene> results =  as.query(new HQLCriteria(HQL,params));

	        req.setAttribute("results", new Results(results, f.getPageNumber()));

            return mapping.findForward("cabioportlet.geneBySymbolQuery.results");
	    }
	    catch (Exception e) {
	        log.error(e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
	}
}
