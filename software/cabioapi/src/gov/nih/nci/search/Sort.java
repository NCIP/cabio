package gov.nih.nci.search;

import java.io.Serializable;

/**
 * @author Shaziya Muhsin
 */
public class Sort  implements Serializable {
    private static final long serialVersionUID = 1234567890L;
    private Boolean sortByClassName = false;
    private Boolean ascOrder = true;
    public void setSortByClassName(Boolean ascOrder) {
        this.sortByClassName = ascOrder;
    }    
    public Boolean getSortByClassName(){
        return sortByClassName;
    }
    public void setAscOrder(Boolean asc){
        ascOrder = asc;
    }
    public Boolean getAscOrder(){
        return ascOrder;
    }
    
}
