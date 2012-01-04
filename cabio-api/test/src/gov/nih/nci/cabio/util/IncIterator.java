package gov.nih.nci.cabio.util;

import java.util.Iterator;
import java.util.List;

/**
 * A list iterator which takes increasingly large sublists of the given list.
 * For example, with an input list of 12 elements and an inc of 5, the 
 * following lists would be returned:
 * <ol>
 * <li>First 5 elements
 * <li>First 10 elements
 * <li>All 12 elements
 * </ol>
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class IncIterator implements Iterator<List> {

    private static final int DEFAULT_INCREMENT = 100;
    
    private final List list;
    private final int inc;
    private int i = 0;

    public IncIterator(List list) {
        this.inc = DEFAULT_INCREMENT;
        this.list = list;
    }
    
    public IncIterator(List list, int inc) {
        this.list = list;
        this.inc = inc;
    }
    
    public boolean hasNext() {
        return i < ((list.size()-1) / inc);
    }

    public List next() {
        i++;
        int size = inc*i;
        if (size > list.size()-1) size = list.size()-1;
        return list.subList(0, size);
    }

    public void remove() {
        throw new UnsupportedOperationException();
    }
}