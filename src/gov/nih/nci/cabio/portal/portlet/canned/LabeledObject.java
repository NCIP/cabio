package gov.nih.nci.cabio.portal.portlet.canned;

public class LabeledObject {

    private String name;
    private String label;
    
    public LabeledObject(String name, String label) {
        this.name = name;
        this.label = label;
    }

    public String getName() {
        return name;
    }

    public String getLabel() {
        return label;
    }
    
    public String getLastPart() {
        int lastDot = name.lastIndexOf('.');
        if (lastDot < 0) return name;
        return name.substring(lastDot+1);
    }
}
