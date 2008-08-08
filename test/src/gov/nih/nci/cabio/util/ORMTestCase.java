package gov.nih.nci.cabio.util;

import java.util.Collection;

import org.hibernate.collection.PersistentSet;

import junit.framework.TestCase;

/**
 * Provides additional assertions for testing ORM (SDK/Hibernate-based) systems.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ORMTestCase extends TestCase {

    /**
     * Assert that a given object was preloaded, in other words, it's not
     * just a proxy shell, but a real object. This is useful if you have a 
     * one-to-one or many-to-one association which is eagerly fetched. You can
     * call this like so:
     * <code>
     * assertPreloaded("Gene was not preloaded",obj.getGene())
     * </code>
     * @param msg Assertion message
     * @param obj The object to test
     */
    protected void assertPreloaded(String msg, Object obj) {
        assertNotNull(obj);
        assertFalse(msg, obj.getClass().getName().contains("EnhancerByCGLIB"));
    }
    
    /**
     * Assert that a given collection was preloaded, in other words, it's not
     * just a proxy shell, but a real collection. This is useful if you have a 
     * one-to-many or many-to-many association which is eagerly fetched. You can
     * call this like so:
     * <code>
     * assertPreloaded("Gene collection was not preloaded",obj.getGeneCollection())
     * </code>
     * @param msg Assertion message
     * @param collection The collection to test
     */
    protected void assertPreloaded(String msg, Collection collection) {
        assertNotNull(collection);
        PersistentSet ps = (PersistentSet)collection;
        assertTrue(msg, ps.wasInitialized());
    }
    
}
