package gov.nih.nci.system.web;

import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.Sort;
import gov.nih.nci.system.dao.impl.search.SearchAPIDAO;
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
    public void doPost(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException {
    	
        RequestDispatcher dispatcher = request.getRequestDispatcher("searchResults.jsp");
        HttpSession session = request.getSession();
        
        try {
            // parameters
            String searchString = request.getParameter("searchString")!= null?request.getParameter("searchString"):"";
            String startIndex = request.getParameter("startIndex")!= null?request.getParameter("startIndex"):"";
            String targetClass = request.getParameter("targetClass")!= null?request.getParameter("targetClass"):"";
            String pageSize = request.getParameter("PAGE_SIZE")!= null?request.getParameter("PAGE_SIZE"):"";
            String queryType = request.getParameter("FULL_TEXT_SEARCH")!= null?request.getParameter("FULL_TEXT_SEARCH"):"";
            boolean fuzzySearch = request.getParameter("FUZZY_SEARCH")!= null;
            String words = request.getParameter("WORDS")!= null?request.getParameter("WORDS"):"";
            String exclude = request.getParameter("EXCLUDE_TEXT")!= null?request.getParameter("EXCLUDE_TEXT"):"";
            String excludeReplacement = null;
            if (exclude != null) {   
                excludeReplacement = exclude.trim().replaceAll("[ \t,]+", " -");
            } 
            
            // Handle bigids by redirecting to a GridIdQuery
            if (searchString.startsWith("hdl://")){
                String url = request.getContextPath()+"/GetHTML?query=gov.nih.nci.search.GridIdQuery&gov.nih.nci.search.GridIdQuery[@bigId="+
                  searchString+"]&pageSize="+pageSize;
                response.sendRedirect(url);
                return;
            }
            
            // Establish a new search utils, or get one from the session
            IndexSearchUtils searchUtils = null;
            
            if (searchString.equals("")){
                // check if session is valid
                if(session.getAttribute("indexSearchUtils")!=null){
                    // Already have results in the session, 
                    // but reorganize them because the user may have paged
                    searchUtils = (IndexSearchUtils)session.getAttribute("indexSearchUtils");
                    searchUtils.setStartIndex("".equals(startIndex) ? 0 : Integer.parseInt(startIndex));
                    searchUtils.setTargetClass(targetClass);
                    searchUtils.organizeResults();
                }
                else{
                    dispatcher = request.getRequestDispatcher("indexSearch.jsp"); 
                    dispatcher.forward(request,response);
                    return;
                }
            }
            else {
                searchUtils = new IndexSearchUtils();
                SearchQuery searchQuery = new SearchQuery();
                
                searchQuery.setQueryType(queryType);
                
                if (fuzzySearch)searchQuery.setFuzzySearch(true);

                if (pageSize.length()>0){                
                   searchUtils.setPageSize(Integer.parseInt(pageSize));
                }
                
                Sort sorter = new Sort();
                sorter.setSortByClassName(new Boolean(true));
                searchQuery.setSort(sorter);
                
                String query = "";
                if (!words.equals("")){
                    for (StringTokenizer st = new StringTokenizer(searchString," ");st.hasMoreTokens();) {
                        String token = st.nextToken();
                        if (words.equals("WITH_ALL") && exclude.equals("")) {
                            query+= "+" + token +" ";
                        }
                        else if(words.equals("WITH_ALL") && exclude.length()>0){
                            if (token.equalsIgnoreCase(exclude)) {
                                query += "-"+token +" "; 
                            }
                            else {
                                query += "+"+token +" ";
                            }
                        }
                        else if(words.equals("WITH_ANY") && exclude.length()>0){
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
                    searchQuery.setKeyword(query);
                }
                else{
                    if(!exclude.equals("")){
                        if(query.toLowerCase().indexOf(exclude.toLowerCase())<0){
                            query += "-"+ excludeReplacement;
                        }
                    }
                    searchQuery.setKeyword(query);          
                }
                
                List results = searchAPI.query(searchQuery);
                
                searchUtils.setSearchQuery(searchQuery);
                searchUtils.setResultSet(results);
                if(!startIndex.equals("")) 
                    searchUtils.setStartIndex(Integer.parseInt(startIndex));
                searchUtils.organizeResults();
                
                session.setAttribute("indexSearchUtils", searchUtils);
            }
     
        }
        catch (Exception ex) {   
            log.error("Error",ex);
            request.setAttribute("javax.servlet.jsp.jspException", ex);
            dispatcher = request.getRequestDispatcher("/searchError.jsp"); 
            
        }
        dispatcher.forward(request,response);
    }

    /**
     * Handles Get requests by calling doPost.
     */
    @Override
    public void doGet(HttpServletRequest request, HttpServletResponse response) 
    		throws ServletException, IOException{
        doPost(request, response);
    }

}
