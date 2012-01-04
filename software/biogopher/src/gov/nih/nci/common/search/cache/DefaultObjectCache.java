package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.search.SearchResult;
import gov.nih.nci.common.util.COREUtilities;
import gov.nih.nci.common.util.SCPathWrapper;

import java.util.StringTokenizer;

import org.apache.jcs.JCS;

public class DefaultObjectCache implements ObjectCache, Runnable {

    protected static JCS _sc2src = null, _id2obj = null;
    protected static Thread _runner = null;
    protected int _sleepTime = 10 * 60000;
    protected static boolean _alive = false;

    public DefaultObjectCache() {
        try {
            if (_runner == null) {
                _sc2src = JCS.getInstance("sc2src");
                _id2obj = JCS.getInstance("id2obj");
                _alive = true;
                _runner = new Thread(this);
                _runner.start();
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error initializing cache.");
        }
    }

    public Object[] get(String beanName) throws CacheException {
        Object[] result = null;
        try {
            SearchCriteria sc = (SearchCriteria) Class.forName(
                COREUtilities.getSCClassName(beanName)).newInstance();
            SearchResult sr = get(sc);
            if (sr != null) {
                result = sr.getResultSet();
            }
        }
        catch (Exception ex) {
            throw new CacheException("Error getting all " + beanName, ex);
        }
        return result;
    }

    public void put(String beanName, Object[] objects) throws CacheException {
        try {
            SearchCriteria sc = (SearchCriteria) Class.forName(
                COREUtilities.getSCClassName(beanName)).newInstance();
            SearchResult sr = new SearchResult();
            sr.setResultSet(objects);
            put(sc, sr);
        }
        catch (Exception ex) {
            throw new CacheException("Error putting all " + beanName, ex);
        }
    }

    public SearchResult get(SearchCriteria sc) throws CacheException {
        SearchResult sr = null;
        try {
            SCCache scc = new SCCache(sc);
            SRCache src = (SRCache) _sc2src.get(scc);
            if (src != null) {
                Object[] objs = new Object[src.identities.length];
                for (int i = 0; i < objs.length; i++) {
                    objs[i] = _id2obj.get(src.identities[i]);
                }
                sr = src.newSearchResult(objs);
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new CacheException("Error retrieving search result.", ex);
        }
        return sr;
    }

    public void put(SearchCriteria sc, SearchResult sr) throws CacheException {
        try {
            Object[] objects = sr.getResultSet();
            SRCache src = new SRCache(sr);
            _sc2src.put(new SCCache(sc), src);
            for (int i = 0; i < objects.length; i++) {
                _id2obj.put(src.identities[i], objects[i]);
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new CacheException("Error caching search criteria.", ex);
        }
    }

    public static void main(String[] args) {
        try {
            String beanName = null;
            String criteria = null;
            int sleepTime = 10000;
            if (args.length == 3) {
                beanName = args[0];
                sleepTime = new Integer(args[1]).intValue();
                criteria = args[2];
            }
            else if (args.length == 2) {
                beanName = args[0];
                sleepTime = new Integer(args[1]).intValue();
            }
            else if (args.length == 1) {
                beanName = args[0];
            }
            else if (args.length == 0) {
                System.err.println("Usage: beanName [sleepTime] [criteria]");
            }
            SCPathWrapper scpw = new SCPathWrapper(beanName, "_");
            if (criteria != null) {
                StringTokenizer st = new StringTokenizer(criteria, ":");
                while (st.hasMoreTokens()) {
                    String token = st.nextToken();
                    int eqIdx = token.indexOf("=");
                    scpw.addCriterion(token.substring(0, eqIdx),
                        token.substring(eqIdx + 1));
                }
            }
            SearchCriteria sc = scpw.getSearchCriteria();
            ObjectCache oc = new DefaultObjectCache();
            SearchResult cachedSR = oc.get(sc);
            if (cachedSR == null) {
                System.out.println("No objects cached, retrieving...");
                SearchResult newSR = sc.search();
                Object[] objs = newSR.getResultSet();
                oc.put(sc, newSR);
                System.out.println("..." + objs.length + " objects cached.");
                oc.save();
                System.out.println("Saving (sleepTime = " + sleepTime + ")...");
                Thread.sleep(sleepTime);
            }
            else {
                Object[] objs = cachedSR.getResultSet();
                System.out.println(objs.length + " objects found.");
            }
            oc.shutdown();
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void shutdown() {
        System.out.println("Shutdown requested.");
        _alive = false;
        if (_runner != null) {
            _runner.interrupt();
        }
    }

    public void save() {
        //System.err.println( "DOC.SAVE" );
        try {
            synchronized (_sc2src) {
                _sc2src.save();
            }
            synchronized (_id2obj) {
                _id2obj.save();
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    public void run() {
        while (_alive) {
            try {
                _runner.sleep(_sleepTime);
            }
            catch (InterruptedException ex) {
                //nothing
            }
            try {
                save();
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }
            try {
                _sleepTime = new Integer(
                        System.getProperty("ObjectCacheSaveInterval")).intValue();
            }
            catch (Exception ex) {
                //nothing
            }
        }
        System.out.println("Shutting down.");
    }
}
