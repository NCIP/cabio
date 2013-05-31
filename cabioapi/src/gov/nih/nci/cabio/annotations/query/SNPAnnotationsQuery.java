/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.cabio.domain.SNP;
import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;

public class SNPAnnotationsQuery extends InListQuery {

    private final Collection<SNP> snpList = new ArrayList<SNP>();
    
    public SNPAnnotationsQuery(Collection<String> snpIds) {
        super(snpIds);
    }

    public Collection<SNP> getResults() {
        return snpList;
    }

    protected Object generateQuery(List subList) {

        String hql = "select snp from " +
                "gov.nih.nci.cabio.domain.SNP snp " +
                "where snp.DBSNPID in "+getPlaceholders(subList);

        return new HQLCriteria(hql,QueryUtils.createCountQuery(hql),subList);
    }
    
    protected void processResult(Object result) {
        snpList.add((SNP)result);
    }
}