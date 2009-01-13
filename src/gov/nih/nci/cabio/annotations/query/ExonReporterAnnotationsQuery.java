package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.cabio.domain.ExonArrayReporter;
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
//                "left join fetch reporter.geneCollection " +
//                "left join fetch reporter.physicalLocationCollection as pl " +
//                "left join fetch pl.chromosome " +
//                "left join fetch reporter.cytogeneticLocationCollection as cl " +
//                "left join fetch cl.startCytoband " +
                "left join reporter.microarray as microarray " +
                "where microarray.name = ? " +
                "and reporter.name in "+getPlaceholders(subList);
        
        return new HQLCriteria(hql,params);
    }
    
    protected void processResult(Object result) {
        reporterList.add((ExonArrayReporter)result);
    }
}