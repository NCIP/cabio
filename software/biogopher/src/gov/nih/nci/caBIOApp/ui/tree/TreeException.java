/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.tree;import gov.nih.nci.caBIOApp.util.BaseException;public class TreeException extends BaseException {    public TreeException() {        super();    }    public TreeException(String s) {        super(s);    }    public TreeException(String s, Throwable t) {        super(s, t);    }}