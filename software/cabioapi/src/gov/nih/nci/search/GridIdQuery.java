/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.search;

import java.io.Serializable;

/**
 * This is a query object for searching by grid identifier. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GridIdQuery implements Serializable, GridEntity {

    private static final long serialVersionUID = 1234567890L;
  
    private String bigId;

    /* (non-Javadoc)
     * @see gov.nih.nci.search.GridEntity#getBigId()
     */
    public String getBigId() {
        return bigId;
    }

    /* (non-Javadoc)
     * @see gov.nih.nci.search.GridEntity#setBigId(java.lang.String)
     */
    public void setBigId(String bigId) {
        this.bigId = bigId;
    }

}
