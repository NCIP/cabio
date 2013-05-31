/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.indexgen;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Map;
import java.util.Set;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;
import org.hibernate.SessionFactory;
import org.hibernate.cfg.AnnotationConfiguration;
import org.hibernate.persister.entity.EntityPersister;
import org.hibernate.search.Search;
import org.hibernate.search.annotations.Indexed;

/**
 * Generates Lucene indexes for domain objects with the @Indexed annotation.
 * Class inclusion/exclusion can be controlled on the command line. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 * @author <a href="mailto:muhsins@mail.nih.gov">Shaziya Muhsin</a>
 */
public class IndexGenerator {

    private final boolean include;
    private final ExecutorService pool;
    private final SessionFactory sessionFactory;

    /** Filter what classes to process */
    private Set<String> classFilter = new HashSet<String>();
    
    public IndexGenerator(String ormFileName, int threadCount, 
            String[] classFilterArray, boolean include) {
        
        this.include = include;
        this.pool = Executors.newFixedThreadPool(threadCount);
        this.sessionFactory = new AnnotationConfiguration().configure(
            ormFileName).buildSessionFactory();
        
        if (classFilterArray != null) {
            this.classFilter.addAll(Arrays.asList(classFilterArray));
        }
    }
    
    public void generate() throws Exception { 
    
        Set<EntityPersister> classSet = getIndexedClasses();
        
        if (classSet.isEmpty()) {
            throw new Exception("No classes with @Indexed annotation found.");
        }

        for (EntityPersister persister : classSet) {
            String name = persister.getEntityName();
            name = name.substring(name.lastIndexOf('.')+1);
            if (classFilter.isEmpty() || (include == classFilter.contains(name))) {
                long count = getCount(persister);
                System.out.println(persister.getEntityName() + ": "+count+" records found");
                pool.execute(new Indexer(sessionFactory.openSession(), persister));
            }
        }
    }
    
    /**
     * Returns the set of classes (EntityPersisters) with the Indexed annotation.
     */
    public Set<EntityPersister> getIndexedClasses() throws Exception {
        
        Map metadata = sessionFactory.getAllClassMetadata();
        Set<EntityPersister> classSet = new HashSet<EntityPersister>();
        for (Iterator i = metadata.values().iterator(); i.hasNext();) {
            EntityPersister persister = (EntityPersister) i.next();
            Class clazz = Class.forName(persister.getEntityName());
            if (clazz.isAnnotationPresent(Indexed.class)) {
                classSet.add(persister);
            }
        }
        return classSet;
    }

    private long getCount(EntityPersister persister) throws Exception {
        
        String countQuery = "select count(*) from " + persister.getEntityName();
        long count = (Long)Search.createFullTextSession(
            sessionFactory.openSession()).iterate(countQuery).next();
        return count;
    }

    public void close() {
        if (pool != null) pool.shutdown();
    }

    public static void argError() {
        System.err.println("Error: include and exclude are " +
                "mutually exclusive parameters.");
        System.exit(1);
    }
    
    /**
     * Main program.
     * Two mutually exclusive command line options are possible:
     * -I include the following classes
     * -E exclude the following classes
     * The classes are passed as a space delimited list like:
     * -I Taxon Cytoband
     * @param args
     */
    public static void main(String[] args) throws Exception {

        String[] classFilter = null;
        boolean isInclude = true;

        Options options = new Options();
        options.addOption(OptionBuilder.withLongOpt( "include" )
                        .withDescription( "classes to include" )
                        .hasOptionalArgs()
                        .create("I"));

        options.addOption(OptionBuilder.withLongOpt( "exclude" )
                        .withDescription( "classes to exclude" )
                        .hasOptionalArgs()
                        .create("E"));

        CommandLineParser parser = new PosixParser();
        CommandLine cmd = parser.parse( options, args);
        String[] include = cmd.getOptionValues("I");
        String[] exclude = cmd.getOptionValues("E");
        
        if (include != null) {
            if (exclude != null) argError();
            isInclude = true;
            classFilter = include;
        }
        else if (exclude != null) {
            isInclude = false;
            classFilter = exclude;
        }
        
        SearchAPIProperties properties = SearchAPIProperties.getInstance();
        String ormFileName = properties.getOrmFileName();;
        int threadCount = properties.getThreadCount() > 0 ? 
                properties.getThreadCount() : 1;
        
        IndexGenerator indexgen = null;
        try {
            indexgen = new IndexGenerator(ormFileName, 
                threadCount, classFilter, isInclude);
            indexgen.generate();
        }
        finally {
            if (indexgen != null) indexgen.close();
        }
    }
}
