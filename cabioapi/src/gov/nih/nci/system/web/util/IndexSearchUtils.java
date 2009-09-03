package gov.nih.nci.system.web.util;

import gov.nih.nci.search.SearchQuery;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.StringTokenizer;

/**
 * Created on May 1, 2007
 * @author Shaziya Muhsin
 */
public class IndexSearchUtils {

    SearchQuery searchQuery = new SearchQuery();
    List resultSet = new ArrayList();
    List displayResults = new ArrayList();
    int resultCounter = 0;
    int startIndex = 0;
    int pageSize = 100;
    boolean newQuery = true;
    String displayText = "";

    public IndexSearchUtils() {
    }
    
    public void setSearchQuery(SearchQuery searchQuery) {
        this.searchQuery = searchQuery;
    }

    public SearchQuery getSearchQuery() {
        return searchQuery;
    }

    public void setResultSet(List resultSet) {
        this.resultSet = resultSet;
    }

    public List getResultSet() {
        return resultSet;
    }

    public void setDisplayResults(List results) {
        this.displayResults = results;
    }

    public List getDisplayResults() {
        return displayResults;
    }

    public void setResultCounter(int resultCounter) {
        this.resultCounter = resultCounter;
    }

    public int getResultCounter() {
        return resultCounter;
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

    public void setNewQuery(boolean value) {
        this.newQuery = value;
    }

    public boolean isNewQuery() {
        return newQuery;
    }

    public void organizeResults() {
        int endIndex = startIndex + pageSize;
        displayResults = new ArrayList();
        if (startIndex < resultCounter && startIndex >= 0) {
            if (endIndex == 0 || endIndex < startIndex) {
                endIndex = startIndex + pageSize;
            }
            for (int i = startIndex; i < endIndex && i < resultCounter; i++) {
                displayResults.add(resultSet.get(i));
            }
        }
    }

    /**
     * @deprecated This method will be removed in the next release.
     */
    public String getKeyText(String keywords, String doc) {
        String keyDescription = null;
        StringTokenizer st = new StringTokenizer(keywords, " ");
        Set keys = new HashSet();
        while (st.hasMoreTokens()) {
            keys.add(st.nextToken());
        }
        StringTokenizer lines = new StringTokenizer(doc, ".");
        while (lines.hasMoreTokens()) {
            String sentence = lines.nextToken();
            for (Iterator it = keys.iterator(); it.hasNext();) {
                String key = (String) it.next();
                if (sentence.indexOf(key) > -1) {
                    // tokenize sentence
                    if (keyDescription == null) {
                        keyDescription = sentence;
                    }
                    String newSentence = "";
                    StringTokenizer tokens = new StringTokenizer(keyDescription, " "); 
                    while (tokens.hasMoreTokens()) {
                        String token = tokens.nextToken();
                        if (key.equalsIgnoreCase(token)) {
                            newSentence += " <b><i> " + token + " </i></b> ";
                        }
                        else {
                            newSentence += token + " ";
                        }
                    }
                    keyDescription = newSentence;
                }
            }
        }
        return keyDescription;
    }

}
