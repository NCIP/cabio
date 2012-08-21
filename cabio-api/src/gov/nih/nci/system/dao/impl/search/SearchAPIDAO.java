package gov.nih.nci.system.dao.impl.search;

import gov.nih.nci.search.RangeFilter;
import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.SearchResult;
import gov.nih.nci.search.SummaryQuery;
import gov.nih.nci.system.dao.DAO;
import gov.nih.nci.system.dao.Request;
import gov.nih.nci.system.dao.Response;
import gov.nih.nci.system.dao.impl.search.service.FullTextSearch;
import gov.nih.nci.system.dao.impl.search.service.HibernateSearch;
import gov.nih.nci.system.dao.impl.search.service.Searchable;
import gov.nih.nci.system.query.nestedcriteria.NestedCriteria;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.orm.hibernate3.support.HibernateDaoSupport;

/**
 * Provides DAO functionality to perform SDK searches on a Lucene-based index.
 * 
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class SearchAPIDAO extends HibernateDaoSupport implements DAO {
    
	private static final Logger log = Logger.getLogger(SearchAPIDAO.class);
    
    private static final List<String> DAO_CLASSES = new ArrayList<String>();
    static {
        DAO_CLASSES.add(SearchQuery.class.getName());
        DAO_CLASSES.add(SummaryQuery.class.getName());
    }
    
	private final String FILTER_AND = " AND ";
	private final String FILTER_OR = " OR ";
	private final String FILTER_TO = " TO ";
	private final String FILTER_OBRAC = "[";
	private final String FILTER_CBRAC = "]";
	private final String FILTER_COLON = ":";

	/**
	 * Performs queries against the lucene indexes
	 * 
	 * @param searchQuery
	 *            specifies the search criteria
	 * @return
	 * @throws FreestyleLMException
	 */
	public List query(SearchQuery searchQuery) throws FreestyleLMException {
		
		Searchable searchService = null;   
        if(searchQuery.getQueryType() == null){
            searchQuery.setQueryType(QueryType.FULL_TEXT_SEARCH.toString());
        }
		if (searchQuery.getQueryType().equals(QueryType.HIBERNATE_SEARCH.toString())) {
            searchService = new HibernateSearch(getSessionFactory());
		}
        else if(searchQuery.getQueryType().equals(QueryType.FULL_TEXT_SEARCH.toString())){
            searchService = new FullTextSearch();
        }
        else {
            throw new FreestyleLMException("Invalid query type: "+ searchQuery.getQueryType()+" - should be of "+ QueryType.FULL_TEXT_SEARCH.toString() +" or "+ QueryType.HIBERNATE_SEARCH.toString() );
        }     

		String qs = getQueryString(searchQuery);
		
        List<SearchResult> resultList = new ArrayList<SearchResult>();
        
        if (searchQuery.getSort() != null) {
            if (searchQuery.getTargetClassName() != null) {
                resultList = searchService.query(qs,
                    searchQuery.getTargetClassName(),searchQuery.getSort());
            }
            else {
                resultList = searchService.query(qs,searchQuery.getSort());
            }
        }
        else {
            if (searchQuery.getTargetClassName() != null) {
                resultList = searchService.query(qs,
                    searchQuery.getTargetClassName());
            }
            else {
                resultList = searchService.query(qs);
            }
        }            
	
		return resultList;
	}

    public List query(SummaryQuery summaryQuery) throws FreestyleLMException {
        FullTextSearch searchService = new FullTextSearch();
        return searchService.querySummary(summaryQuery.getKeyword());
    }
    
	/**
	 * Performs queries against the lucene indexes
	 * 
	 * @param request -
	 *            specifies the search criteria
	 * @return
	 * @throws FreestyleLMException
	 */
	public Response query(Request request) throws FreestyleLMException {

		List results = null; 
		
		Object searchObject = request.getRequest();
		if (searchObject instanceof NestedCriteria) {
			NestedCriteria criteria = (NestedCriteria) searchObject;
            if(criteria.getSourceObjectList()!=null){
                searchObject = (SearchQuery)criteria.getSourceObjectList().get(0);
            }
		}
		
		if (searchObject instanceof SearchQuery) {
		    results = query((SearchQuery)searchObject);
		}
		else if (searchObject instanceof SummaryQuery) {
            results = query((SummaryQuery)searchObject);
        }
        else {
            throw new FreestyleLMException(
                "Invalid query object: "+searchObject.getClass().getName());
        }
		
		return new Response(results);
	}

	/**
	 * Generates the search string for a given SearchQuery
	 * 
	 * @param searchQuery
	 * @return
	 * @throws FreestyleLMException
	 */
	private String getQueryString(SearchQuery searchQuery) throws FreestyleLMException {
		StringBuffer keyword = new StringBuffer();
		try {            
 			if (searchQuery.getKeyword() != null) {
				String startChars = "^[*?].+";
				//String charNeedsEscape = ".+[^(\\Q\\\\E)][(\\Q()\\\\E)\\[\\]\\^{}!:\"].*";
//				String charNeedsEscape = ".+[^(\\Q\\\\E)][\\[\\]\\^{}!:].*";
				String searchString = searchQuery.getKeyword();
                if(searchString.trim().matches(startChars)){                   
                    throw new FreestyleLMException("FreestyleLM Search does not support leading wildcard characters '*' or '?'");
//z                } else if (searchString.trim().matches(charNeedsEscape)){
//                	throw new FreestyleLMException("Please use the escape charactor for the special charactors such as !(){}[]^\":\\.");

                }else{
                    keyword = new StringBuffer(searchQuery.getKeyword());
                }
				if (searchQuery.getFuzzySearch()) {
                    if(keyword.indexOf("*")>-1){
                        keyword.deleteCharAt(keyword.indexOf("*"));
                    }
                    keyword.append("~");
				}
                
			}
			if (searchQuery.getRangeFilter() != null) {
				String filter = "";
				RangeFilter rangeFilter = searchQuery.getRangeFilter();
				if (rangeFilter.getFieldName() != null) {
					filter += rangeFilter.getFieldName() + FILTER_COLON;
				}
				String range = "";
				if (rangeFilter.getStartRange() != null
						&& rangeFilter.getEndRange() != null) {
					range += FILTER_OBRAC + rangeFilter.getStartRange()
							+ FILTER_TO + rangeFilter.getEndRange()
							+ FILTER_CBRAC;
				} 
                else if (rangeFilter.getEndRange() != null
						&& rangeFilter.getEndRange() == null) {
					range += rangeFilter.getStartRange();
				} 
                else if (rangeFilter.getEndRange() == null
						&& rangeFilter.getEndRange() != null) {
					range += rangeFilter.getEndRange();
				}
				if (filter != null && range != null) {
					keyword.append(FILTER_OR + filter + range);
				} 
                else if (filter != null && range == null) {
					filter += keyword.toString();
				} 
                else if (range != null) {
					keyword.append(FILTER_AND + range);
				}
			}
		} 
        catch (Exception ex) {
			throw new FreestyleLMException("Unable to create query: " + ex.getMessage());
		}       
        String keywords = keyword.toString().replaceAll(" [aA][nN][dD] ", FILTER_AND);
        keywords = keywords.replaceAll(" [oO][rR] ", FILTER_OR);
        return keywords;
	}

    public List<String> getAllClassNames() {
        return DAO_CLASSES;
    }
    public enum QueryType {
        FULL_TEXT_SEARCH, HIBERNATE_SEARCH;
    }

}
