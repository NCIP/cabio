package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.portal.portlet.JSONPrinter;

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
 * This class also allows for the configuration of a special "printer" for 
 * non-standard representations. For example, a collection of genes might 
 * be printed as a table, instead of the standard comma-delimited list.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class LabeledObject {

    private String name;
    private String label;
    private JSONPrinter printer;
    
    public LabeledObject(String name, String label, JSONPrinter printer) {
        this.name = name;
        this.label = label;
        this.printer = printer;
    }

    public String getName() {
        return name;
    }

    public String getLabel() {
        return label;
    }
    
    public JSONPrinter getPrinter() {
        return printer;
    }

    /**
     * Returns the last part of the path, i.e. every after the last comma. 
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
