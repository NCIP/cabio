package gov.nih.nci.search;

import java.io.Serializable;
import java.util.Map;

/**
 * @author Shaziya Muhsin
 */
public class SearchResult implements Serializable {

    private static final long serialVersionUID = 1234567890L;

    private String className;
    private Integer hit;
    private String keyword;
    private Map properties;
    private String displayText;
    private String id;

    public String getClassName() {
        return className;
    }

    public void setClassName(String className) {
        this.className = className;
    }

    public Integer getHit() {
        return hit;
    }

    public void setHit(Integer hit) {
        this.hit = hit;
    }

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }

    public Map getProperties() {
        return properties;
    }

    public void setProperties(Map properties) {
        this.properties = properties;
    }

    public String getDisplayText() {
        return displayText;
    }

    public void setDisplayText(String displayText) {
        this.displayText = displayText;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getId() {
        return id;
    }

    public int hashCode() {
        int h = 0;
        if (getHit() != null) h += getHit().hashCode();
        return h;
    }

}
