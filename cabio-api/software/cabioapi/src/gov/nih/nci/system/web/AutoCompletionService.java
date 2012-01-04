package gov.nih.nci.system.web;

import gov.nih.nci.common.domain.Keyword;
import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.dao.orm.ORMDAOImpl;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.criterion.LikeExpression;
import org.hibernate.criterion.Order;
import org.hibernate.criterion.Restrictions;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * A simple service that may be queried with an input string and returns 
 * completion suggestions for that string in the form of a newline-delimited
 * list of strings. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AutoCompletionService extends HttpServlet {

    private static Logger log = Logger.getLogger(AutoCompletionService.class);
        
    private SessionFactory sessionFactory;

    @Override
    public void init() throws ServletException {
        WebApplicationContext ctx =  
            WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        this.sessionFactory = ((ORMDAOImpl)ctx.getBean("ORMDAO")).getHibernateTemplate().getSessionFactory();
    }

    /**
     * Returns a list of Keywords in which any word begins with the given input 
     * string.
     * @param s Prefix for auto-completion suggestion
     * @return List of Keyword objects matching the input string
     * @throws ApplicationException
     */
    public List<Keyword> getKeywords(String s) throws ApplicationException {

        List<Keyword> results = null;
        Session session = null;
        
        String lwrs = s.toLowerCase();
        
        try {
            session = sessionFactory.openSession();
            Criteria c = session.createCriteria(Keyword.class);
            c = c.add(Restrictions.or(
                new EscapingLikeExpression("value",escape(lwrs)+"%"),
                new EscapingLikeExpression("value","% "+escape(lwrs)+"%")));
            c = c.addOrder(Order.desc("score"));
            
            c.setMaxResults(10);
            results = c.list();
        }
        finally {
            session.close();
        }
        
        return results;
    }
    

    /**
     * Handles Get requests.
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        String q = request.getParameter("q");

        PrintWriter pw = new PrintWriter(response.getOutputStream());
        
        if (q == null || "".equals(q)) {
            log.error("AutoCompletion invoked with empty query");
            return;
        }
        
        response.setContentType("text/plain");
        
        try {
            for(Keyword k : getKeywords(q)) {
                pw.println(k.getValue());
            }
        }
        catch (ApplicationException e) {
            log.error("AutoCompletion error",e);
        }
        
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
     * Escape the special characters ('%','_','\') in the given string. Assume 
     * that '\' is the escape char.
     * @param s input string
     * @return escaped string
     */
    private String escape(String s) {
        return s.replace("\\", "\\\\").replace("_", "\\_").replace("%", "\\%");
    }
    
    /**
     * A "LIKE" restriction which escapes special characters to allow
     * searching for underscores and percentage signs.
     */
    private class EscapingLikeExpression extends LikeExpression {
        EscapingLikeExpression(String propertyName, String value) {
            super(propertyName, value, '\\', false);
        }
    }
}
