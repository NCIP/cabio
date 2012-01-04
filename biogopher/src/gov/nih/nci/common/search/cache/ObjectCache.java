package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.search.SearchResult;

public interface ObjectCache {

    public SearchResult get(SearchCriteria sc) throws CacheException;

    public void put(SearchCriteria sc, SearchResult sr) throws CacheException;

    public Object[] get(String beanName) throws CacheException;

    public void put(String beanName, Object[] objs) throws CacheException;

    public void save() throws CacheException;

    public void shutdown();
}
