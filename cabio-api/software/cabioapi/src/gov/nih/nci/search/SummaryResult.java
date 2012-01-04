package gov.nih.nci.search;

import java.io.Serializable;

/**
 * A count of FreestyleLM results of a given class type. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class SummaryResult implements Serializable {

    private static final long serialVersionUID = 1234567890L;

    private String className;
    private Integer hits = new Integer(0);
    private String id; // necessary for REST API
    
    public String getClassName() {
        return className;
    }
    
    public void setClassName(String className) {
        this.className = className;
    }
    
    public Integer getHits() {
        return hits;
    }
    
    public void setHits(Integer hits) {
        this.hits = hits;
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }
}
