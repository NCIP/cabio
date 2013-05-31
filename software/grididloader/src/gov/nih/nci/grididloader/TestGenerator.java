/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.grididloader;

import java.io.FileWriter;
import java.io.InputStream;
import java.util.Properties;

/**
 * Generates test cases for each object supporting a Grid Id.
 * 
 * @author caBIO Team
 * @version 1.0
 */
public class TestGenerator {

    /** Entity mapping */
    private final Config config = new Config();
    
	public TestGenerator() throws Exception {
        
		// Load the configuration files
        final Properties props = new Properties();
		final InputStream is = Thread.currentThread().getContextClassLoader().
                getResourceAsStream("loader.properties");
		try {
            props.load(is);
		} catch (Exception e) {
			throw new Exception("Can't read the properties file. " + 
                    "Make sure loader.properties is in the CLASSPATH");
		}
		finally {
        
		}
        
        // load entities and mappings
        config.loadXMLMapping(props.getProperty("mapping.file"));
	}

    public void generate() throws Exception {
        
        FileWriter out = null;

        try {
            out = new FileWriter("GridIdTest.java");
            
            out.write("package gov.nih.nci.cabio;\n\n");
            out.write("import gov.nih.nci.cabio.domain.*;\n\n");
            out.write("public class GridIdTest extends GridIdTestBase {\n\n");
            
            for (BigEntity entity : config.getEntities()) {
                final String className = entity.getClassName();
                out.write("    public void test"+className+"() throws Exception {\n");
                out.write("        testGridId(new "+className+"());\n");
                out.write("    }\n\n");
            }
            
            out.write("}\n");

        }
        finally {
            if (out != null) out.close();
        }
    }
    
	public static void main(String[] args) throws Exception {
        TestGenerator gen = new TestGenerator();
        gen.generate();
	}
}
