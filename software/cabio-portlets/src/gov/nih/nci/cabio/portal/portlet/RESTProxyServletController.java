/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet;

import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.HttpMethod;
import org.apache.commons.httpclient.URI;
import org.apache.commons.httpclient.methods.GetMethod;
import org.apache.commons.io.CopyUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

/**
 * Simple local proxy for caBIO API. Allows for caBIO Ajax functionality in 
 * pages served by the portal.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class RESTProxyServletController extends AbstractController {

    private static Log log = LogFactory.getLog(RESTProxyServletController.class);
    
    private String caBIORestURL;
    
    /* (non-Javadoc)
     * @see org.springframework.web.servlet.mvc.AbstractController#handleRequestInternal(javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse)
     */
    @Override
    protected ModelAndView handleRequestInternal(HttpServletRequest request,
            HttpServletResponse response) throws Exception {
        
        try {
            String relativeURL = request.getParameter("relativeURL");
            if (relativeURL == null) {
                log.error("Null relativeURL parameter");
                return null;
            }
            
            String qs = request.getQueryString();
            if (qs == null) {
                qs = "";
            }
            
            qs = qs.replaceFirst("relativeURL=(.*?)&","");
            qs = URLDecoder.decode(qs, "UTF-8");
            
            String url = caBIORestURL+relativeURL+"?"+qs;
            log.info("Proxying URL: "+url);
            
            URI uri = new URI(url, false);
            HttpClient client = new HttpClient();
            HttpMethod method = new GetMethod();
            method.setURI(uri);
            client.executeMethod(method);
            
            response.setContentType(method.getResponseHeader("Content-Type").getValue());
            
            CopyUtils.copy(
                method.getResponseBodyAsStream(), 
                response.getOutputStream());
        }
        catch (Exception e) {
            throw new ServletException("Unable to connect to caBIO", e);
        }
        
        
        return null;
    }

    public void setCaBIORestURL(String caBIORestURL) {
        this.caBIORestURL = caBIORestURL;
    }
}