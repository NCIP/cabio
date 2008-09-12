package gov.nih.nci.cabio.portal.portlet.canned;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CannedObjectConfig {

    private Map<String,ClassObject> classes = new HashMap<String,ClassObject>();
    
    public CannedObjectConfig() throws Exception {
        
        BufferedReader reader = new BufferedReader(new InputStreamReader(
            getClass().getResourceAsStream("/cannedObject.conf")));
        
        String line = null;
        while((line = reader.readLine()) != null) {
            if ("".equals(line.trim())) continue;
            String[] v = line.split("\t");
            if (v.length != 3) {
                throw new Exception("Config file is invalid. Three columns were not found on this line: '"+line+"'");
            }
            if ("".equals(v[1])) {
                classes.put(v[0], new ClassObject(v[0], v[2]));
            }
            else {
                ClassObject classObj = classes.get(v[0]);
                classObj.addAttribute(v[1], v[2]);
            }
        }
    }

    public Map<String, ClassObject> getClasses() {
        return classes;
    }

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
    }
    
    public class ClassObject extends LabeledObject {
        
        private List<LabeledObject> attributes = new ArrayList<LabeledObject>();
        
        public ClassObject(String name, String label) {
            super(name, label);
        }

        void addAttribute(String name, String label) {
            attributes.add(new LabeledObject(name, label));
        }
        
        public List<LabeledObject> getAttributes() {
            return attributes;
        }
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
            for(LabeledObject attr : config.getAttributes()) {
                System.out.println("\t"+attr.getName()+": "+attr.getLabel());
            }
        }
    }
    
}
