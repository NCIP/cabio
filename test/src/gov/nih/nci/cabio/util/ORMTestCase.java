package gov.nih.nci.cabio.util;


import gov.nih.nci.common.util.ReflectionUtils;
import junit.framework.TestCase;

import org.hibernate.collection.PersistentCollection;

/**
 * Provides additional assertions for testing ORM (SDK/Hibernate-based) systems.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ORMTestCase extends TestCase {

    /**
     * Assert that the specified association was preloaded, in other words, 
     * it's not just a proxy shell, but a real object or collection, with the
     * data locally available. You can call this like so:
     * <code>
     * assertPreloaded(gene,"geneCollection")
     * assertPreloaded(gene,"taxon")
     * </code>
     * @param obj The domain object (a Hibernate proxy) 
     * @param roleName The role name of the association to be tested
     */
    protected void assertPreloaded(Object obj, String roleName) throws Exception {
        Object orig = ReflectionUtils.upwrap(obj);
        Object association = ReflectionUtils.get(orig, roleName);
        if (roleName != null) {
            if (association instanceof PersistentCollection) {
                PersistentCollection ps = (PersistentCollection)association;
                assertTrue(roleName+" is not preloaded", ps.wasInitialized());
            }
            else { 
                assertFalse(roleName+" is not preloaded", 
                    association.getClass().getName().contains("CGLIB"));
            }
        }
    }
}
