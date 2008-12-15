package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.ClinicalTrialProtocol;
import gov.nih.nci.cabio.portal.portlet.canned.CannedObjectConfig;
import gov.nih.nci.cabio.portal.portlet.canned.ClassObject;
import gov.nih.nci.cabio.portal.portlet.canned.LabeledObject;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.Field;
import java.lang.reflect.Modifier;
import java.util.HashSet;
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
 * Servlet for AJAX which outputs caBIO objects in JSON format. Currently, 
 * only objects which are supported by ReportService and CannedObjectConfig
 * can be detailed.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ObjectDetailsJSONServlet extends HttpServlet {

    private static Log log = LogFactory.getLog(ObjectDetailsJSONServlet.class);
    
    private CaBioApplicationService as;
    private ReportService rs;
    
    public void init() throws ServletException {
        try {
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

        CannedObjectConfig objectConfig = 
            (CannedObjectConfig)getServletContext().getAttribute("objectConfig");
        ClassObject config = objectConfig.getClasses().get(className);

        res.setContentType("text/plain");
        PrintWriter out = res.getWriter();
        
        try {
            out.print(processRequest(config, className, id));
        }
        catch (Exception e) {
            log.error("Error encountered while outputting JSON object details for "+className+"#"+id,e);
            
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

    private String processRequest(ClassObject config, String className, 
            String id) throws Exception {

        if (!className.startsWith("gov.nih.nci.cabio.")) {
            throw new Exception("Invalid class specified.");
        }
        
        Class clazz = Class.forName(className); 
        Long longId = Long.parseLong(id);
        Object obj = rs.getDetailObject(clazz, longId);
        
        if (obj == null) {
            throw new Exception(className+" not found with id: "+id);
        }
        
        if (config == null) {
            String label = className.substring(className.lastIndexOf('.')+1);
            config = new ClassObject(className, label, label+"s");
            for(Field field : getFields(clazz)) {
                String name = field.getName();
                if (!name.equalsIgnoreCase("id"))
                    config.addAttribute(name, name, true);
            }
        }
        
        return objectToJSON(new ResultItem(className, obj), config);
    }
    
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
            
            Object value = item.get(attr.getName());
            if ((value == null) || ("".equals(value))) {
                jsonObj.put("value", "-");
            }
            else {
                jsonObj.put("value", value.toString());
            }
            
            attributes.put(jsonObj);
        }
        
        json.put("attributes",attributes);
        return json.toString();
    }
    
    /**
     * Borrowed from ClassCache.java in the caCORE SDK.
     * @param clazz
     * @return
     */
    public static Field[] getFields(Class clazz) {
        
        Set<Field> allFields = new HashSet<Field>();
        Class checkClass = clazz;
        
        while (checkClass != null) {
            Field[] classFields = checkClass.getDeclaredFields();
            if(classFields!=null) {
                for(int i=0;i<classFields.length;i++) {
                    Class type = classFields[i].getType();
                    String typeName = type.getName();
                    if (!Modifier.isStatic(classFields[i].getModifiers()) 
                            && ((type.isPrimitive() || 
                                (typeName.startsWith("java") && 
                                !"java.util.Collection".equals(typeName))))) {
                        allFields.add(classFields[i]);
                    }
                }
            }
            checkClass = checkClass.getSuperclass();
        }
        
        Field[] fieldArray = new Field[allFields.size()];
        allFields.toArray(fieldArray);
        return fieldArray;
    }
}