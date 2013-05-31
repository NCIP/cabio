/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.cabio.domain.ExonArrayReporter;
import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class ExonReporterAnnotationsQuery extends InListQuery {

    private String arrayPlatform;
    
    private Collection<ExonArrayReporter> reporterList = 
        new ArrayList<ExonArrayReporter>();
    
    public ExonReporterAnnotationsQuery(String arrayPlatform, Collection<String> reporterIds) {
        super(reporterIds);
        this.arrayPlatform = arrayPlatform;
    }

    public Collection<ExonArrayReporter> getResults() {
        return reporterList;
    }

    protected Object generateQuery(List subList) {
        
        List params = new ArrayList();
        params.add(arrayPlatform);
        params.addAll(subList);
        
        String hql = "select reporter from " +
                "gov.nih.nci.cabio.domain.ExonArrayReporter reporter " +
                "left join reporter.microarray as microarray " +
                "where microarray.name = ? " +
                "and reporter.name in "+getPlaceholders(subList);

        return new HQLCriteria(hql,QueryUtils.createCountQuery(hql),params);
    }
    
    protected void processResult(Object result) {
        reporterList.add((ExonArrayReporter)result);
    }
}