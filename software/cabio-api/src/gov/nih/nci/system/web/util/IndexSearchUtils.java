/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.system.web.util;

import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.SearchResult;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;

/**
 * This object is stored in the user session and contains the user's most
 * recent FreestyleLM search.
 * 
 * @author Shaziya Muhsin
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class IndexSearchUtils {

    private static Logger log = Logger.getLogger(IndexSearchUtils.class);
    
    private SearchQuery searchQuery = new SearchQuery();
    private List<SearchResult> resultSet = new ArrayList<SearchResult>();
    private List<SearchResult> filteredResults = new ArrayList<SearchResult>();
    private List<SearchResult> displayResults = new ArrayList<SearchResult>();
    private Map<String,Integer> counts = new HashMap<String,Integer>();
    private List<String> classes = new ArrayList<String>();
    private Set<String> openedTabs = new HashSet<String>();
    private int startIndex = 0;
    private int pageSize = 100;
    private String targetClass = "";
    private String searchURL;

    /**
     * Returns a normalized representation of the query parameters.
     * @param request
     * @return
     */
    public static String createSearchURL(HttpServletRequest request) {

        try {
            StringBuffer searchURL = new StringBuffer("IndexService?searchString=");

            String searchString = request.getParameter("searchString");
            if (searchString!=null) {
                searchURL.append(URLEncoder.encode(searchString, "UTF-8"));
            }
            
            String fuzzy = request.getParameter("fuzzy");
            if (fuzzy!=null && !"".equals(fuzzy)) {
                searchURL.append("&fuzzy=");
                searchURL.append(URLEncoder.encode(fuzzy, "UTF-8"));
            }

            String words = request.getParameter("words");
            if (words!=null && !"".equals(words) && !"any".equals(words)) {
                searchURL.append("&words=");
                searchURL.append(URLEncoder.encode(words, "UTF-8"));
            }

            String excludeText = request.getParameter("excludeText");
            if (excludeText!=null && !"".equals(excludeText)) {
                searchURL.append("&excludeText=");
                searchURL.append(URLEncoder.encode(excludeText, "UTF-8"));
            }

            String pageSize = request.getParameter("pageSize");
            if (pageSize!=null && !"".equals(pageSize)) {
                searchURL.append("&pageSize=");
                searchURL.append(URLEncoder.encode(pageSize, "UTF-8"));
            }
            
            return searchURL.toString();
        }
        catch (UnsupportedEncodingException e) {
            log.error("Attempting to use an unsupported encoding",e);
        }
        
        return "";
    }

    /**
     * Set the resultSet and calculate summary data.
     * @param resultSet
     */
    public void setResultSet(List<SearchResult> resultSet) {
        this.resultSet = resultSet;
        
        for(SearchResult searchResult : resultSet) {
            String className = searchResult.getClassName();
            int count = 0;
            if (counts.containsKey(className)) {
                count = counts.get(className);
            }
            count++;
            counts.put(className,count);
        }
        
        classes.clear();
        classes.addAll(counts.keySet());
        
        Collections.sort(classes, new Comparator<String>() {
            public int compare(String c1, String c2) {
                // Classes with the most results come first
                int c = counts.get(c2).compareTo(counts.get(c1));
                if (c == 0) {
                    // Alphabetical ordering
                    String d1 = c1.substring(c1.lastIndexOf("."));
                    String d2 = c2.substring(c2.lastIndexOf("."));
                    return d1.compareTo(d2);
                }
                else return c;
            }
        });
    }

    public List<SearchResult> getResultSet() {
        return resultSet;
    }

    public void setSearchQuery(SearchQuery searchQuery) {
        this.searchQuery = searchQuery;
    }

    public SearchQuery getSearchQuery() {
        return searchQuery;
    }
    
    public void setDisplayResults(List<SearchResult> results) {
        this.displayResults = results;
    }

    public List<SearchResult> getDisplayResults() {
        return displayResults;
    }
    
    public Map<String, Integer> getCounts() {
        return counts;
    }

    public List<String> getClasses() {
        return classes;
    }

    public int getResultCount() {
        return filteredResults.size();
    }

    public int getTotalResultCount() {
        return resultSet.size();
    }
    
    public void setStartIndex(int startIndex) {
        this.startIndex = startIndex;
    }

    public int getStartIndex() {
        return startIndex;
    }

    public void setPageSize(int pageSize) {
        this.pageSize = pageSize;
    }

    public int getPageSize() {
        return pageSize;
    }

    public String getTargetClass() {
        return targetClass;
    }

    public void setTargetClass(String targetClass) {
        this.targetClass = targetClass;
        if (targetClass != null && !"".equals(targetClass)) {
            openedTabs.add(targetClass);
        }
    }

    public String getSearchURL() {
        return searchURL;
    }

    public void setSearchURL(String searchURL) {
        this.searchURL = searchURL;
    }
    
    public Set<String> getOpenedTabs() {
        return openedTabs;
    }

    /**
     * Update the displayResults variable with any changes which were made to 
     * the resultSet, targetClass, or startIndex.
     */
    public void organizeResults() {

        // reset computed result lists
        filteredResults.clear();
        displayResults.clear();
        
        // filter by target class
        if ("".equals(targetClass) || targetClass == null) {
            filteredResults.addAll(resultSet);
        }
        else {
            for(SearchResult result : resultSet) {
                if (result.getClassName().equals(targetClass)) {
                    filteredResults.add(result);
                }
            }
        }
        
        // filter by startIndex
        int resultCounter = filteredResults.size();
        int endIndex = startIndex + pageSize;
        if (startIndex < resultCounter && startIndex >= 0) {
            for (int i = startIndex; i < endIndex && i < resultCounter; i++) {
                displayResults.add(filteredResults.get(i));
            }
        }
    }
}
