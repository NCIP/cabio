package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.portal.portlet.printers.JSONPrinter;

import java.util.ArrayList;
import java.util.List;

/**
 * The canned configuration for a given class. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ClassObject extends LabeledObject {
    
    private List<LabeledObject> attributes = new ArrayList<LabeledObject>();
    private List<LabeledObject> detailAttributes = new ArrayList<LabeledObject>();
    private String plural;
    
    public ClassObject(String name, String label, String plural) {
        super(name, label, null);
        this.plural = plural;
    }

    public String getPlural() {
        return plural;
    }
    
    public void addAttribute(String name, String label, boolean isDetail, JSONPrinter printerClass) {
        LabeledObject attr = new LabeledObject(name, label, printerClass);
        if (!isDetail) attributes.add(attr);
        detailAttributes.add(attr);
    }
    
    public List<LabeledObject> getAttributes() {
        return attributes;
    }
    
    public List<LabeledObject> getDetailAttributes() {
        return detailAttributes;
    }
}