/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.system.web;

import gov.nih.nci.cabio.domain.Pathway;
import gov.nih.nci.system.dao.orm.ORMDAOImpl;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.util.List;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.Expression;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * A servlet which prints pathway diagrams in SVG format.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class PathwaySVGService extends HttpServlet {

    private static Logger log = Logger.getLogger(PathwaySVGService.class);
    
    private static final String versionPropertiesFilename = "messages.properties";
    
    private static final String versionPropertyName = "build.version.webapp";
    
    private SessionFactory sessionFactory;

    private String apiVersion;
    
    @Override
    public void init() throws ServletException {
        WebApplicationContext ctx =  
            WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        this.sessionFactory = ((ORMDAOImpl)ctx.getBean("ORMDAO")).getHibernateTemplate().getSessionFactory();
        
        Properties properties = new Properties();
        InputStream is = null;
        try {
            is = Thread.currentThread().getContextClassLoader().getResourceAsStream(
                versionPropertiesFilename);
            properties.load(is);
            this.apiVersion = properties.getProperty(versionPropertyName); 
        }
        catch (IOException e) {
            throw new ServletException(e);
        }
        finally {
            try {
                if (is != null) is.close();
            }
            catch (Exception e) {
                log.error("Error closing properties file",e);
            }
        }
    }

    /**
     * Handles Get requests.
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String pathwayName = request.getParameter("name");

        if (pathwayName == null || "".equals(pathwayName)) {
            throw new ServletException("No pathway name specified. " +
            		"Pass a 'name' GET parameter to specify the pathway.");
        }

        Session session = null;
        Pathway pathway = null;
        
        try {
            session = sessionFactory.openSession();
            Criteria c = session.createCriteria(Pathway.class);
            c = c.add(Expression.ilike("name", pathwayName));
            List<Pathway> results = c.list();
            
            if (results.isEmpty()) throw new ServletException("No such pathway");
            
            if (results.size() > 0) {
                log.warn("More than 1 pathway found with name: "+pathwayName);
                for (Pathway p : results) {
                    System.out.println(""+p.getId()+" "+p.getName());
                }
            }
            
            pathway = results.get(0);
        }
        finally {
            session.close();
        }
        
        // species prefix used to link to other related pathway diagrams
        String prefix = pathwayName.substring(0, 2);
        if (!prefix.endsWith("_")) prefix = "";
        
        String svgString = pathway.getDiagram();
        if (svgString == null) return;
                
        StringBuffer requestURL = request.getRequestURL();
        String server = requestURL.substring(0, requestURL.indexOf("/cabio" + apiVersion));
        
        svgString = svgString.replaceAll(
            "/CMAP.*?BCID=(.*?)\"", 
            server+"/cabio"+apiVersion+"/GetHTML?query=Gene&amp;Gene[@symbol=$1]\"");
        
        svgString = svgString.replaceAll(
            "/Pathways/GetSelectedPathway\\?page=ShowPathway.*?pathway=(\\w+?)\"", 
            server+"/cabio"+apiVersion+"/GetPathway?name="+prefix+"$1\"");

        PrintWriter pw = new PrintWriter(response.getOutputStream());
        response.setContentType("image/svg+xml");
        pw.println(svgString);
        pw.close();
    }

    /**
     * Handles Post requests by calling doGet.
     */
    public void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
    
    /**
     * Unload servlet.
     */
    public void destroy() {
        super.destroy();
    }
    
    /**
     * Test harness
     * @param args
     */
    public static void main(String[] args) {
        
        String svgString = "href=\"/Pathways/GetSelectedPathway?page=ShowPathway.jsp&amp;context=all;all;all&amp;pathway=mapkPathway\">";
        svgString = svgString.replaceAll(
            "/Pathways/GetSelectedPathway\\?page=ShowPathway.*?pathway=(\\w+?)\"", 
            "/cabio43/GetPathway?name=$1\"");
        System.out.println(svgString);
    }
}
