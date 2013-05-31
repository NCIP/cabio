/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.report;

import java.io.IOException;
import java.io.InputStream;

public interface TableParser {

    public Table parse(InputStream in) throws IndexOutOfBoundsException,
            IOException;

}
