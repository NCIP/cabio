package gov.nih.nci.cabio.portal.portlet.canned;


import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.cabio.portal.portlet.ReportService;
import gov.nih.nci.cabio.portal.portlet.Results;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;


public class PathwayByNameQueryAction extends Action {

    private static Log log = LogFactory.getLog(PathwayByNameQueryAction.class);
    
    private CaBioApplicationService as;
    private ReportService rs;
    
    public PathwayByNameQueryAction() throws Exception {
    	   this.as = (CaBioApplicationService)
           ApplicationServiceProvider.getApplicationService();
       this.rs = new ReportService(as);
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        PathwayByNameQueryForm f = (PathwayByNameQueryForm)form;
            String pathwayName = f.getPathwayName();
	        
            log.info("pathwayName: "+pathwayName);
            log.info("page: "+f.getPage());
            
            List<Pathway> results = rs.getPathwaysByName(pathwayName);
            
	        req.setAttribute("results", new Results(results, f.getPageNumber()));
            return mapping.findForward("cabioportlet.pathwayByNameQuery.results");
	    }
	    catch (Exception e) {
	        log.error("Action error",e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
 }
}
