/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.util;

import java.util.Iterator;
import java.util.List;

/**
 * A list iterator which just returns the list once. This is kind of silly, 
 * but it makes my life easier when writing benchmarking tests.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class OnceIterator implements Iterator<List> {
    
    private final List list;
    private boolean done;

    public OnceIterator(List list) {
        this.list = list;
    }
    
    public boolean hasNext() {
        return !done;
    }

    public List next() {
        this.done = true;
        return list;
    }

    public void remove() {
        throw new UnsupportedOperationException();
    }
}