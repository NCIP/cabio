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
public abstract class GetOnlyMap<T> implements Map<String,T> {

    public abstract T get(Object key);
    
    public boolean containsKey(Object key) {
        return true;
    }

    public void clear() {
        throw new UnsupportedOperationException();
    }
    
    public boolean containsValue(Object value) {
        throw new UnsupportedOperationException();
    }

    public Set<Entry<String, T>> entrySet() {
        throw new UnsupportedOperationException();
    }
    
    public boolean isEmpty() {
        throw new UnsupportedOperationException();
    }

    public Set<String> keySet() {
        throw new UnsupportedOperationException();
    }

    public T put(String key, Object value) {
        throw new UnsupportedOperationException();
    }

    public void putAll(Map<? extends String, ? extends T> t) {
        throw new UnsupportedOperationException();
    }

    public T remove(Object key) {
        throw new UnsupportedOperationException();
    }
    
    public int size() {
        throw new UnsupportedOperationException();
    }

    public Collection<T> values() {
        throw new UnsupportedOperationException();
    }
    
}
