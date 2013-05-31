/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.sod;import gov.nih.nci.caBIOApp.util.ConfigurationException;public interface SODFactory {    public SearchableObjectsDescription getSOD()    throws ConfigurationException;}