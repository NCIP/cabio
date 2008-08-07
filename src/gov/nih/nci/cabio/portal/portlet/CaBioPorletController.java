package gov.nih.nci.cabio.portal.portlet;

import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.springframework.web.portlet.ModelAndView;
import org.springframework.web.portlet.mvc.AbstractController;

/**
 * Simple controller which just displays a JSP.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CaBioPorletController extends AbstractController {

    private String viewName;

    public ModelAndView handleRenderRequestInternal(
            RenderRequest request, RenderResponse response) throws Exception {
        ModelAndView mav = new ModelAndView(getViewName());
        return mav;
    }

    public String getViewName() {
        return viewName;
    }

    public void setViewName(String viewName) {
        this.viewName = viewName;
    }
}
