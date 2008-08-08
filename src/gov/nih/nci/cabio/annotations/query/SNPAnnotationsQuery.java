package gov.nih.nci.cabio.annotations.query;

import gov.nih.nci.cabio.domain.SNP;
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
                "left join fetch snp.physicalLocationCollection as l " +
                "left join fetch l.chromosome as c " +
                "left join fetch snp.cytogeneticLocationCollection cl " +
                "left join fetch cl.startCytoband " +
                "where snp.DBSNPID in "+getPlaceholders(subList);
        
        return new HQLCriteria(hql,subList);
    }
    
    protected void processResult(Object result) {
        snpList.add((SNP)result);
    }
}