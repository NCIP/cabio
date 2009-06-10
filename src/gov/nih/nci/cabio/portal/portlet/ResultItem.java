package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.common.util.ReflectionUtils;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Allows for dynamic JSTL bracket access to result item properties.
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
 * except that it formats results for screen display.
 * </ul>
 */
public class ResultItem extends GetOnlyMap {

    private static Log log = LogFactory.getLog(ResultItem.class);
    
    private String className;
    private Object obj;
    
    public ResultItem(String className, Object obj) {
        this.className = className;
        this.obj = obj;
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
            return new GetOnlyMap() {
                public Object get(Object key) {
                    return breakLongLines(ResultItem.this.get(key).toString());
                }
            };
        }

        return resolve(obj, attributePath);
    }
    
    private Object resolve(Object object, String path) {

        if (object == null) return "";
        
        int d = path.indexOf('.');
        String attr = (d < 0) ? path : path.substring(0,d);

        int a = attr.indexOf('[');
        int b = attr.indexOf(']');
        int index = -1;
        if (a > 0) {
            index = Integer.parseInt(attr.substring(a+1,b));
            attr = attr.substring(0,a);
        }
        
        Object nextObj;
        try {
            nextObj = ReflectionUtils.get(object, attr);
        }
        catch (Exception e) {
            log.error("Attribute error for "+path,e);
            return "ERROR";
        }

        if (d < 0) {
            // this is the target attribute
            return nextObj;
        }
        else {
            String nextPath = path.substring(d+1);
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
                
                // aggregate all the elements in the list
                StringBuffer buf = new StringBuffer();
                int c = 0;
                for(Object e : (List)nextObj) {
                    if (c++ > 0) buf.append(", ");
                    buf.append(resolve(e, nextPath));
                }
                return buf.toString();
            }
            else {
                return resolve(nextObj, nextPath);
            }
        }
    }
    
    /**
     * Just a little utility function to add spaces when there are very long 
     * character strings, so that they don't break the layout. Pathway names
     * from Reactome are a good example.
     * @param value
     * @return
     */
    private String breakLongLines(String value) {

        StringBuffer sb = new StringBuffer();
        int charsSinceWhitespace = 0;
        for(int i=0; i<value.length(); i++) {

            char c = value.charAt(i);
            if (Character.isWhitespace(c)) {
                charsSinceWhitespace = 0;
            }
            else {
                charsSinceWhitespace++;
            }
            
            if (charsSinceWhitespace > 50) {
                charsSinceWhitespace = 0;
                sb.append(" ");
            }
            sb.append(c);
        }

        return sb.toString();
    }
    
}