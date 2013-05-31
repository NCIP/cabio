/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

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
     * if the association is null it will be treated as NOT preloaded. To avoid 
     * this, the caller should first assert that the association it not null
     * by calling the method directly, like this:
     * assertNotNull(gene.getTaxon());
     * @param obj The domain object (a Hibernate proxy) 
     * @param roleName The role name of the association to be tested
     * @throws AssertionFailedError
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
                String n = association.getClass().getName();
                assertFalse(roleName+" is not preloaded", 
                    n.contains("CGLIB"));
            }
        }
    }
}
