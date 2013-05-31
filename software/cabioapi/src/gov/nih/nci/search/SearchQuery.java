/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.search;

import java.io.Serializable;
import java.util.Collection;
import java.util.HashSet;

/**
 * 
 * @author Shaziya Muhsin
 */
public class SearchQuery implements Serializable {

    private static final long serialVersionUID = 1234567890L;
  
    //private Integer id;
    private String keyword;
    //private String source;    
    private RangeFilter rangeFilter;
    private Boolean fuzzySearch = false;
    private Sort sort;
    private Collection resultCollection = new HashSet();
    private String queryType = "FULL_TEXT_SEARCH";//HIBERNATE_SEARCH


//    public Integer getId() {
//        return id;
//    }
//
//    public void setId(Integer id) {
//        this.id = id;
//    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

//    public String getSource() {
//        return source;
//    }
//
//    public void setSource(String source) {
//        this.source = source;
//    }
    
    public Collection getResultCollection() {
        return resultCollection;
    }

    public void setResultCollection(Collection resultCollection) {
        this.resultCollection = resultCollection;
    }   
    public void setQueryType(String type) {
        queryType = type;
    }
    public String getQueryType() {
        return queryType;
    }
    public void setRangeFilter(RangeFilter rangeFilter) {
        this.rangeFilter = rangeFilter;
    }

    public RangeFilter getRangeFilter() {
        return rangeFilter;
    }

    public void setFuzzySearch(boolean fuzzy) {
        this.fuzzySearch = fuzzy;
    }

    public boolean getFuzzySearch() {
        return fuzzySearch;
    }

    public void setSort(Sort sorter) {
        sort = sorter;
    }

    public Sort getSort() {
        return sort;
    }
    
    public int hashCode() {
        int h = 0;
        //if (getId() != null) h += getId().hashCode();
        return h;
    }
}
