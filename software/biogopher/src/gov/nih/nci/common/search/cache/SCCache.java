/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.common.search.cache;

import gov.nih.nci.common.search.SearchCriteria;

class SCCache implements java.io.Serializable {

    protected SearchCriteria _criteria = null;

    public SCCache(SearchCriteria sc) {
        _criteria = sc;
    }

    public SearchCriteria getSearchCriteria() {
        return _criteria;
    }

    public boolean equals(Object o) {
        boolean equals = true;
        if (!(o instanceof SCCache)) {
            equals = false;
        }
        else {
            SearchCriteria sc = ((SCCache) o).getSearchCriteria();
            if (_criteria == null && sc != null || _criteria != null
                    && sc == null) {
                equals = false;
            }
            else if (!sc.getBeanName().equals(_criteria.getBeanName())) {
                equals = false;
            }
            else if (!sc.equals(_criteria)) {
                equals = false;
            }
            else if (_criteria.getStartAt() == null
                    && sc.getStartAt() != null
                    || (_criteria.getStartAt() != null && !_criteria.getStartAt().equals(
                        sc.getStartAt()))
                    || _criteria.getMaxRecordset() == null
                    && sc.getMaxRecordset() != null
                    || (_criteria.getMaxRecordset() != null && !_criteria.getMaxRecordset().equals(
                        sc.getMaxRecordset()))
                    || _criteria.getReturnCount() == null
                    && sc.getReturnCount() != null
                    || (_criteria.getReturnCount() != null && !_criteria.getReturnCount().equals(
                        sc.getReturnCount()))
                    || _criteria.getReturnObjects() == null
                    && sc.getReturnObjects() != null
                    || (_criteria.getReturnObjects() != null && !_criteria.getReturnObjects().equals(
                        sc.getReturnObjects()))) {
                equals = false;
            }
            else {
                equals = true; //for clarity
            }
        }
        return true;
    }

    public int hashCode() {
        int h = 0;
        if (_criteria != null) {
            h += _criteria.hashCode();
            h += _criteria.getBeanName().hashCode();
            if (_criteria.getStartAt() != null) {
                h += _criteria.getStartAt().hashCode();
            }
            if (_criteria.getMaxRecordset() != null) {
                h += _criteria.getMaxRecordset().hashCode();
            }
            if (_criteria.getReturnObjects() != null) {
                h += _criteria.getReturnObjects().hashCode();
            }
            if (_criteria.getReturnCount() != null) {
                h += _criteria.getReturnCount().hashCode();
            }
        }
        return h;
    }
}
