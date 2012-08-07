package gov.nih.nci.cabio.portal.portlet.canned;

import org.apache.struts.action.ActionForm;

/**
 * A form which keeps track of the current page in the result set.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class PaginatedForm extends ActionForm {

    private String page = "0";
    
    public Integer getPageNumber() {
        return Integer.parseInt(page);
    }

    public String getPage() {
        return page;
    }

    public void setPage(String page) {
        this.page = page;
    }
}
