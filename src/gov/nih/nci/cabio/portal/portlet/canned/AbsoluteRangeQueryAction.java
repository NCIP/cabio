package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.portal.portlet.Results;
import gov.nih.nci.search.AbsoluteRangeQuery;
import gov.nih.nci.search.RangeQuery;
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

public class AbsoluteRangeQueryAction extends Action {

    private static Log log = LogFactory.getLog(AbsoluteRangeQueryAction.class);
    
    private CaBioApplicationService as; 
    
    public AbsoluteRangeQueryAction() throws Exception {
        this.as = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        AbsoluteRangeQueryForm f = (AbsoluteRangeQueryForm)form;
	        
	        AbsoluteRangeQuery q = new AbsoluteRangeQuery();
	        q.setChromosomeId(f.getChromosomeId());
	        q.setAssembly(f.getAssembly());
	        q.setStart(new Long(f.getStart()));
	        q.setEnd(new Long(f.getEnd()));

	        Class targetClass = RangeQuery.class;
	        if (!"".equals(f.getClassFilter())) {
	            targetClass = Class.forName(f.getClassFilter());
	        }

            log.info("assembly: "+q.getAssembly());
            log.info("chromosomeId: "+q.getChromosomeId());
            log.info("start: "+q.getStart());
            log.info("end: "+q.getEnd());
            log.info("page: "+f.getPage());
            log.info("targetClass: "+targetClass.getName());
            
            List results = as.search(targetClass, q);
            log.info("result size: "+results.size());
            
	        req.setAttribute("results", new Results(results, f.getPageNumber()));

            return mapping.findForward("cabioportlet.absoluteRangeQuery.results");
	    }
	    catch (Exception e) {
	        log.error(e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
	}
}
