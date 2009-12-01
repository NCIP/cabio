package gov.nih.nci.system.web;

import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.Sort;
import gov.nih.nci.system.dao.impl.search.SearchAPIDAO;
import gov.nih.nci.system.dao.impl.search.SearchAPIDAO.QueryType;
import gov.nih.nci.system.web.util.IndexSearchUtils;

import java.io.IOException;
import java.util.List;
import java.util.StringTokenizer;

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
 * @author Shaziya Muhsin
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class IndexSearchService extends HttpServlet {

    private static Logger log = Logger.getLogger(IndexSearchService.class);
    
    private SearchAPIDAO searchAPI;
    
    @Override
	public void init() throws ServletException {
        WebApplicationContext ctx =  
        	WebApplicationContextUtils.getWebApplicationContext(getServletContext());
        this.searchAPI = (SearchAPIDAO)ctx.getBean("SearchAPIDAO");
	}

    /**
     * Handles Post requests
     */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	
        RequestDispatcher dispatcher = request.getRequestDispatcher("searchResults.jsp");
        HttpSession session = request.getSession();
        
        try {
            // normalize search URL so we can check if the query is already in the session
            String searchURL = IndexSearchUtils.createSearchURL(request);
            
            // display parameters
            String startIndex = request.getParameter("startIndex")!= null?request.getParameter("startIndex"):"";
            String targetClass = request.getParameter("targetClass")!= null?request.getParameter("targetClass"):"";

            // search parameters
            String searchString = request.getParameter("searchString")!= null?request.getParameter("searchString"):"";
            String pageSize = request.getParameter("pageSize")!= null?request.getParameter("pageSize"):"";
            String queryType = "objects".equals(request.getParameter("viewType")) ? QueryType.HIBERNATE_SEARCH.toString() : QueryType.FULL_TEXT_SEARCH.toString();
            boolean fuzzySearch = "1".equals(request.getParameter("fuzzy"));
            String words = request.getParameter("words")!= null?request.getParameter("words"):"any";
            String exclude = request.getParameter("excludeText")!= null?request.getParameter("excludeText"):"";
            String excludeReplacement = null;
            if (exclude != null) {   
                excludeReplacement = exclude.trim().replaceAll("[ \t,]+", " -");
            } 
            
            // No search
            if ("".equals(searchString)) {
                request.getRequestDispatcher("indexSearch.jsp").forward(request,response);
                return;
            }
            
            // Handle bigids by redirecting to a GridIdQuery
            if (searchString.startsWith("hdl://")){
                String url = request.getContextPath()+"/GetHTML?query=gov.nih.nci.search.GridIdQuery&gov.nih.nci.search.GridIdQuery[@bigId="+
                  searchString+"]&pageSize="+pageSize;
                response.sendRedirect(url);
                return;
            }
            
            // Create query string
            String query = "";
            if (!words.equals("")){
                for (StringTokenizer st = new StringTokenizer(searchString," ");st.hasMoreTokens();) {
                    String token = st.nextToken();
                    if (words.equals("all") && exclude.equals("")) {
                        query+= "+" + token +" ";
                    }
                    else if(words.equals("all") && exclude.length()>0){
                        if (token.equalsIgnoreCase(exclude)) {
                            query += "-"+token +" "; 
                        }
                        else {
                            query += "+"+token +" ";
                        }
                    }
                    else if(words.equals("any") && exclude.length()>0){
                        if (token.equalsIgnoreCase(exclude)) {
                            query += "-"+token +" "; 
                        }
                        else{
                            query += token +" ";
                        }
                    }
                }
            }
          
            if (query.equals("")){
                query = searchString;
                if (!exclude.equals("")) {
                    if (query.toLowerCase().indexOf(exclude.toLowerCase())<0){
                        query = "-"+ searchString;
                    }
                    else {
                        query += " -"+ excludeReplacement;
                    }               
                }
            }
            else{
                if(!exclude.equals("")){
                    if(query.toLowerCase().indexOf(exclude.toLowerCase())<0){
                        query += "-"+ excludeReplacement;
                    }
                }        
            }
            
            log.info("Compiled query: "+query);
            
            // Redirect to SDK-based view for "object" search
            if (queryType.equals(QueryType.HIBERNATE_SEARCH.toString())){
                String postfix = fuzzySearch? "%7E" : "";
                String url = request.getContextPath()+"/GetHTML?query=gov.nih.nci.search.SearchQuery&gov.nih.nci.search.SearchQuery[@keyword="+
                    query+postfix+"][@queryType="+queryType+"]&pageSize="+pageSize;
                response.sendRedirect(url);
                return;
            }  
            
            // Check if session is valid
            if(session.getAttribute("indexSearchUtils") != null) {
                // Already have results in the session, are they relevant?
                IndexSearchUtils searchUtils = (IndexSearchUtils)session.getAttribute("indexSearchUtils");
                
                if (searchUtils.getSearchURL().equals(searchURL)) {
                    // Yes, but Display parameters may have changed, so reorganize the results.
                    searchUtils.setStartIndex("".equals(startIndex) ? 0 : Integer.parseInt(startIndex));
                    searchUtils.setTargetClass(targetClass);
                    searchUtils.organizeResults();
                    dispatcher.forward(request,response);
                    return;
                }
            }
            
            IndexSearchUtils searchUtils = new IndexSearchUtils();
            searchUtils.setSearchURL(searchURL);
            searchUtils.setTargetClass(targetClass);
            
            SearchQuery searchQuery = new SearchQuery();
            searchQuery.setKeyword(query);
            searchQuery.setQueryType(queryType);
            
            if (fuzzySearch) searchQuery.setFuzzySearch(true);

            if (pageSize.length()>0){                
               searchUtils.setPageSize(Integer.parseInt(pageSize));
            }
            
            Sort sorter = new Sort();
            sorter.setSortByClassName(new Boolean(true));
            searchQuery.setSort(sorter);
            
            List results = searchAPI.query(searchQuery);
            
            searchUtils.setSearchQuery(searchQuery);
            searchUtils.setResultSet(results);
            if(!startIndex.equals("")) 
                searchUtils.setStartIndex(Integer.parseInt(startIndex));
            searchUtils.organizeResults();
            
            session.setAttribute("indexSearchUtils", searchUtils);
            
        }
        catch (Exception ex) {   
            log.error("Error",ex);
            request.setAttribute("javax.servlet.jsp.jspException", ex);
            dispatcher = request.getRequestDispatcher("/searchError.jsp"); 
            
        }
        dispatcher.forward(request,response);
    }

    /**
     * Handles Post requests by calling doGet. POST is only called from the 
     * full FreestyleLM form. The request is normalized into a GET here and
     * forwarded onwards.
     */
    @Override
    public void doPost(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {

        try {
            String viewType = request.getParameter("viewType")==null?"":request.getParameter("viewType");
            String searchURL = IndexSearchUtils.createSearchURL(request);
            String url = request.getContextPath()+"/"+searchURL;
            if (!"".equals(viewType)) url += "&viewType="+viewType;
            response.sendRedirect(url);
        }
        catch (Exception ex) {   
            log.error("Error",ex);
            request.setAttribute("javax.servlet.jsp.jspException", ex);
            request.getRequestDispatcher("/searchError.jsp").forward(request,response);
        }
    }

}
