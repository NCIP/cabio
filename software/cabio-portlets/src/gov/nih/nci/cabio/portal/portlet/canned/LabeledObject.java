/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet.canned;

import java.util.Set;

/**
 * A path in the object model that will be printed.
 * 
 * For example:
 *  name: physicalLocationCollection[0].assembly
 *  label: Assembly 
 * 
 * This would print the first location's assembly under the heading "Assembly".
 * The path expression syntax is defined by the CannedObjectConfig class.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class LabeledObject {

    private String name;
    private String label;
    private String externalLink;
    private String internalLink;
    private Set<String> roles;
    
    public LabeledObject(String name, String label, String externalLink, 
            String internalLink, Set<String> roles) {
        this.name = name;
        this.label = label;
        this.externalLink = externalLink;
        this.internalLink = internalLink;
        this.roles = roles;
    }

    public String getName() {
        return name;
    }

    public String getLabel() {
        return label;
    }
    
    public String getExternalLink() {
        return externalLink;
    }
    
    public String getInternalLink() {
        return internalLink;
    }
    
    public boolean isDisplayedForRole(String role) {
        return roles.contains(role);
    }

    /**
     * Returns the first part of the path. 
     * For example, we will return "arrayReporter" for the following path:
     * arrayReporter.microarray.manufacturer
     * @return
     */
    public String getFirstPart() {
        int firstDot = name.indexOf('.');
        if (firstDot < 0) return name;
        return name.substring(0,firstDot);
    }
    
    /**
     * Returns the last part of the path.
     * For example, we will return "manufacturer" for the following path:
     * arrayReporter.microarray.manufacturer
     * @return
     */
    public String getLastPart() {
        int lastDot = name.lastIndexOf('.');
        if (lastDot < 0) return name;
        return name.substring(lastDot+1);
    }
}
