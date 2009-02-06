package gov.nih.nci.search;

/**
 * This type of range query searches locations relative to a genomic feature of 
 * some kind (defined by the subclass). It is possible to specify distances
 * upstream and downstream of the feature.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public abstract class RelativeRangeQuery extends RangeQuery {

    private static final long serialVersionUID = 1234567890L;
        
    private Long upstreamDistance = new Long(0);
    private Long downstreamDistance = new Long(0);
    
    public Long getDownstreamDistance() {
        return downstreamDistance;
    }
    
    public void setDownstreamDistance(Long downstreamDistance) {
        this.downstreamDistance = downstreamDistance;
    }
    
    public Long getUpstreamDistance() {
        return upstreamDistance;
    }
    
    public void setUpstreamDistance(Long upstreamDistance) {
        this.upstreamDistance = upstreamDistance;
    }
}
