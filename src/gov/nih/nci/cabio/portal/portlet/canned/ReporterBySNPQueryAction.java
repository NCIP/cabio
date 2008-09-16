package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.cabio.domain.SNPArrayReporter;
import gov.nih.nci.cabio.portal.portlet.Results;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

public class ReporterBySNPQueryAction extends Action {

    private static Log log = LogFactory.getLog(ReporterBySNPQueryAction.class);
    
    private CaBioApplicationService as;
    private ArrayAnnotationService aas;
    private CannedObjectConfig objectConfig;
    
    public ReporterBySNPQueryAction() throws Exception {
        this.as = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();
        this.aas = new ArrayAnnotationServiceImpl(as);
        this.objectConfig = new CannedObjectConfig();
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        ReporterBySNPQueryForm f = (ReporterBySNPQueryForm)form;
	        
            log.info("snp: "+f.getDbsnpId());
            log.info("page: "+f.getPage());
                        
            SNP snp = new SNP();
            snp.setDBSNPID(f.getDbsnpId());
            List<SNPArrayReporter> results = as.search(SNPArrayReporter.class, snp);

	        req.setAttribute("results", new Results(results, f.getPageNumber()));
	        // TODO: remove this after development
	        this.objectConfig = new CannedObjectConfig();
            req.setAttribute("objectConfig", objectConfig);

            return mapping.findForward("cabioportlet.reporterBySNPQuery.results");
	    }
	    catch (Exception e) {
	        log.error(e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
	}
}
