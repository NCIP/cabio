/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.search;

/**
 * A range query relative to a feature specified by a big id. The feature
 * must either have a physicalLocationCollection or be a PhysicalLocation 
 * itself.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GridIdRangeQuery extends RelativeRangeQuery implements GridEntity {

    private static final long serialVersionUID = 1234567890L;
        
    private String bigId;
    
    public String getBigId() {
        return bigId;
    }

    public void setBigId(String bigId) {
        this.bigId = bigId;
    }
}
