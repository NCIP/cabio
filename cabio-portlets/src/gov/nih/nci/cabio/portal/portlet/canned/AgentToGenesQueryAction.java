package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.domain.GeneAgentAssociation;
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

/**
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class AgentToGenesQueryAction extends Action {

    private static Log log = LogFactory.getLog(AgentToGenesQueryAction.class);
    
    private CaBioApplicationService as;
    private ReportService rs;
    
    public AgentToGenesQueryAction() throws Exception {
        this.as = (CaBioApplicationService)
            ApplicationServiceProvider.getApplicationService();
        this.rs = new ReportService(as);
    }
    
	@Override
    public ActionForward execute(ActionMapping mapping, ActionForm form, 
            HttpServletRequest req, HttpServletResponse res) throws Exception {

	    try {
	        AgentToGenesQueryForm f = (AgentToGenesQueryForm)form;
            String agentInput = f.getAgent();
	        String negationStatus = f.getSentenceType();
	        String unfinishedSentence = f.getUnfinishedSentence();
	        String celllineStatus = f.getCellline();
	        
            log.info("agent: "+agentInput);
            log.info("page: "+f.getPage());

            List<GeneAgentAssociation> results =  
            	   rs.getGenesByAgentWithEvidenceProperties(
            			   agentInput, negationStatus, unfinishedSentence, celllineStatus);
            
	        req.setAttribute("results", new Results(results, f.getPageNumber()));
            return mapping.findForward("cabioportlet.agentToGenesQuery.results");
	    }
	    catch (Exception e) {
            log.error("Action error",e);
            req.setAttribute("errorMessage", e.getMessage());
	        return mapping.findForward("cabioportlet.error");
	    }
	}
}
