package gov.nih.nci.system.util.indexgen;

import java.text.SimpleDateFormat;
import java.util.Collection;
import java.util.Date;
import java.util.Iterator;
import java.util.Map;

import org.apache.log4j.Logger;
import org.apache.lucene.document.Document;
import org.apache.lucene.document.Field;
import org.hibernate.search.bridge.FieldBridge;
import org.hibernate.search.bridge.StringBridge;

/**
 * Translates an Object to a String when generating Lucene Indices. 
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 */
public class ObjectBridge implements FieldBridge, StringBridge {
   private static final Logger log = Logger.getLogger(ObjectBridge.class);
   
   public ObjectBridge(){
       super();       
   }
   public String objectToString(Object object) {
        //This code will currently convert Collections and Map types
        StringBuilder valueList = new StringBuilder();
        if(object instanceof Collection){
            for(Iterator i = ((Collection)object).iterator(); i.hasNext();){
                Object value = i.next();
                if(value instanceof Date){
                   valueList.append(getDateString((Date)object));
                }else{
                    valueList.append(value);
                }
                valueList.append("; ");

            }
        }else if(object instanceof Map){
            for(Iterator i = ((Map)object).keySet().iterator(); i.hasNext();){
                String key = (String)i.next();
                Object value = ((Map)object).get(key);
                valueList.append(key +":"+ value +"; ");
            }
        }else if(object instanceof Date){
            valueList.append(getDateString((Date)object));
        }        
        return valueList.toString();
    }

   public Object stringToObject(String strValue){
       return (Object)strValue;
   }
   
    private String getDateString(Date date){
        SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy");
        return sdf.format(date);
    }
    
    public void set(String name, Object value, Document document, Field.Store store, Field.Index index, Float boost){
        String strValue = objectToString(value);        
        Field field = new Field(name, strValue , store, index);
        document.add(field);
    }
        
    


}
