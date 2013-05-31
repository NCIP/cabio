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

    private String keyword;
    private String targetClassName;
    private RangeFilter rangeFilter;
    private Boolean fuzzySearch = false;
    private Sort sort;
    private Collection resultCollection = new HashSet();
    private String queryType = "FULL_TEXT_SEARCH"; //HIBERNATE_SEARCH

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
    
    public String getTargetClassName() {
        return targetClassName;
    }

    public void setTargetClassName(String targetClassName) {
        this.targetClassName = targetClassName;
    }

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
}
