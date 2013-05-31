/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;

public class GenesForReportersQuery extends InListQuery {

    private String arrayPlatform;
    
    private HashMap<String, Collection<String>> reporterMap = 
        new HashMap<String, Collection<String>>();
    
    public GenesForReportersQuery(String arrayPlatform, Collection<String> reporterIds) {
        super(reporterIds);
        this.arrayPlatform = arrayPlatform;
    }

    public HashMap<String, Collection<String>> getResults() {
        return reporterMap;
    }

    protected Object generateQuery(List subList) {

        List params = new ArrayList();
        params.add(arrayPlatform);
        params.addAll(subList);
                
        String hql = "select reporter.name, gene.hugoSymbol, rownum from " +
                "gov.nih.nci.cabio.domain.ExpressionArrayReporter reporter " +
                "join reporter.gene as gene " +
                "join reporter.microarray as microarray " +
                "where gene.hugoSymbol is not null " +
                "and microarray.name = ? " +
                "and reporter.name in "+getPlaceholders(subList)+" "+
                "order by reporter.name";

        return new HQLCriteria(hql,QueryUtils.createCountQuery(hql),params);
    }
    
    protected void processResult(Object result) {
        Object[] cols =(Object[])result;
        Collection<String> genes = new HashSet<String>();
        genes.add((String)cols[1]);
        reporterMap.put((String)cols[0], genes);
    }
    
    protected void postQuery() {
        // Add in the gene-less reporters which were excluded by the inner join.
        List<String> empty = new ArrayList<String>();
        for(String reporterId : ids) {
            if (!reporterMap.containsKey(reporterId)) {
                reporterMap.put(reporterId, empty);
            }
        }
    }
}