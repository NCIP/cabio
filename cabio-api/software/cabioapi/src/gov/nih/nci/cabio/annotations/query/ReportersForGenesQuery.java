package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.common.util.QueryUtils;
import gov.nih.nci.system.query.hibernate.HQLCriteria;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;

public class ReportersForGenesQuery extends InListQuery {

    private String arrayPlatform;
    
    private HashMap<String, Collection<String>> geneMap = 
        new HashMap<String, Collection<String>>();

    public ReportersForGenesQuery(String arrayPlatform, Collection<String> geneSymbols) {
        super(geneSymbols);
        this.arrayPlatform = arrayPlatform;
    }

    public HashMap<String, Collection<String>> getResults() {
        return geneMap;
    }

    protected Object generateQuery(List subList) {
        
        List params = new ArrayList();
        params.add(arrayPlatform);
        params.addAll(subList);
        
        String hql = "select gene.hugoSymbol, reporter.name, rownum from " +
                "gov.nih.nci.cabio.domain.ExpressionArrayReporter reporter " +
                "join reporter.gene as gene " +
                "join reporter.microarray as microarray " +
                "where microarray.name = ? " +
                "and gene.hugoSymbol in "+getPlaceholders(subList)+" "+
                "order by gene.hugoSymbol";

        return new HQLCriteria(hql,QueryUtils.createCountQuery(hql),params);
    }
    
    protected void processResult(Object result) {
        Object[] cols =(Object[])result;
        String geneSymbol = (String)cols[0];
        Collection<String> reporters = new ArrayList<String>();
        if (geneMap.containsKey(geneSymbol)) {
            reporters = geneMap.get(geneSymbol);
        }
        reporters.add((String)cols[1]);
        geneMap.put(geneSymbol, reporters);
    }

    protected void postQuery() {
        // Add in the reporter-less genes which were 
        // excluded by the inner join.
        List<String> empty = new ArrayList<String>();
        for(String geneSymbol : ids) {
            if (!geneMap.containsKey(geneSymbol)) {
                geneMap.put(geneSymbol, empty);
            }
        }
    }
}