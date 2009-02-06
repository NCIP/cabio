package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.system.applicationservice.ApplicationException;
import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.Iterator;
import java.util.List;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.util.StringHelper;

/**
 * A query which uses an "is in list" operation with potentially more than
 * 1000 items. In such cases, the query has to be performed multiple times
 * with the maximum of 1000 items each time. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public abstract class InListQuery {
    
    /**  
     * Even though the Oracle max for the "in list" operator is 1000, we can 
     * only get 999 results per query because if we try to iterate past that 
     * the SDK will run a count(*) to determine if it's at the end.
     */
    private static final int MAX = 999;

    /** The full input list. */
    protected Collection<String> ids;
    
    protected InListQuery(Collection<String> ids) {
        this.ids = ids;
    }
    
    /**
     * Generate the query with the given subList of parameters. This method is 
     * called by execute() with subsets of the input list.
     * @param subList a parameter list no longer than MAX items
     * @return Either a HQLCriteria or a DetachedCriteria query
     */
    protected abstract Object generateQuery(List subList);
    
    /**
     * Process one of the results coming back from the query.
     * @param results either a domain Object or Object[] array of column values
     */
    protected abstract void processResult(Object results);

    /**
     * Override this method to do some kind of post-processing after
     * the query is run and all results are processed individually.
     */
    protected void postQuery() {}
    
    /**
     * Perform all the queries necessary to retrieve all records given in the
     * input list. 
     * @param appService
     * @throws ApplicationException
     */
    public void execute(ApplicationService appService) throws ApplicationException {

        for (int i = 0; i < ((ids.size() / MAX) + 1); i++) {
            
            int size;
            if (i == (ids.size() / MAX)) {
                size = ids.size() % MAX;
            } else {
                size = MAX;
            }
            String[] tempArray = new String[size];
            System.arraycopy(ids.toArray(), i * MAX, tempArray, 0, size);
            List<String> tempList = new ArrayList<String>();
            Collections.addAll(tempList, tempArray);

            List results = null;
            Object query = generateQuery(tempList);
            if (query instanceof HQLCriteria) {
                results = appService.query((HQLCriteria)query);
            }
            else if (query instanceof DetachedCriteria) {
                results = appService.query((DetachedCriteria)query);
            }
            else {
                throw new ApplicationException("Invalid query type: "+
                    query.getClass().getName());
            }
//            System.out.println("size: "+results.size());
            
            for(Iterator it = results.iterator(); it.hasNext(); ) {
                processResult(it.next());
            }
        }
        
        postQuery();
    }
    
    /**
     * Convenience method for creating the (?,?,...,?) parameter placeholder 
     * list, if using HQL rather than the Criteria API.
     * @param params the input list
     * @return a list with as many placeholders as items in the input list
     */
    protected String getPlaceholders(List params) {
        return "("+StringHelper.repeat( "?, ",params.size()-1)+"?)";
    }
}