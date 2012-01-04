/*
 *  The caBIO Software License, Version 1.0
 * 
 *  Copyright 2006 SAIC. This software was developed in conjunction with the 
 *  National Cancer Institute, and so to the extent government employees are 
 *  co-authors, any rights in such works shall be subject to Title 17 of the 
 *  United States Code, section 105.
 *
 *  Redistribution and use in source and binary forms, with or without 
 *  modification, are permitted rovided that the following conditions are met:
 *
 *  1. Redistributions of source code must retain the above copyright notice, 
 *  this list of conditions and the disclaimer of Article 3, below.  
 *  Redistributions in binary form must reproduce the above copyright notice, 
 *  this list of conditions and the following disclaimer in the documentation 
 *  and/or other materials provided with the distribution.
 *
 *  2.  The end-user documentation included with the redistribution, if any, 
 *  must include the following acknowledgment:
 *
 *  "This product includes software developed by the SAIC and the National 
 *  Cancer Institute."
 *
 *  If no such end-user documentation is to be included, this acknowledgment 
 *  shall appear in the software itself, wherever such third-party 
 *  acknowledgments normally appear.
 *
 *  3. The names "The National Cancer Institute", "NCI" and "SAIC" must not be 
 *  used to endorse or promote products derived from this software.
 * 
 *  4. This license does not authorize the incorporation of this software into 
 *  any proprietary programs.  This license does not authorize the recipient to 
 *  use any trademarks owned by either NCI or SAIC-Frederick.
 *
 *  5. THIS SOFTWARE IS PROVIDED "AS IS," AND ANY EXPRESSED OR IMPLIED 
 *  WARRANTIES, (INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
 *  MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE) ARE DISCLAIMED.  IN NO 
 *  EVENT SHALL THE NATIONAL CANCER INSTITUTE, SAIC, OR THEIR AFFILIATES BE 
 *  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
 *  POSSIBILITY OF SUCH DAMAGE.
 */
package gov.nih.nci.grididloader;

import gov.nih.nci.grididloader.HandleInterfaceFactory.HandleInterfaceType;

import java.io.FileWriter;
import java.io.InputStream;
import java.net.URI;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedList;
import java.util.Map;
import java.util.Properties;
import java.util.Queue;
import java.util.Set;
import java.util.concurrent.ExecutionException;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;

import javax.sql.DataSource;

import net.handle.server.HandleRepositoryIDInterface;
import net.handle.server.ResourceIdInfo;
import oracle.jdbc.pool.OracleConnectionPoolDataSource;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.PosixParser;

/**
 * Creates and assigns Big Id's to grid entities. For each entity mapping 
 * defined in the configuration file, up to 50 threads are dispatched to process
 * all its rows. For each row, a Big Id is generated using the ID Service 
 * (which registers the id in another table), and then the Big Id is saved into 
 * the entity in the "BIG_ID" column. 
 */
/**
 * @author caBIO Team
 * @version 1.0
 */
public class BigIdCreator {

    /** Entity mapping */
    private final Config config = new Config();
    
    /** The data source where BigEntity's are stored */
    private final DataSource dataSource; 
    
    /** Factory that is provided to BatchUpdates */
    private final HandleInterfaceFactory hiFactory;
    
    /** Number of threads to use when updating an entity */
    private final int numThreads;
    
    /** Executor for running batch updates in parallel */
    private final ExecutorService parallelExecutor;

    /** Executor for running batch updates in serial */
    private final ExecutorService serialExecutor;
    
    /** Filter what classes to process */
    private Set<String> classFilter = new HashSet<String>();
    
    /** If using a filter, include or exclude the entities in the filter? */
    private boolean include = true;
    
    /**
     * Reads properties from a file called "loader.properties" in the classpath
     * and configures a new BigIdCreator.
     * @throws Exception If loader.properties cannot be found, or a property 
     *         is missing.
     */
	public BigIdCreator() throws Exception {
        
		// Load the configuration files
        final Properties props = new Properties();
        final Properties dbprops = new Properties();
		final InputStream is = Thread.currentThread().getContextClassLoader().
                getResourceAsStream("loader.properties");
        final InputStream dis = Thread.currentThread().getContextClassLoader().
                getResourceAsStream("db.properties");
		try {
            props.load(is);
            dbprops.load(dis);
		} catch (Exception e) {
			throw new Exception("Can't read the properties file. " + 
                    "Make sure loader.properties and db.properties " +
                    "are in the CLASSPATH");
		}
		finally {
        
		}

        // Setup database connection pool
        final OracleConnectionPoolDataSource pool = 
            new OracleConnectionPoolDataSource();
        pool.setURL(dbprops.getProperty("oracleloader.url")); 
        pool.setUser(dbprops.getProperty("oracleloader.user")); 
        pool.setPassword(dbprops.getProperty("oracleloader.password"));
        this.dataSource = pool;
        
        // load entities and mappings
        config.loadXMLMapping(props.getProperty("mapping.file"));

        // setup the handle interface factory
        this.hiFactory = new HandleInterfaceFactory(props, dataSource);
        
        // init the job executor
        this.numThreads = Integer.parseInt(props.getProperty("loader.threads"));
        this.parallelExecutor = Executors.newFixedThreadPool(numThreads);
        this.serialExecutor = Executors.newSingleThreadExecutor();
	}

    /**
     * Same as createAndUpdate(), but only process entities that have class
     * names matching the entries in the specified classFilter array.
     */
    public void createAndUpdate(String[] classFilterArray, boolean include) 
            throws Exception {
        this.include = include;
        this.classFilter.clear();
        if (classFilterArray != null) {
            for(String className : classFilterArray) {
                classFilter.add(className);
            }
        }
        createAndUpdate();
    }
    
    /**
     * Create Big Id's for each entity and save them into the database.
     * Each entity is updated in parallel by several threads, but the entities
     * are processed in a serial fashion.
     */
    public void createAndUpdate() throws Exception {
        
        if (hiFactory.getSystemType() == HandleInterfaceType.CLASSIC) {
            // Create site handle, if the database is empty.
            // This is necessary because otherwise 50 threads will try to create it
            // at once, resulting in duplicates and a subsequent avalanche of collisions
            final HandleRepositoryIDInterface idSvc = 
                (HandleRepositoryIDInterface)hiFactory.getHandleInterface();
            // create dummy id (also creates site handle)
            ResourceIdInfo rid = new ResourceIdInfo(new URI("urn://ncicb"),"dummy");
            idSvc.createOrGetGlobalID(rid);
            // remove the id we created, the site handle will remain
            idSvc.removeGlobalID(rid);
        }
        
        Connection conn = null;
        FileWriter benchmarkFile = null;

        try {
            benchmarkFile = new FileWriter("timings.txt");
            conn = dataSource.getConnection();
            
            for (BigEntity entity : config.getEntities()) {
    
                final String className = entity.getClassName();
                if (!classFilter.isEmpty() &&  
                        ((include && !classFilter.contains(className)) ||
                        (!include && classFilter.contains(className)))) {
                    System.err.println("Filtered out "+className);
                    continue;
                }
                
                long start = System.currentTimeMillis();
                
                final String table = entity.getTableName();
                final String id = entity.getPrimaryKey();
                
                Statement stmt = null;
                ResultSet rs = null;
                long numRows = 0;
                long minId = 0;
                long maxId = 0;
                
                try {
                    // get number of rows and id space for the current entity
                    stmt = conn.createStatement();
                    rs = stmt.executeQuery("SELECT MIN("+id+") minId, MAX("+id+
                            ") maxId, COUNT(*) rowCount FROM "+table);
                    rs.next();
                    numRows = rs.getLong("rowCount");
                    minId = rs.getLong("minId");
                    maxId = rs.getLong("maxId");
                }
                catch (SQLException e) {
                    System.err.println("Error processing "+table);
                    e.printStackTrace();
                    continue;
                }
                finally {
                    try {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                    }
                    catch (SQLException e) {
                        e.printStackTrace();
                    }
                }
                
                /* This is an overly complicated formula to figure out the best 
                 * chunk size possible. 
                 * 
                 * First we determine the idealChunkSize for the amount of rows
                 * we are dealing with, based on a linear step equation:
                 *10000|   ______
                 * 9500|   :
                 *     |  /:
                 *     | / :
                 * 500 |/  :
                 * ____|___:_____
                 *     0   500,000
                 *          
                 * In other words, the minimum chunk is 500. As the number of rows 
                 * increases, the chunk size grows up to 9500. But after 500000 
                 * rows, the chunk size jumps to 10000 and stays constant so that 
                 * we don't overload each thread. Therefore, the chunk size is 
                 * always between 500 and 10000. 
                 * 
                 * Secondly, the identifier spread is calculated and multiplied by 
                 * the idealChunkSize to get the final chunkSize. If the ids are 
                 * equal to the row numbers, the spread is 1 and the chunk size is 
                 * ok. If, however, the id space is gigantic, then the chunk size 
                 * will be increased proportionally to the average distance between
                 * ids (assuming the ids are uniformally distributed).  
                 *  
                 * This actually works perfectly only if the ids ARE uniformally
                 * distributed. In other corner cases, where the ids are clustered
                 * together within a huge id space, the id space must be
                 * partitioned recursively. 
                 */
                final float idealChunkSize = (numRows > 500000) ? 
                        10000 : .018f * numRows + 500;
                final float spread = (float)(maxId - minId + 1) / (float)numRows;
                final long chunkSize = Math.round(idealChunkSize * spread);
                
                System.out.println("Processing "+entity+" ("+entity.getTableName()+
                        ") rows("+numRows+") range("+minId+","+maxId+
                        ") parallel("+entity.isParallelLoadable()+")");
                System.out.println("Parameters: spread("+spread+") chunkSize(ideal="+
                        idealChunkSize+" actual="+chunkSize+")");
                
                final Map<BatchUpdate,Future<Boolean>> futures = 
                    new HashMap<BatchUpdate,Future<Boolean>>();
                final Queue<BatchUpdate> updates = new LinkedList<BatchUpdate>();
                
                // start each chunk as a task on the executor
                for(long i=minId; i<=maxId; i+=chunkSize) {
                    BatchUpdate update = new BatchUpdate(dataSource, hiFactory,
                            entity, i, i+chunkSize-1);
                    updates.add(update);
                    
                    Future<Boolean> future = entity.isParallelLoadable() 
                            ? parallelExecutor.submit(update) 
                            : serialExecutor.submit(update);

                    futures.put(update, future);
                }
                
                // wait for all updates to finish
                while (!updates.isEmpty()) {
                    final BatchUpdate update = updates.remove();
                    final Future<Boolean> future = futures.remove(update);
                    try {
                        // this get() blocks until the future is available
                        Boolean success = future.get();
                        if (success == null || !success.booleanValue()) {
                            System.err.println("FAILED: "+update);
                        }
                        else {
                            int n = update.getNumUpdated();
                            if (n == 0) {
                                System.out.println("  done "+update+" (no rows found)");
                            }
                            else {
                                int ut = (int)update.getAverageUpdateTime();
                                int ht = (int)update.getAverageHandleTime();
                                System.out.println("  done "+update+" rows("+n+
                                        " rows) avg(handle="+ht+"ms, update="+
                                        ut+"ms)");
                            }
                        }
                    }
                    catch (ExecutionException e) {
                        System.err.println("Updated failed for entity: "+entity);
                        e.printStackTrace();
                    }
                    catch (InterruptedException e) {
                        System.err.println("Updated failed for entity: "+entity);
                        e.printStackTrace();
                    }
                }
    
                float time = System.currentTimeMillis() - start;
                System.out.println("Done "+entity+" ("+(time/1000)+" sec)\n");
                benchmarkFile.write(entity.getClassName()+"\t"+numRows+"\t"+time+"\n");
                benchmarkFile.flush();
            }

        }
        finally {
            try {
                if (conn != null) conn.close();
                if (benchmarkFile != null) benchmarkFile.close();
            }
            catch (SQLException e) {
                e.printStackTrace();
            }
        }
        
        
        // Done 
        parallelExecutor.shutdown();
        serialExecutor.shutdown();
    }
    
    /**
     * Debug method to print all SQL that will be used to query the entities
     * for unique keys.
     */
    public void printSQL() {
        for (BigEntity entity : config.getEntities()) {
            StringBuffer sql = new StringBuffer("SELECT ");
            sql.append(entity.getSelectSQL());
            sql.append("\n FROM ");
            sql.append(entity.getFromSQL());
            sql.append("\n WHERE 1=1");
            if (!entity.getJoins().isEmpty()) {
                sql.append("\n AND ");
                sql.append(entity.getWhereSQL());
            }
            System.out.println(entity.getClassName()+"\n"+sql+"\n");
        }
    }
    
    public static void argError() {
        System.err.println("Error: Include and exclude are mutually " +
                "exclusive parameters.");
        System.exit(1);
    }
    
	/**
     * Main program.
     * Two mutually exclusive command line options are possible:
     * -I include the following entities
     * -E exclude the following entities
     * The entities are passed as a space delimited list like:
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
            if (include != null) argError();
            isInclude = false;
            classFilter = exclude;
        }
        
        long start = System.currentTimeMillis();
        BigIdCreator loader = new BigIdCreator();
        loader.createAndUpdate(classFilter, isInclude);
        //loader.printSQL();
        long stop = System.currentTimeMillis();
        System.err.println("All updates took "+(float)(stop-start)/60000+" min.");
	}
}
