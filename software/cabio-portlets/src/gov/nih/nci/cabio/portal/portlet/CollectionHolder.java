/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet;

import java.util.Collection;

public class CollectionHolder {

    Collection list;
    
    public CollectionHolder(Collection list) {
        this.list = list;
    }
    
    public Collection getList() {
        return list;
    }
}
