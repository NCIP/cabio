/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.sod;

import java.util.List;

public class SearchableObjectsDescriptionImplImpl extends
        SearchableObjectsDescriptionImpl {
    public SearchableObjectsDescriptionImplImpl() {
        super();
    }

    public List getSearchableObjects() {
        return SODUtils.sortSearchableObjects(super.getSearchableObjects());
    }
}
