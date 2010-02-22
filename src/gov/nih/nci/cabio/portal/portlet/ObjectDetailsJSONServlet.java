package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.Gene;
import gov.nih.nci.cabio.portal.portlet.canned.CannedObjectConfig;
import gov.nih.nci.cabio.portal.portlet.canned.ClassObject;
import gov.nih.nci.cabio.portal.portlet.canned.LabeledObject;
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
        
        Class clazz = Class.forName(className); 
        Long longId = Long.parseLong(id);
        
        String role = path==null ? "DETAIL" : "NESTED";
        Set<String> roles = new HashSet<String>();
        roles.add(role);

        if (path == null) {
            // Get the attribute configuration
            ClassObject config = objectConfig.getClasses().get(className);
            if (config == null) {
                String label = className.substring(className.lastIndexOf('.')+1);
                config = new ClassObject(className, label, label+"s");
                for(Field field : ClassUtils.getFields(clazz)) {
                    String name = field.getName();
                    if  (!name.equalsIgnoreCase("id")) 
                        config.addAttribute(name, name, null, null, roles);
                }
            }
            Object obj = rs.getDetailObject(clazz, longId);
            if (obj == null) {
                throw new Exception("Cannot find "+className+" with id "+id+".");
            }
            return objectToJSON(new ResultItem(obj), config);
        }
        else {
            // Need the class name of the association
            ClassObject config = objectConfig.getClasses().get(assocClass);
            if (config == null) {
                log.warn("No configuration for associated class "+assocClass);
                String label = className.substring(className.lastIndexOf('.')+1);
                config = new ClassObject(className, label, label+"s");
                Class assocClazz = Class.forName(assocClass); 
                for(Field field : ClassUtils.getFields(assocClazz)) {
                    String name = field.getName();
                    if  (!name.equalsIgnoreCase("id")) 
                        config.addAttribute(name, name, null, null, roles);
                }
            }

            // Are there any constraints? pull them out so we can apply them later
            String rolename = path;
            String constraint = null;
            int a = path.indexOf('.');
            int b = path.indexOf('[');
            if (a > 0) {
                rolename = path.substring(0, a);
                constraint = path.substring(a);
            }
            else if (b > 0) {
                rolename = path.substring(0, b);
                constraint = path.substring(b);
            }
            
            // Query for the associated objects
            Collection list = rs.getDetailObjects(clazz, longId, rolename);
            
            // Apply constraints
            if (constraint != null) {
                CollectionHolder holder = new CollectionHolder(list);
                list = (Collection)new ResultItem(holder).get("list"+constraint);
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
                    jsonObj.put("drillClassName", linkClassName);
                    jsonObj.put("drillId", item.get(attr.getInternalLink()+".id"));
                }
            }
            else {
                // Case 3) Association
                List<Class> classes = item.getClasses(attr.getName());
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
                    jsonObj.put("className", className);
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