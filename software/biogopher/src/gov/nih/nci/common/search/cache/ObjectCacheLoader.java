/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.SearchCriteria;
import gov.nih.nci.common.search.SearchResult;

public class ObjectCacheLoader extends Thread {

    protected SearchCriteria _sc = null;
    protected int _sleepTime = 60000;

    public ObjectCacheLoader(SearchCriteria sc) {
        _sc = sc;
    }

    public ObjectCacheLoader(SearchCriteria sc, int sleepTime) {
        _sc = sc;
        _sleepTime = sleepTime;
    }

    public void run() {
        try {
            SearchResult sr = _sc.search();
            ObjectCache oc = ObjectCacheFactory.defaultObjectCache();
            oc.put(_sc, sr);
            oc.save();
            Thread.sleep(_sleepTime);
        }
        catch (Exception ex) {
            ex.printStackTrace();
            throw new RuntimeException("Error loading cache: "
                    + ex.getMessage());
        }
    }
}
