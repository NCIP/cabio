package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.search.SearchResult;
import gov.nih.nci.common.util.COREUtilities;

class SRCache implements java.io.Serializable {

    private Boolean _hasMore = null;
    private Integer _startsAt = null, _endsAt = null, _count = null;
    private SearchCriteria _nextCriteria = null;
    public final String[] identities;

    public SRCache(SearchResult sr) {
        _hasMore = new Boolean(sr.hasMore());
        _startsAt = sr.getStartsAt();
        _endsAt = sr.getEndsAt();
        _count = sr.getCount();
        _nextCriteria = sr.getNextCriteria();
        Object[] objs = sr.getResultSet();
        String[] idents = new String[objs.length];
        for (int i = 0; i < objs.length; i++) {
            try {
                idents[i] = objs[i].getClass().getName()
                        + ":"
                        + COREUtilities.invoke(objs[i], "getId", new Object[0]).toString();
            }
            catch (Exception ex) {
                ex.printStackTrace();
                throw new RuntimeException("Error creating identities: "
                        + ex.getMessage());
            }
        }
        identities = idents;
    }

    public SearchResult newSearchResult(Object[] objs) {
        SearchResult sr = new SearchResult();
        sr.setHasMore(_hasMore.booleanValue());
        sr.setStartsAt(_startsAt);
        sr.setEndsAt(_endsAt);
        sr.setCount(_count);
        sr.setNextCriteria(_nextCriteria);
        sr.setResultSet(objs);
        return sr;
    }
}
