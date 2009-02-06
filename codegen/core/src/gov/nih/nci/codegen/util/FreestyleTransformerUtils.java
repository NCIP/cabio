package gov.nih.nci.codegen.util;
import gov.nih.nci.codegen.GenerationException;
import gov.nih.nci.ncicb.xmiinout.domain.*;
import gov.nih.nci.ncicb.xmiinout.util.*;
/*
 * Created on Sep 10, 2007
 * ShaziyaMuhsin
 * 
 */
public class FreestyleTransformerUtils extends TransformerUtils{

    public FreestyleTransformerUtils() {
        super();       
    }
    public static boolean isClassIndexed(UMLClass klass){
        boolean indexClass = false;
        if(klass.getTaggedValue("ca_index_class")!=null){
            String index = klass.getTaggedValue("ca_index_class").getValue();
            if(index.equalsIgnoreCase("true")){
                indexClass = true;
            }
        }
        return indexClass;
    }
    public static boolean isAttributeIndexed(UMLAttribute attr){
        boolean indexAttribute = false;
        if(attr.getTaggedValue("ca_index_attribute")!=null){
            String index = attr.getTaggedValue("ca_index_attribute").getValue();
            if(index.equalsIgnoreCase("true")){
                indexAttribute = true;
            }
        }
        return indexAttribute;
    }

}
