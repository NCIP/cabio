package gov.nih.nci.cabio.portal.portlet.canned;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * This configuration object defines the fields which are displayed in the 
 * results of a Templated Search. The configuration is loaded from a 
 * tab-delimited configuration file in the classpath. 
 * 
 * To define a new class, the format is:
 * package.Class\tLabel\tPlural Label\tclass
 * 
 * To define an attribute in a previously defined class:
 * package.Class\tattributePath\tLabel\t(attr|detail)
 * 
 * The attributePath supports the following attribute syntax:
 * <ul> 
 * <li>attribute
 * <li>object.attribute
 * <li>collection.attribute (attributes are aggregated)
 * <li>collection[0].attribute
 * </ul>
 * 
 * The attributes may be marked "attr" or "detail". Attributes marked "attr" are
 * always displayed. Attributes marked "detail" are only displayed in the detail
 * view.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CannedObjectConfig {

    private static Log log = LogFactory.getLog(CannedObjectConfig.class);
    
    private Map<String,ClassObject> classes = new HashMap<String,ClassObject>();
    
    public CannedObjectConfig() throws Exception {
        
        BufferedReader reader = new BufferedReader(new InputStreamReader(
            getClass().getResourceAsStream("/cannedObject.txt")));
        
        String line = reader.readLine(); // discard header
        
        while((line = reader.readLine()) != null) {
            
            if ("".equals(line.trim())) continue; // discard empty lines
            
            String[] v = line.split("\t");

            if (v.length < 4) {
                throw new Exception("Config file has invalid number of entries:\n"+line);
            }
            
            try {
                if ("CLASS".equals(v[3])) {
                    classes.put(v[0], new ClassObject(v[0], v[1], v[2]));
                }
                else {
                    ClassObject classObj = classes.get(v[0]);
                    if (classObj == null) {
                        throw new Exception("Class not defined before use: "+v[0]);
                    }
                    
                    Set<String> roles = new HashSet(Arrays.asList(v[3].split(" ")));
                    String externalLink = v.length > 4 ? v[4] : null;
                    String internalLink = v.length > 5 ? v[5] : null;
                    classObj.addAttribute(v[1], v[2], externalLink, internalLink, roles);
                }
            }
            catch (Exception e) {
                log.error("Error parsing line: "+line);
                throw e;
            }
        }
    }

    public Map<String, ClassObject> getClasses() {
        return classes;
    }

    /**
     * Test harness.
     */
    public static final void main(String[] args) throws Exception {
        
        CannedObjectConfig c = new CannedObjectConfig();
        Map<String,ClassObject> classes = c.getClasses();
        for(String className : classes.keySet()) {
            ClassObject config = classes.get(className);
            System.out.println(className+": "+config.getLabel());
            for(LabeledObject attr : config.getAttributesForRole("SUMMARY")) {
                System.out.println("\t"+attr.getName()+": "+attr.getLabel());
            }
        }
    }
    
}
