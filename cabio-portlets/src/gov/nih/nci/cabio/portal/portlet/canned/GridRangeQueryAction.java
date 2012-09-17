package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.portal.portlet.Results;
import gov.nih.nci.search.GridIdRangeQuery;
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

/**
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GridRangeQueryAction extends Action {

    private static Log log = LogFactory.getLog(GridRangeQueryAction.class);
    
    private CaBioApplicationService as;
    
    public GridRangeQueryAction() throws Exception {
        this.as = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        GridRangeQueryForm f = (GridRangeQueryForm)form;
	        
	        GridIdRangeQuery q = new GridIdRangeQuery();
	        q.setBigId(f.getGridId());
            q.setAssembly(f.getAssembly());
	        q.setDownstreamDistance(new Long(f.getDownstreamPad()));
	        q.setUpstreamDistance(new Long(f.getUpstreamPad()));

	        Class targetClass = RangeQuery.class;
	        if (!"".equals(f.getClassFilter())) {
	            targetClass = Class.forName(f.getClassFilter());
	        }

            log.info("gridId: "+q.getBigId());
            log.info("assembly: "+q.getAssembly());
            log.info("upstream: "+q.getUpstreamDistance());
            log.info("downstream: "+q.getDownstreamDistance());
            log.info("page: "+f.getPage());
            log.info("targetClass: "+targetClass.getName());
            
            List results = as.search(targetClass, q);
            log.info("result size: "+results.size());
            
	        req.setAttribute("results", new Results(results, f.getPageNumber()));

            return mapping.findForward("cabioportlet.gridRangeQuery.results");
	    }
	    catch (Exception e) {
            log.error("Action error",e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
	}
}
