/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.Microarray;
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

/**
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ReporterByNameQueryAction extends Action {

    private static Log log = LogFactory.getLog(ReporterByNameQueryAction.class);
    
    private CaBioApplicationService as;
    private ArrayAnnotationService aas;
    
    public ReporterByNameQueryAction() throws Exception {
        this.as = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();
        this.aas = new ArrayAnnotationServiceImpl(as);
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        ReporterByNameQueryForm f = (ReporterByNameQueryForm)form;
	        
            log.info("microarray: "+f.getMicroarray());
            log.info("reporter: "+f.getReporterId());
            log.info("page: "+f.getPage());
            
            List<String> reporterIds = new ArrayList<String>();
            reporterIds.add(f.getReporterId().trim());
            
            String arrayPlatform = f.getMicroarray();
            Microarray microarray = aas.getMicroarray(arrayPlatform);
            
            // TODO: move this code into ArrayAnnotationServiceImpl
            Collection<? extends ArrayReporter> results = null;
            if ("oligo".equals(microarray.getType())) {
                results = aas.getExpressionReporterAnnotations(arrayPlatform, reporterIds);
            }
            else if ("snp".equals(microarray.getType())) {
                results = aas.getSNPReporterAnnotations(arrayPlatform, reporterIds);
            }
            else if ("exon".equals(microarray.getType())) {
                results = aas.getExonReporterAnnotations(arrayPlatform, reporterIds);
            }
            else {
                throw new Exception("Unsupported array type: "+microarray.getType());
            }
            
	        req.setAttribute("results", new Results(results, f.getPageNumber()));

            return mapping.findForward("cabioportlet.reporterByNameQuery.results");
	    }
	    catch (Exception e) {
            log.error("Action error",e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
	}
}
