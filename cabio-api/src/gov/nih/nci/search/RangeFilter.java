package gov.nih.nci.search;

import java.io.Serializable;

/**
 * 
 * 
 * @author Shaziya Muhsin
 */
public class RangeFilter  implements Serializable  {

    private static final long serialVersionUID = 1234567890L;
    private String fieldName;
    private String startRange;
    private String endRange;
    
    public RangeFilter() {      
    }
    
    public RangeFilter(String fieldName, String startRange, String endRange) {
        this.fieldName = fieldName;
        this.startRange = startRange;
        this.endRange = endRange;
    }

    public void setFieldName(String name){
        fieldName = name;
    } 
    
    public String getFieldName(){
        return fieldName;
    }
    
    public void setStartRange(String start){
        startRange = start;
    }
    
    public String getStartRange(){
        return startRange;
    }
    
    public void setEndRange(String end){
        endRange = end;
    }
    
    public String getEndRange(){
        return endRange;
    }
}
