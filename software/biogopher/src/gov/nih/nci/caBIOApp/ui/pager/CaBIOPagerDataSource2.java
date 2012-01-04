package gov.nih.nci.caBIOApp.ui.pager;

import gov.nih.nci.caBIOApp.sod.Association;
import gov.nih.nci.caBIOApp.sod.Attribute;
import gov.nih.nci.caBIOApp.sod.SODUtils;
import gov.nih.nci.caBIOApp.sod.SearchableObject;
import gov.nih.nci.caBIOApp.util.CaBIOUtils;
import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.search.SearchResult;
import gov.nih.nci.common.search.cache.ObjectCache;
import gov.nih.nci.common.search.cache.ObjectCacheFactory;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

public class CaBIOPagerDataSource2 implements PagerDataSource {

    protected static ObjectCache _cache = null;
    protected List _objects = new ArrayList();
    protected String[] _headers = null;
    protected String _eventHandler = null;
    protected SearchCriteria _sc = null;
    protected SODUtils _sod = null;
    protected int _count = 0;

    public CaBIOPagerDataSource2(String beanName, String eh) {
        try {
            _sc = CaBIOUtils.newSearchCriteria(beanName);
            _sc.setMaxRecordset(new Integer(500));
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error creating search criteria for "
                    + beanName + ": " + ex.toString());
        }
        _eventHandler = eh;
        init();
    }

    public CaBIOPagerDataSource2(SearchCriteria sc, String eh) {
        _sc = sc;
        _eventHandler = eh;
        init();
    }

    protected void init() {
        //System.err.println( "INIT: _sc.getBeanName() = " + _sc.getBeanName() );
        try {
            if (_cache == null) {
                _cache = ObjectCacheFactory.defaultObjectCache();
            }
            _sod = SODUtils.getInstance();
            //Try to retrive from cache.
            _sc.setReturnCount(new Boolean(true));
            _sc.setReturnObjects(new Boolean(true));
            SearchResult sr = _cache.get(_sc);
            if (sr == null) {
                sr = _sc.search();
                _cache.put(_sc, sr);
            }
            _count = sr.getCount().intValue();
            List newItems = Arrays.asList(sr.getResultSet());
            for (Iterator i = newItems.iterator(); i.hasNext();) {
                _objects.add(i.next());
            }
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error initializing: " + ex.toString());
        }
    }

    public void setEventHandler(String s) {
        _eventHandler = s;
    }

    public int getItemCount() throws Exception {
        return _count;
    }

    public PagerItem[] getItems(int startIdx, int numItems) throws Exception {
        //     System.err.println( "getItems(): startIdx = " + startIdx +
        // 			", numItems = " + numItems );
        int pis = startIdx + numItems;
        _sc.setStartAt(new Integer(startIdx + 1));
        _sc.setMaxRecordset(new Integer(numItems));
        SearchResult sr = _cache.get(_sc);
        if (sr == null) {
            sr = _sc.search();
            _cache.put(_sc, sr);
        }
        _objects = Arrays.asList(sr.getResultSet());
        //System.err.println( "_objects.size() = " + _objects.size() );
        pis = Math.min(_objects.size(), numItems);
        if (pis < 0) {
            pis = 0;
        }
        //System.err.println( "pis = " + pis );
        PagerItem[] items = new PagerItem[pis];
        SearchableObject so = _sod.getSearchableObject(_sc.getBeanName());
        for (int i = 0; i < items.length; i++) {
            //Object obj = _objects.get( startIdx + i );
            Object obj = _objects.get(i);
            Object idObj = CaBIOUtils.getProperty(obj, "id");
            String id = (idObj != null ? idObj.toString() : "");
            //System.err.println( "creating pi for " + obj.getClass().getName() + ":" + id );
            List labelProps = so.getLabelProperties();
            List assocs = getNavigableAssociations(so);
            List vals = new ArrayList();
            for (ListIterator j = labelProps.listIterator(); j.hasNext();) {
                Object val = CaBIOUtils.getProperty(obj,
                    ((String) j.next()).trim());
                if (val != null) {
                    vals.add(val.toString());
                }
                else {
                    vals.add("");
                }
            }
            if (_eventHandler != null) {
                for (ListIterator j = assocs.listIterator(); j.hasNext();) {
                    Association assoc = (Association) j.next();
                    vals.add("<a href=\"javascript:" + _eventHandler + "('"
                            + obj.getClass().getName() + "', '" + id + "', '"
                            + assoc.getRole() + "')\">" + assoc.getLabel()
                            + getCountString(obj, assoc.getRole()) + "</a>");
                }
            }
            items[i] = new PagerItemImpl(id,
                    (String[]) vals.toArray(new String[vals.size()]));
        }
        return items;
    }

    public String[] getHeaders() {
        if (_headers == null) {
            initHeaders();
        }
        return _headers;
    }

    private String getCountString(Object bean, String propName) {
        String countStr = "";
        /*
        Method[] methods = bean.getClass().getMethods();
        for( int i = 0; i < methods.length; i++ ){
          String name = methods[i].getName();
          if( name.toLowerCase().indexOf( propName.toLowerCase() ) != -1 && 
          name.toLowerCase().indexOf( "count" ) != -1 ){
        try{
          Integer count = (Integer)methods[i].invoke( bean, new Object[0] );
          countStr = "[" + count + "]";
          break;
        }catch( Exception ex ){
          MessageLog.printStackTrace( ex );
        }
          }
        }
        */
        return countStr;
    }

    protected List getNavigableAssociations(SearchableObject so) {
        List results = new ArrayList();
        List assocs = so.getAssociations();
        for (Iterator i = assocs.iterator(); i.hasNext();) {
            Association a = (Association) i.next();
            if (a.getNavigable()) {
                results.add(a);
            }
        }
        return results;
    }

    protected void initHeaders() {
        List h = new ArrayList();
        if (_sod == null) {
            throw new RuntimeException("sod is null");
        }
        if (_sc == null) {
            throw new RuntimeException("search criteria is null");
        }
        String beanName = _sc.getBeanName();
        if (beanName.endsWith("Impl")) {
            beanName = beanName.substring(0, beanName.indexOf("Impl"));
        }
        SearchableObject so = _sod.getSearchableObject(beanName);
        if (so == null) {
            throw new RuntimeException("Couldn't find so for " + beanName);
        }
        List labelProps = so.getLabelProperties();
        for (Iterator it = labelProps.iterator(); it.hasNext();) {
            String propName = (String) it.next();
            Attribute att = _sod.getAttribute(so, propName);
            if (att == null) {
                throw new RuntimeException(
                        "CaBIOPagerDataSource.init(): couldn't find attribute "
                                + propName + " on " + so.getClassname());
            }
            h.add(att.getLabel());
        }
        if (_eventHandler != null) {
            List assocs = getNavigableAssociations(so);
            for (Iterator it = assocs.iterator(); it.hasNext();) {
                Association assoc = (Association) it.next();
                h.add(assoc.getLabel());
            }
        }
        _headers = (String[]) h.toArray(new String[h.size()]);
    }
}
