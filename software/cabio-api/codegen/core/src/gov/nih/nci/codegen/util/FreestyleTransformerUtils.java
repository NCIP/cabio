/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.codegen.util;

import gov.nih.nci.ncicb.xmiinout.domain.UMLClass;
import gov.nih.nci.ncicb.xmiinout.domain.UMLAttribute;

/*
 * Created on Sep 10, 2007
 * ShaziyaMuhsin
 * 
 */
public class FreestyleTransformerUtils {

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
