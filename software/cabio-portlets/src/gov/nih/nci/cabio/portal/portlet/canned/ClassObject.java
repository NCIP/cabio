/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet.canned;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

/**
 * The canned configuration for a given class. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ClassObject extends LabeledObject {
    
    private List<LabeledObject> attributes = new ArrayList<LabeledObject>();
    private String plural;
    
    public ClassObject(String name, String label, String plural) {
        super(name, label, null, null, null);
        this.plural = plural;
    }

    public String getPlural() {
        return plural;
    }
    
    public void addAttribute(String name, String label, String externalLink,
            String internalLink, Set<String>roles) {
        LabeledObject attr = new LabeledObject(name, label, externalLink, 
            internalLink, roles);
        attributes.add(attr);
    }
    
    public List<LabeledObject> getAttributesForRole(String role) {
        List<LabeledObject> result = new ArrayList<LabeledObject>();
        for(LabeledObject attr : attributes) {
            if (attr.isDisplayedForRole(role)) result.add(attr);
        }
        return result;
    }

    public List<LabeledObject> getSummaryAttributes() {
        return getAttributesForRole("SUMMARY");
    }

    public List<LabeledObject> getDetailAttributes() {
        return getAttributesForRole("DETAIL");
    }
    
    public List<LabeledObject> getNestedAttributes() {
        return getAttributesForRole("NESTED");
    }
}