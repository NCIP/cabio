package gov.nih.nci.cabio.portal.portlet;

import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.URI;
import org.apache.commons.httpclient.methods.GetMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

/**
 * Simple local proxy for caBIO REST API. Allows for caBIO Ajax functionality in 
 * pages served by the portal.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class RESTProxyServletController extends AbstractController {
	
    private String caBIORestURL;
    
    /* (non-Javadoc)
     * @see org.springframework.web.servlet.mvc.AbstractController#handleRequestInternal(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
        byte[] xmlBytes = null;
        try {
            String url = caBIORestURL+"?"+URLDecoder.decode(request.getQueryString(), "UTF-8");
            URI uri = new URI(url, false);
            HttpClient client = new HttpClient();
            HttpMethod method = new GetMethod();
            method.setURI(uri);
            client.executeMethod(method);
            xmlBytes = method.getResponseBody();
        }
        catch (Exception e) {
            throw new ServletException("Unable to connect to caBIO", e);
        }
        
        response.setContentType("text/xml");
        response.getOutputStream().write(xmlBytes);
        
        return null;
    }

    public void setCaBIORestURL(String caBIORestURL) {
        this.caBIORestURL = caBIORestURL;
    }
}