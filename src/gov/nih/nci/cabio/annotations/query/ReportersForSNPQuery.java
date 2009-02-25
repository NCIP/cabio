package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

public class ReportersForSNPQuery extends InListQuery {

    private String arrayPlatform;

    private HashMap<String, Collection<String>> snpMap = 
        new HashMap<String, Collection<String>>();
    
    public ReportersForSNPQuery(String arrayPlatform, Collection<String> snpIds) {
        super(snpIds);
        this.arrayPlatform = arrayPlatform;
    }

    public HashMap<String, Collection<String>> getResults() {
        return snpMap;
    }

    protected Object generateQuery(List subList) {
        
        List params = new ArrayList();
        params.add(arrayPlatform);
        params.addAll(subList);
        
        String hql = "select snp.DBSNPID, reporter.name, rownum from " +
                "gov.nih.nci.cabio.domain.SNPArrayReporter reporter " +
                "left join reporter.SNP as snp " +
                "left join reporter.microarray as microarray " +
                "where microarray.name = ? " +
                "and snp.DBSNPID in "+getPlaceholders(subList)+" " +
                "order by snp.DBSNPID";

        return new HQLCriteria(hql,QueryUtils.createCountQuery(hql),params);
    }
    
    protected void processResult(Object result) {
        Object[] cols =(Object[])result;
        String dbsnpid = (String)cols[0];
        Collection<String> reporters = new ArrayList<String>();
        if (snpMap.containsKey(dbsnpid)) {
            reporters = snpMap.get(dbsnpid);
        }
        reporters.add((String)cols[1]);
        snpMap.put(dbsnpid, reporters);
    }
    
    protected void postQuery() {
        // Add in the reporter-less SNPs which were 
        // excluded by the inner join.
        List<String> empty = new ArrayList<String>();
        for(String dbsnpid : ids) {
            if (!snpMap.containsKey(dbsnpid)) {
                snpMap.put(dbsnpid, empty);
            }
        }
    }
}