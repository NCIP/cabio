package gov.nih.nci.search;

import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.common.util.ReflectionUtils;

/**
 * This type of range query searches by an absolute location range on a specific
 * chromosome. The chromosome can be specified by id (for web based queries) or 
 * by the actual Chromosome class association.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AbsoluteRangeQuery extends RangeQuery {

    private static final long serialVersionUID = 1234567890L;
        
    private Chromosome chromosome;
    private Long chromosomeId;
    private Long start;
    private Long end;
    
    public Chromosome getChromosome() {
        return chromosome;
    }
    
    public void setChromosome(Chromosome chromosome) {
        this.chromosome = (Chromosome)ReflectionUtils.upwrap(chromosome);
    }
    
    public Long getChromosomeId() {
        return chromosomeId;
    }
    
    public void setChromosomeId(Long chromosomeId) {
        this.chromosomeId = chromosomeId;
    }
    
    public Long getEnd() {
        return end;
    }
    
    public void setEnd(Long end) {
        this.end = end;
    }
    
    public Long getStart() {
        return start;
    }
    
    public void setStart(Long start) {
        this.start = start;
    }
}
