package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.portal.portlet.canned.CannedObjectConfig;

import javax.servlet.ServletException;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.config.ModuleConfig;

/**
 * Runs when Struts is started (as configured in the struts-config.xml) and 
 * loads common data for the caBIO portlet.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AppLoadPlugin implements org.apache.struts.action.PlugIn {

    private static Log log = LogFactory.getLog(AppLoadPlugin.class);
    
    public void destroy() {
        log.info("Destroy caBIO Portlet");
    }

    public void init(ActionServlet actionServlet, ModuleConfig moduleConfig)
            throws ServletException {

        log.info("Init caBIO Portlet");
        
        // calling the getters initializes the static data 
        
//        if (StaticQueries.getTaxonValues().isEmpty()) {
//            log.error("Unable to load taxon data.");
//        }
//        if (StaticQueries.getAssemblyValues().isEmpty()) {
//            log.error("Unable to load assembly data.");
//        }
//        if (StaticQueries.getTaxonChromosomes().isEmpty()) {
//            log.error("Unable to load chromosome data.");
//        }
//        if (StaticQueries.getMicroarrays().isEmpty()) {
//            log.error("Unable to load microarray data.");
//        }
        
        try {
            actionServlet.getServletContext().setAttribute(
                "globalQueries", new GlobalQueries());
            
            actionServlet.getServletContext().setAttribute(
                "objectConfig", new CannedObjectConfig());
        }
        catch (Exception e) {
            log.fatal("Failed to load canned object configuration, cannot proceed.",e);
            throw new ServletException("Failed to load data for caBIO Portlet");
        }
    }
}
