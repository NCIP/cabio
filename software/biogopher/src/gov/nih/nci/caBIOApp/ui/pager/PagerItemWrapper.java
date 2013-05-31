/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.pager;

public class PagerItemWrapper extends PagerItemImpl {

    private int _idx = -1;

    public PagerItemWrapper(int idx, PagerItem item) {
        super(item.getId(), item.getValues());
        _idx = idx;
    }

    public int getIndex() {
        return _idx;
    }
}
