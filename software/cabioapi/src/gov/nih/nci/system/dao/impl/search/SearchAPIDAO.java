package gov.nih.nci.system.dao.impl.search;

import gov.nih.nci.search.RangeFilter;
import gov.nih.nci.search.SearchQuery;
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

/**
 * Provides DAO functionality to perform SDK searches on a Lucene-based index.
 * 
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class SearchAPIDAO implements DAO {
    
	private static final Logger log = Logger.getLogger(SearchAPIDAO.class);
    
    private static final List<String> DAO_CLASSES = new ArrayList<String>();
    static {
        DAO_CLASSES.add(SearchQuery.class.getName());
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
            searchService = new HibernateSearch();
		}
        else if(searchQuery.getQueryType().equals(QueryType.FULL_TEXT_SEARCH.toString())){
            searchService = new FullTextSearch();
        }
        else {
            throw new FreestyleLMException("Invalid query type: "+ searchQuery.getQueryType()+" - should be of "+ QueryType.FULL_TEXT_SEARCH.toString() +" or "+ QueryType.HIBERNATE_SEARCH.toString() );
        }     

        List resultList = new ArrayList();
        if (searchQuery.getSort() != null){
            if(searchQuery.getSort().getSortByClassName()){
                resultList = searchService.query(getQueryString(searchQuery),searchQuery.getSort());
            }
            else{
                resultList = searchService.query(getQueryString(searchQuery));
            }
        }
        else{
            resultList = searchService.query(getQueryString(searchQuery));
        }            
	
		return resultList;
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
		Object searchObject = request.getRequest();
		SearchQuery searchQuery = null;
		if (searchObject instanceof NestedCriteria) {
			NestedCriteria criteria = (NestedCriteria) searchObject;                
            if(criteria.getSourceObjectList()!=null){
                searchQuery = (SearchQuery)criteria.getSourceObjectList().get(0);
            }				
		} 
        else if (searchObject instanceof SearchQuery) {
			searchQuery = (SearchQuery)searchObject;
		}
        else {
            throw new FreestyleLMException(
                "No query for: "+searchObject.getClass().getName());
        }
		return new Response(query(searchQuery));
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
        return keyword.toString();
	}

    public List<String> getAllClassNames() {
        return DAO_CLASSES;
    }
    public enum QueryType {
        FULL_TEXT_SEARCH, HIBERNATE_SEARCH;
    }

}
