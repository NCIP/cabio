/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio;

import gov.nih.nci.common.util.ReflectionUtils;
import junit.framework.TestCase;

/**
 * Tests the ReflectionUtils class.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ReflectionUtilsTest extends TestCase {

    private ReflectionUtils ru = new ReflectionUtils();
    
    public void testFieldReflection() throws Exception {
        
        Test obj = new Test();
        ru.setFieldValue(obj, "testInt", new Integer(5));
        Object value = ru.getFieldValue(obj, "testInt");
        
        assertEquals(5, value);
    }

    public void testMethodReflection() throws Exception {
                
        Test obj = new Test();
        ru.set(obj, "testString", "TESTING");
        Object value = ru.getFieldValue(obj, "testString");
        
        assertEquals("TESTING", value);
    }
    
    public class Test {
        
        private int testInt;
        private String testString;
        
        public String getTestString() {
            return testString;
        }
        
        public void setTestString(String testString) {
            this.testString = testString;
        }
        
    }
    
}