package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.common.util.ReflectionUtils;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Represents a single page of a result set. Provides access to statistics about
 * the pagination of the result set. Also see ResultItem class for individual 
 * items in this result set.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 * @see ResultSet
 */
public class Results {

    private static Log log = LogFactory.getLog(Results.class);

    private static final int PAGE_SIZE = 50;
    
    private final List resultList;
    private final Map<String, List<ResultItem>> items;
    private final int page;
    
    public Results(Collection results, int page) {
        
        this.resultList = (List)results;
        this.page = page;
        this.items = new TreeMap<String, List<ResultItem>>();
        
        for(int i=page*PAGE_SIZE; i<page*PAGE_SIZE+PAGE_SIZE && i<resultList.size(); i++) {
            Object o = resultList.get(i);
            String className = o.getClass().getName().split("\\$\\$")[0];
            List<ResultItem> objs = items.get(className);
            if (objs == null) objs = new ArrayList<ResultItem>();
            items.put(className, objs);
            objs.add(new ResultItem(className, o));
        }

        log.info("done grouping "+results.size()+" items into "+items.size()+" classes");
    }

    /**
     * Returns the results grouped by class.
     */
    public Map<String, List<ResultItem>> getItems() {
        return items;
    }

    /**
     * Returns the page number represented by this object.
     */
    public int getPage() {
        return page;
    }
    
    /**
     * Returns the 1-indexed record number of the first item.
     */
    public int getStartRecord() {
        return page*PAGE_SIZE+1;
    }

    /**
     * Returns the 1-indexed record number of the last item.
     */
    public int getEndRecord() {
        int end =  page*PAGE_SIZE + PAGE_SIZE;
        if (end > getNumRecords()) return getNumRecords();
        return end;
    }

    /**
     * Returns the total number of records.
     */
    public int getNumRecords() {
        return resultList.size();
    }
    
    /**
     * Returns the total number of pages.
     */
    public int getNumPages() {
        return (int)Math.ceil((float)resultList.size() / (float)PAGE_SIZE);
    }
    
    /**
     * Allows for dynamic JSTL bracket access to result item properties.
     * For example, if you have an instance called item you can write 
     * item["bigid"] to retrieve item.getBigid(). 
     * 
     * In addition, the syntax supports object graph navigation, for example,
     * item["gene.taxon.id"] will return getGene().getTaxon().getId(). If one
     * of the path elements is a List, it is iterated through and the results 
     * are aggregated into a comma-separated list.
     * 
     * Finally, ResultItems also support certain special underscore properties:
     * <ul>
     * <li>_obj: allows direct access to the underlying object
     * <li>_querystr: returns the query string for the REST URL for accessing the object in caBIO
     * </ul>
     */
    public class ResultItem extends GetOnlyMap {
        
        private String className;
        private Object obj;
        
        public ResultItem(String className, Object obj) {
            this.className = className;
            this.obj = obj;
        }

        public Object get(Object key) {
            String attributePath = (String)key;
            if ("_obj".equals(key)) return obj;
            if ("_querystr".equals(key)) {
                try {
                    Object id = ReflectionUtils.get(obj, "id");
                    return "?query="+className+"&"+className+"[@id="+id+"]";
                }
                catch (Exception e) {
                    log.error("Error constructing URL",e);
                    return "#";
                }
            }
            return resolve(obj, attributePath);
        }
        
        private Object resolve(Object object, String path) {

            int d = path.indexOf('.');
            String attr = (d < 0) ? path : path.substring(0,d);

            int a = attr.indexOf('[');
            int b = attr.indexOf(']');
            int index = -1;
            if (a > 0) {
                index = Integer.parseInt(attr.substring(a+1,b));
                attr = attr.substring(0,a);
            }
            
            Object nextObj;
            try {
                nextObj = ReflectionUtils.get(object, attr);
            }
            catch (Exception e) {
                log.error("Attribute error for "+path,e);
                return "ERROR";
            }

            if (d < 0) {
                // this is the target attribute
                return nextObj;
            }
            else {
                String nextPath = path.substring(d+1);
                if (nextObj instanceof List) {
                    List nextList = (List)nextObj;
                    
                    // just need one element from the list
                    if (index >= 0) {
                        try {
                            nextObj = nextList.get(index);
                        }
                        catch (IndexOutOfBoundsException e) {
                            return "";
                        }
                        return resolve(nextObj, nextPath);
                    }
                    
                    // aggregate all the elements in the list
                    StringBuffer buf = new StringBuffer();
                    int c = 0;
                    for(Object e : (List)nextObj) {
                        if (c++ > 0) buf.append(", ");
                        buf.append(resolve(e, nextPath));
                    }
                    return buf.toString();
                }
                else {
                    return resolve(nextObj, nextPath);
                }
            }
        }
    }
}
