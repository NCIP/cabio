package gov.nih.nci.cabio.portal.portlet;

import java.util.Collection;

public class CollectionHolder {

    Collection list;
    
    public CollectionHolder(Collection list) {
        this.list = list;
    }
    
    public Collection getList() {
        return list;
    }
}
