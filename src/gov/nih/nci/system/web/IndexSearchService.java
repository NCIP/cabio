package gov.nih.nci.system.web;

import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.system.dao.impl.search.SearchAPIDAO;
import gov.nih.nci.system.web.util.IndexSearchUtils;

import java.io.IOException;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.log4j.Logger;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;

/**
 * Servlet for searching FreestyleLM (full text search) from the web interface. 
 * 
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class IndexSearchService extends HttpServlet {

    private static Logger log = Logger.getLogger(IndexSearchService.class);
    private SearchAPIDAO searchAPI;

    public IndexSearchService() {
    }
    
    @Override
	public void init() throws ServletException {
        WebApplicationContext ctx =  
        	WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        this.searchAPI = (SearchAPIDAO)ctx.getBean("SearchAPIDAO");
	}

    /**
     * Handles Post requests
     */
    public void doPost(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	
        RequestDispatcher dispatcher = request.getRequestDispatcher("searchResults.jsp");
        HttpSession session = request.getSession();
        
        try {
            IndexSearchUtils searchUtils = 
            	(IndexSearchUtils)session.getAttribute("indexSearchUtils");
            
            if(searchUtils != null) {
                if(!session.isNew() && !searchUtils.isNewQuery() 
                		&& searchUtils.getResultCounter()>0){
                    searchUtils.organizeResults();
                }
                else {
                    try {
                        SearchQuery searchQuery = searchUtils.getSearchQuery();
//                        log.info("Searching for: "+ searchQuery.getKeyword());
                        List results = query(searchQuery);
//                        log.info("Number of records found: "+ results.size());
                        searchUtils.setResultSet(results);
                        searchUtils.setResultCounter(results.size());
                        searchUtils.setNewQuery(false);
                        searchUtils.organizeResults();
                    }
                    catch(Exception ex) {
                        log.error(ex);
                        throw new ServletException(ex);
                    }
                }
                session.setAttribute("indexSearchUtils",searchUtils);
            }
            else {                
                dispatcher = request.getRequestDispatcher("indexSearch.jsp");
            }
     
        }
        catch (Exception ex) {   
            log.error("Error",ex);
            request.setAttribute("javax.servlet.jsp.jspException", ex);
            dispatcher = request.getRequestDispatcher("/searchError.jsp"); 
            
        }
        dispatcher.forward(request,response);
    }
    
    private List query(SearchQuery searchQuery) throws Exception {
        return searchAPI.query(searchQuery);
    }
    
    /**
     * Unload servlet
     */
    public void destroy() {
        super.destroy();
    }

    /**
     * Handles Get requests by calling doPost.
     */
    public void doGet(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException{
        doPost(request, response);
    }

}
