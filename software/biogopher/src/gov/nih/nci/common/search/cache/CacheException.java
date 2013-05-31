/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.common.search.cache;

public class CacheException extends gov.nih.nci.common.exception.BaseException {

    public CacheException() {
        super();
    }

    public CacheException(String s) {
        super(s);
    }

    public CacheException(String s, Throwable t) {
        super(s, t);
    }
}
