/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.search;

import gov.nih.nci.common.util.ReflectionUtils;


/**
 * A range query relative to a genomic feature. The feature
 * must have a physicalLocationCollection or be a PhysicalLocation itself.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class FeatureRangeQuery extends RelativeRangeQuery {

    private static final long serialVersionUID = 1234567890L;
        
    private Object feature;

    public FeatureRangeQuery() {}
    
    /**
     * Constructor that copies search parameters another RelativeRangeQuery.
     * @param relativeRangeQuery query to copy parameters from
     */
    public FeatureRangeQuery(RelativeRangeQuery relativeRangeQuery) {
        setAssembly(relativeRangeQuery.getAssembly());
        setAllowPartialMatches(relativeRangeQuery.getAllowPartialMatches());
        setDownstreamDistance(relativeRangeQuery.getDownstreamDistance());
        setUpstreamDistance(relativeRangeQuery.getUpstreamDistance());
    }
    
    public Object getFeature() {
        return feature;
    }

    public void setFeature(Object feature) {
        this.feature = ReflectionUtils.upwrap(feature);
    }
}
