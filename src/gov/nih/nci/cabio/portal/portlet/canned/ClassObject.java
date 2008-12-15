package gov.nih.nci.cabio.portal.portlet.canned;

import java.util.ArrayList;
import java.util.List;

public class ClassObject extends LabeledObject {
    
    private List<LabeledObject> attributes = new ArrayList<LabeledObject>();
    private List<LabeledObject> detailAttributes = new ArrayList<LabeledObject>();
    private String plural;
    
    public ClassObject(String name, String label, String plural) {
        super(name, label);
        this.plural = plural;
    }

    public String getPlural() {
        return plural;
    }
    
    public void addAttribute(String name, String label, boolean isDetail) {
        LabeledObject attr = new LabeledObject(name, label);
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