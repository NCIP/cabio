package gov.nih.nci.system.web.struts.mobile;

import org.apache.log4j.Logger;

import gov.nih.nci.system.web.struts.action.Result;

/**
 */
public class SimpleSearch extends Result 
{
	private static Logger log = Logger.getLogger(SimpleSearch.class
			.getName());

	public String execute() throws Exception {		
		String submitValue = getBtnSearch();
		log.debug("submitValue: " + submitValue);
		
		String query=null;
		//if(submitValue != null && submitValue.equalsIgnoreCase("Submit"))
		{
			query = "GetHTML?query=gov.nih.nci.cabio.domain.Gene&gov.nih.nci.cabio.domain.Gene[@symbol=brca1]";
			log.debug("query: " + query);			   	
			setQuery(query);			
		}		
        return SUCCESS;
    }
}	

