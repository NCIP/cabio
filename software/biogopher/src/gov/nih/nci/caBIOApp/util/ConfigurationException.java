/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.util;public class ConfigurationException extends BaseException {    public ConfigurationException() {        super();    }    public ConfigurationException(String s) {        super(s);    }    public ConfigurationException(String s, Throwable t) {        super(s, t);    }}