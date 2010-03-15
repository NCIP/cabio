package gov.nih.nci.cabio.portal.portlet;

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

    private static final int PAGE_SIZE = 40;
    
    private final List resultList;
    private final Map<String, List<ResultItem>> items;
    private final int page;
    
    public Results(Collection results, int page) {
        
        this.resultList = (List)results;
        this.page = page;
        this.items = new TreeMap<String, List<ResultItem>>();
        
        for(int i=page*PAGE_SIZE; i<page*PAGE_SIZE+PAGE_SIZE && i<resultList.size(); i++) {
            Object o = resultList.get(i);
            String className = ClassUtils.removeEnchancer(o.getClass().getName());
            List<ResultItem> objs = items.get(className);
            if (objs == null) objs = new ArrayList<ResultItem>();
            items.put(className, objs);
            objs.add(new ResultItem(o));
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
    
}
