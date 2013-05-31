/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.common.util;

import gov.nih.nci.system.client.util.xml.caCOREMarshaller;
import gov.nih.nci.system.client.util.xml.caCOREUnmarshaller;

/**
 * Convenience class to simulate 3.2 behavior of the XMLUtility, that is
 * using the default caCORE marshallers.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class XMLUtility 
    extends gov.nih.nci.system.client.util.xml.XMLUtility {

    public XMLUtility() {
        super(new caCOREMarshaller("xml-mapping.xml",false), 
            new caCOREUnmarshaller("unmarshaller-xml-mapping.xml",false));
    }
}
