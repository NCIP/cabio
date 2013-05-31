/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.portal.portlet.canned.CannedObjectConfig;
import gov.nih.nci.cabio.portal.portlet.canned.ClassObject;
import gov.nih.nci.cabio.portal.portlet.canned.LabeledObject;
import gov.nih.nci.common.util.ReflectionUtils;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet for AJAX which outputs caBIO objects in JSON format. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ObjectDetailsJSONServlet extends HttpServlet {
    
    protected final int MAX_CHILD_ITEMS = 100;
    
    private static Log log = LogFactory.getLog(ObjectDetailsJSONServlet.class);

    private CannedObjectConfig objectConfig;
    private CaBioApplicationService as;
    private ReportService rs;
    
    public void init() throws ServletException {
        try {
            this.objectConfig = (CannedObjectConfig)
                getServletContext().getAttribute("objectConfig");
            
            this.as = (CaBioApplicationService)
                ApplicationServiceProvider.getApplicationService();
            
            this.rs = new ReportService(as);
        }
        catch (Exception e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
            throws ServletException, IOException {

        String className = req.getParameter("className");
        String id = req.getParameter("id");
        String path = req.getParameter("path");
        String assocClass = req.getParameter("assocClass");

        res.setContentType("text/plain");
        PrintWriter out = res.getWriter();
       
        try {
            if (path != null && !path.matches("^[\\w\\.]+(\\[\\w+=\\w+\\])?$")) {
                throw new IllegalArgumentException(
                    "Target must be a valid association path.");
            }
            out.print(processRequest(className, id, path, assocClass));
        }
        catch (Exception e) {
            log.error("Error encountered while outputting JSON object details for "+
                className+"#"+id+", "+path,e);
            
            JSONObject json = new JSONObject();
            try {
                json.put("exceptionClass", e.getClass().getName());
                json.put("exceptionMessage", e.getMessage());
            }
            catch (JSONException j) {
                log.error("Error returning JSON error message",j);
            }
            out.print(json.toString());
        }
    }

    
    protected String processRequest(String className, String id, String path, 
            String assocClass) throws Exception {

        if (!className.startsWith("gov.nih.nci.")) {
            throw new Exception("Invalid class specified.");
        }
        
        log.info("Object details ("+className+","+id+","+path+","+assocClass+")");
        
        Class clazz = Class.forName(className); 
        Long longId = Long.parseLong(id);
                
        String role = path==null ? "DETAIL" : "NESTED";

        if (path == null) {
            // The object configuration
            ClassObject config = objectConfig.getClasses().get(className);
            if (config == null) config = createAdhocConfig(className, role);
            
            // Query for the object
            Object obj = rs.getDetailObject(clazz, longId);
            if (obj == null) {
                throw new Exception("Cannot find "+className+" with id "+id+".");
            }
            
            return objectToJSON(new ResultItem(obj), config);
        }
        else {
            // The object configuration
            ClassObject config = objectConfig.getClasses().get(assocClass);
            if (config == null) config = createAdhocConfig(assocClass, role);
            
            // Are there any constraints? pull them out so we can apply them later
            String rolename = path;
            String extraPath = null;
            int a = path.indexOf('.');
            int b = path.indexOf('[');
            if (a > 0) {
                rolename = path.substring(0, a);
                extraPath = path.substring(a);
            }
            else if (b > 0) {
                rolename = path.substring(0, b);
                extraPath = path.substring(b);
            }
            
            // Query for the associated objects
            Collection list = rs.getDetailObjects(clazz, longId, rolename, config);
            
            // Apply further path constraints
            if (extraPath != null) {
                
                // Create a dummy root object
                Object root = clazz.newInstance();
                ReflectionUtils.setFieldValue(root, rolename, list);
                
                ResultItem item = new ResultItem(root);
                list = (Collection)item.get(path);
                
                // Configure display according to the last class in the path
                List<Class> pathClasses = item.getClasses(path);
                
                String lastClassName = pathClasses.get(pathClasses.size()-1).getName();
                config = objectConfig.getClasses().get(lastClassName);
            }
                        
            return objectsToJSON(list, config).toString();
        }
    }
    
    /**
     * Converts the given item to a JSON string representation, based on the 
     * configuration provided.
     * @param item the item to render into JSON
     * @param config configuration for the class of the item
     * @return JSON string representation of item
     * @throws JSONException
     */
    private String objectToJSON(ResultItem item, ClassObject config) 
            throws JSONException {
        
        JSONObject json = new JSONObject();
        json.put("className", config.getName());
        json.put("id", item.get("id").toString());
        json.put("label", config.getLabel());
        
        JSONArray attributes = new JSONArray();
        for (LabeledObject attr : config.getDetailAttributes()) {
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("name", attr.getLabel());
            jsonObj.put("path", attr.getName());
            Object value = item.get(attr.getName());
            
            if (value == null) {
                // Case 1) Null
                jsonObj.put("value", "");
            }
            else if (value.getClass().getName().startsWith("java.lang") 
                    || value.getClass().equals(java.util.Date.class)) {
                // Case 2) Normal attribute
                Object displayValue = item.getDisplayMap().get(attr.getName());
                jsonObj.put("value", displayValue);
                if (attr.getExternalLink() != null) {
                    jsonObj.put("link", attr.getExternalLink());
                }
                if (attr.getInternalLink() != null) {
                    List<Class> linkClasses = item.getClasses(attr.getInternalLink());
                    String linkClassName = linkClasses.get(linkClasses.size()-1).getName();
                    jsonObj.put("drillClassName", ClassUtils.removeEnchancer(linkClassName));
                    jsonObj.put("drillId", item.get(attr.getInternalLink()+".id"));
                }
            }
            else {
                // Case 3) Association
                List<Class> classes = item.getClasses(attr.getName());
                // The class we will display (the last one)
                String className = classes.get(classes.size()-1).getName();
                
                if (className.startsWith("java.lang") 
                        || className.equals("java.util.Date")) {
                    // Usually a list of Strings 
                    String displayValue = item.getDisplayMap().get(attr.getName());
                    jsonObj.put("value", displayValue);
                    if (attr.getExternalLink() != null) {
                        jsonObj.put("link", attr.getExternalLink());
                    }
                }
                else {
                    // The class we will fetch (the first one)
                    jsonObj.put("className", 
                        ClassUtils.removeEnchancer(classes.get(1).getName()));
                }
            }
            
            attributes.put(jsonObj);
        }
        
        json.put("attributes",attributes);
        return json.toString();
    }

    /**
     * Converts the given collection into a JSON string representation, 
     * based on the configuration provided.
     * @param items the collection to render into JSON
     * @param config configuration for the class of the collection items
     * @return JSON string representation of item
     * @throws JSONException
     */
    private JSONObject objectsToJSON(Collection items, ClassObject config) 
            throws JSONException {
        
        JSONObject json = new JSONObject();
        
        JSONArray cols = new JSONArray();
        for (LabeledObject attr : config.getNestedAttributes()) {
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("value", attr.getLabel());
            if (attr.getExternalLink() != null) {
                jsonObj.put("link", attr.getExternalLink());
            }
            cols.put(jsonObj);
        }
        json.put("columnNames", cols);
        json.put("className", config.getName());
        
        JSONArray rows = new JSONArray();
        
        if (items == null) {
            json.put("count", "0");
        }
        else {
            json.put("count", items.size());
            int c=0;
            for(Object o : items) {
                if (c++ >= MAX_CHILD_ITEMS) break;
                
                ResultItem r = new ResultItem(o);
    
                JSONObject jsonRow = new JSONObject();
                for (LabeledObject attr : config.getNestedAttributes()) {
                    String displayValue = r.getDisplayMap().get(attr.getName());
                    jsonRow.put(attr.getLabel(), displayValue);
                }
                jsonRow.put("id", r.get("id"));
                
                rows.put(jsonRow);
            }
        }
        
        json.put("rows", rows);
        return json;
    }

    /**
     * Convert class name for display, i.e.
     * "gov.nih.nci.cabio.domain.ClinicalTrialProtocol" to
     * "Clinical Trial Protocol"
     * @param className
     * @return
     */
    private String getFormattedClassName(String className) {
        return className.substring(className.lastIndexOf('.')+1).replaceAll(
                "([A-Z])"," $1").substring(1);
    }

    /**
     * Create an Ad Hoc configuration for what to display for a class that
     * is not explicitly configured. 
     * @param className
     * @param role
     * @return
     * @throws ClassNotFoundException
     */
    private ClassObject createAdhocConfig(String className, String role) 
            throws ClassNotFoundException {

        log.warn("No configuration for associated class "+className);
        Set<String> roles = new HashSet<String>();
        roles.add(role);
        String classLabel = getFormattedClassName(className);
        ClassObject config = new ClassObject(className, classLabel, classLabel+"s");
        Class assocClazz = Class.forName(className); 
        for(Field field : ClassUtils.getFields(assocClazz)) {
            String name = field.getName();
            if  (!name.equalsIgnoreCase("id")) 
                config.addAttribute(name, name, null, null, roles);
        }
        
        return config;
    }
    
    /**
     * Test harness.
     */
    public static final void main(String[] args) throws Exception {
        
//        String className = "gov.nih.nci.cabio.domain.GeneOntology";
//        String id = "32869";
//        CannedObjectConfig c = new CannedObjectConfig();
//        ClassObject config = c.getClasses().get(className);
//        ObjectDetailsJSONServlet s = new ObjectDetailsJSONServlet();
//        System.out.println(s.processRequest(config, className, id));
        
        System.out.println(ClassUtils.getAssociationType(Gene.class, "taxon"));
        System.out.println(ClassUtils.getAssociationType(Gene.class, "geneFunctionAssociationCollection"));
        
    }
}