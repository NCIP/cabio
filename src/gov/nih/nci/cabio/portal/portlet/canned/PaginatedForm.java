package gov.nih.nci.cabio.portal.portlet.canned;

import org.apache.struts.action.ActionForm;

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
