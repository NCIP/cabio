package gov.nih.nci.cabio.portal.portlet;

import java.util.Collection;
import java.util.Map;
import java.util.Set;

/**
 * A map which only supports the get() method, for use with JSTL's expression
 * syntax. The containsKey method will always return true, for efficiency. The
 * rest of the methods will throw an UnsupportedOperationException.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public abstract class GetOnlyMap implements Map<String,Object> {

    public abstract Object get(Object key);
    
    public boolean containsKey(Object key) {
        return true;
    }

    public void clear() {
        throw new UnsupportedOperationException();
    }
    
    public boolean containsValue(Object value) {
        throw new UnsupportedOperationException();
    }

    public Set<Entry<String, Object>> entrySet() {
        throw new UnsupportedOperationException();
    }
    
    public boolean isEmpty() {
        throw new UnsupportedOperationException();
    }

    public Set<String> keySet() {
        throw new UnsupportedOperationException();
    }

    public Object put(String key, Object value) {
        throw new UnsupportedOperationException();
    }

    public void putAll(Map<? extends String, ? extends Object> t) {
        throw new UnsupportedOperationException();
    }

    public Object remove(Object key) {
        throw new UnsupportedOperationException();
    }
    
    public int size() {
        throw new UnsupportedOperationException();
    }

    public Collection<Object> values() {
        throw new UnsupportedOperationException();
    }
    
}
