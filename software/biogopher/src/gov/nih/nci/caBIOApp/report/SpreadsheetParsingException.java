/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.report;

import gov.nih.nci.caBIOApp.util.BaseException;

public class SpreadsheetParsingException extends BaseException {
    public SpreadsheetParsingException() {
        super();
    }

    public SpreadsheetParsingException(String s) {
        super(s);
    }

    public SpreadsheetParsingException(String s, Throwable t) {
        super(s, t);
    }

}
