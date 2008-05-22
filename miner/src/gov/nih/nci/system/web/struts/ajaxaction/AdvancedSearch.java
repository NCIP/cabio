package gov.nih.nci.system.web.struts.ajaxaction;

import com.opensymphony.xwork2.Action;

import java.io.Serializable;
import org.apache.log4j.Logger;

/**
 */
public class AdvancedSearch implements Action, Serializable {
	private static Logger log = Logger.getLogger(AdvancedSearch.class
			.getName());

	public String execute() throws Exception {
		log.debug("AdvancedSearch.action called so that localized messages are available on AJAX Home.jsp");		
        return SUCCESS;
    }
}	