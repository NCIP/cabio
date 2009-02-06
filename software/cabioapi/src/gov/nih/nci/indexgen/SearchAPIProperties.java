package gov.nih.nci.indexgen;

import java.io.InputStream;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Properties;
import java.util.Set;
import java.util.StringTokenizer;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;

/**
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 */
public class SearchAPIProperties {

    private static final Logger log = Logger.getLogger(SearchAPIProperties.class);

    private static SearchAPIProperties properties;

    private static String ormFileName;

    private static String[] indexedFields;

    private static SessionFactory sessionFactory;

    private static int threadCount;

    private static HashMap indexProperties;
    
    private static String indexLocation;

    private SearchAPIProperties() {
    }

    public static SearchAPIProperties getInstance() {
        try {
            if (properties == null) {
                synchronized (SearchAPIProperties.class) {
                    if (properties == null) {
                        properties = new SearchAPIProperties();
                    }
                }
                loadProperties("searchapiconfig.properties");
                configureSession();
            }
        }
        catch (Exception e) {
            log.error("Unable to initialize Search API Properties : "
                    + e.getMessage(), e);
        }

        return properties;
    }

    private static void loadProperties(String propertiesFileName)
            throws Exception {

        InputStream is = null;
        Properties properties = new Properties();

        try {
            is = Thread.currentThread().getContextClassLoader().getResourceAsStream(
                propertiesFileName);
            properties.load(is);

            for (Iterator it = properties.keySet().iterator(); it.hasNext();) {
                String key = (String) it.next();
                String value = properties.getProperty(key);

                if (key.equalsIgnoreCase("orm_files")) {
                    if (value.indexOf(";") > 0) {
                        ormFileName = value.substring(0, value.indexOf(";"));
                    }
                    else {
                        ormFileName = value;
                    }
                }
                else if (key.equalsIgnoreCase("indexed_fields")) {
                    populateFields(value);
                }
                else if (key.equalsIgnoreCase("thread_count")) {
                    if (!(value == null || value.equals("0"))) {
                        threadCount = Integer.valueOf(value).intValue();
                    }
                    else {
                        threadCount = 1;
                    }
                }
                else if (key.equalsIgnoreCase("index_location")) {
                    indexLocation = value;
                }
            }
            log.info("loaded properties from "+propertiesFileName);
        }
        catch (Exception ex) {
            throw new Exception(ex.getMessage());
        }
        finally {
            is.close();
        }
    }

    private static void populateFields(String indexedPropertyFiles)
            throws Exception {
        Set fieldList = new HashSet();
        if (indexedPropertyFiles.indexOf(";") > 0) {
            for (StringTokenizer st = new StringTokenizer(indexedPropertyFiles,
                    ";"); st.hasMoreTokens();) {
                String fieldsPropertiesFile = st.nextToken();
                if (fieldsPropertiesFile != null) {
                    fieldList = getFieldNames(fieldsPropertiesFile);
                }
            }
        }
        else {
            fieldList = getFieldNames(indexedPropertyFiles);
        }

        if (fieldList.size() > 0) {
            int counter = 0;
            indexedFields = new String[fieldList.size()];
            for (Iterator it = fieldList.iterator(); it.hasNext();) {
                indexedFields[counter] = (String) it.next();
                counter++;
            }
        }

    }

    private static Set getFieldNames(String fileName) throws Exception {
        indexProperties = new HashMap();
        Set fieldList = new HashSet();
        Properties properties = new Properties();
        InputStream is = null;
        try {
            is = Thread.currentThread().getContextClassLoader().getResourceAsStream(
                fileName);
            properties.load(is);

            for (Iterator it = properties.keySet().iterator(); it.hasNext();) {
                String key = (String) it.next();
                String fields = properties.getProperty(key);
                for (StringTokenizer st = new StringTokenizer(fields, ";"); st.hasMoreTokens();) {
                    fieldList.add(st.nextToken());
                }
                indexProperties.put(key, fields);
            }
        }
        catch (Exception e) {
            log.error(e);
        }
        finally {
            is.close();
        }
        return fieldList;
    }

    private static void configureSession() throws Exception {
        if (ormFileName != null) {
            try {
                sessionFactory = new AnnotationConfiguration().configure(
                    ormFileName).buildSessionFactory();
            }
            catch (Exception ex) {
                throw new Exception("Error initializing session factory: "
                        + ormFileName + ex.getMessage(), ex);
            }
        }
        else {
            throw new Exception("ORM file not found");
        }
    }

    public static Session getSession() {
        return sessionFactory.openSession();
    }

    public String[] getIndexedFields() {
        return indexedFields;
    }

    public String getOrmFileName() {
        return ormFileName;
    }

    public int getThreadCount() {
        return threadCount;
    }

    public HashMap getIndexProperties() {
        return indexProperties;
    }

    public String getIndexLocation() {
        return indexLocation;
    }
}
