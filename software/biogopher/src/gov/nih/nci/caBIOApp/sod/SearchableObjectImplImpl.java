/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.sod;

import java.util.List;

public class SearchableObjectImplImpl extends SearchableObjectImpl {
    public SearchableObjectImplImpl() {
        super();
    }

    public List getAssociations() {
        return SODUtils.sortAssociations(super.getAssociations());
    }

    public List getAttributes() {
        return SODUtils.sortAttributes(super.getAttributes());
    }
}
