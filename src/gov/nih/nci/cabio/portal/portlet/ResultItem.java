package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.GeneFunctionAssociation;
import gov.nih.nci.common.util.ReflectionUtils;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Allows for dynamic JSTL bracket access to SDK bean properties.
 * For example, if you have an instance called item you can write 
 * item["bigid"] to retrieve item.getBigid(). 
 * 
 * In addition, the syntax supports object graph navigation, for example,
 * item["gene.taxon.id"] will return getGene().getTaxon().getId(). If one
 * of the path elements is a List, it is iterated through and the results 
 * are aggregated into a comma-separated list.
 * 
 * Finally, ResultItems also support certain special underscore properties:
 * <ul>
 * <li>_obj: allows direct access to the underlying object
 * <li>_querystr: returns the query string for the REST URL for accessing the object in caBIO
 * <li>_className: returns the fully-qualified name of the class
 * <li>displayMap: returns a proxy which behaves exactly like the current object
 * except that it formats results as strings for screen display.
 * </ul>
 */
public class ResultItem extends GetOnlyMap<Object> {

    private static Log log = LogFactory.getLog(ResultItem.class);
    
    private String className;
    private Object obj;
    
    public ResultItem(Object obj) {

        String cn = obj.getClass().getName();
        this.className = cn.split("\\$\\$")[0];
        
        this.obj = obj;
    }
    
    public GetOnlyMap<String> getDisplayMap() {
        return new GetOnlyMap<String>() {
            public String get(Object key) {
                Object value = ResultItem.this.get(key);
                StringBuffer sb = new StringBuffer();
                // Convert List to comma delimited list 
                if (value instanceof List) {
                    for(Object o : (List)value) {
                        if (sb.length() > 0) sb.append(", ");
                        sb.append(o);
                    }
                    value = sb.toString();
                }
                
                // Special Case: CGI role names have underscores instead of 
                // spaces, which make them difficult to display.   
                if ((obj instanceof GeneFunctionAssociation) 
                        && ((String)key).endsWith(".role") || ((String)key).equals("role")) {
                    return value.toString().replaceAll("_", " ");
                }
                
                return (value == null) ? "" : value.toString();
            }
        };
    }

    public Object getObject() {
        return obj;
    }
    
    public String getClassName() {
        return className;
    }
    
    public Object get(Object key) {
        String attributePath = (String)key;

        if ("_className".equals(attributePath)) return className;
        
        if ("_obj".equals(attributePath)) return obj;
        
        if ("_querystr".equals(attributePath)) {
            try {
                Object id = ReflectionUtils.get(obj, "id");
                return "?query="+className+"&"+className+"[@id="+id+"]";
            }
            catch (Exception e) {
                log.error("Error constructing URL",e);
                return "#";
            }
        }
        
        if ("displayMap".equals(attributePath)) {
            return getDisplayMap();
        }

        return resolve(obj, attributePath);
    }
    
    /**
     * Evaluates the specified path on the given object and returns the end 
     * point object in the path, if any. This function is called recursively
     * for each segment of the path.
     * @param object A Java bean with getters.
     * @param path An object path as specified in the class docs.
     * @return The end point object, or null.
     */
    private Object resolve(Object object, String path) {

        if (object == null) return null;
        if (path == null) return object;

        if ("class".equals(path)) {
            String cn = object.getClass().getName();
            return cn.substring(cn.lastIndexOf('.')+1).split("\\$\\$")[0];
        }
        
        int d = path.indexOf('.');
        String attr = (d < 0) ? path : path.substring(0,d);

        String constraint = getConstraint(attr);
        String constrainAttr = null;
        String constrainValue = null;
        int index = -1;
        
        if (constraint != null) {
            try {
                index = Integer.parseInt(constraint);
            }
            catch (NumberFormatException e) {
                String[] cvs = constraint.split("=");
                constrainAttr = cvs[0];
                constrainValue = cvs[1];
            }
            attr = attr.substring(0,attr.indexOf('['));
        }
        
        Object nextObj;
        try {
            nextObj = ReflectionUtils.get(object, attr);
        }
        catch (Exception e) {
            log.error("Attribute error for "+path,e);
            return "ERROR";
        }

        String nextPath = d < 0 ? null : path.substring(d+1);
        if (nextObj instanceof List) {
            List nextList = (List)nextObj;
            
            // just need one element from the list
            if (index >= 0) {
                try {
                    nextObj = nextList.get(index);
                }
                catch (IndexOutOfBoundsException e) {
                    return "";
                }
                return resolve(nextObj, nextPath);
            }

            // aggregate all the resolved elements in the list
            List resolved = new ArrayList();
            for(Object e : nextList) {
                // constrain by an attribute if one was provided
                if (constrainAttr == null 
                        || resolve(e, constrainAttr).equals(constrainValue)) {
                    Object o = resolve(e, nextPath);
                    resolved.add(o);
                }
            }
            return resolved;
        }
        else {
            return resolve(nextObj, nextPath);
        }
    }

    /**
     * Returns all the object classes in the given path starting with the 
     * class of the current object.
     * @param path
     * @return
     */
    public List<Class> getClasses(String path) {

        List<Class> classes = new ArrayList<Class>();
        
        Class prevClass = obj.getClass();
        classes.add(prevClass);

        String[] segments = path.split("\\.");
        for(int i=0; i<segments.length; i++) {
            String segment = segments[i].replaceAll("\\[.*?\\]$","");
            prevClass = ClassUtils.getAssociationType(prevClass, segment);
            
            // What if we're constraining the class to a specific subclass?
            String constraint = getConstraint(segments[i]);
            if (constraint != null) {
                String[] cvs = constraint.split("=");
                if ("class".equals(cvs[0])) {
                    String superclass = prevClass.getName();
                    String packageName = superclass.substring(0,superclass.lastIndexOf('.'));
                    String subclass = cvs[1];
                    // Infer the same package. We can't specify packages with the path syntax.
                    String fqSubclass = packageName+"."+subclass;
                    try {
                        prevClass = Class.forName(fqSubclass);
                    }
                    catch (ClassNotFoundException e) {
                        log.error("Cannot find inferred subclass",e);
                    }
                }
            }
            classes.add(prevClass);
        }
        
        return classes;
    }

    /**
     * Get anything that appears in brackets at the end of the string. For 
     * example, in "gene[id=12]" return "id=12"
     * @param attr
     * @return
     */
    private String getConstraint(String attr) {
        int a = attr.indexOf('[');
        int b = attr.indexOf(']');
        if (a > 0) {
            return attr.substring(a+1,b);
        }
        return null;
    }
    
}