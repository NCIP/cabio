/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.grididloader;

import gov.nih.nci.grididloader.BigEntity.Join;
import gov.nih.nci.grididloader.HandleInterfaceFactory.HandleInterfaceType;

import java.net.URI;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Collection;
import java.util.List;
import java.util.concurrent.Callable;

import javax.sql.DataSource;

import net.handle.server.HandleRepositoryIDInterface;
import net.handle.server.IDSvcInterface;
import net.handle.server.IDSvcInterfaceFactory;
import net.handle.server.ResourceIdInfo;
import oracle.jdbc.driver.OracleConnection;
import oracle.jdbc.driver.OraclePreparedStatement;

/**
 * This is a batch update of a specific BigEntity. It only updates a subset of
 * the rows in the entity's table, as specified when this class is constructed.
 * When actually called it queries the entity table to get the unique key for 
 * each target row, then proceeds to create a Big Id based on the unique key 
 * and save it in the entity row. 
 */
/**
 * @author caBIO Team
 * @version 1.0
 */
public class BatchUpdate implements Callable<Boolean> {

    private static final String BIG_ID_DELIMITER = "|";
    
    private final DataSource dataSource;
    private final HandleInterfaceFactory hiFactory;
    private final BigEntity entity;
    private final long startId;
    private final long endId;
    private int updateTimeSum;
    private int handleTimeSum;
    private int numTotalUpdates;
    private int rowsUpdated;

    /**
     * Create an callable that updates the specified entity in the rows 
     * specified. If startRow or endRow is -1 then that constraint is not 
     * applied.
     * @param entity
     * @param startRow
     * @param endRow
     */
    public BatchUpdate(DataSource dataSource, HandleInterfaceFactory hiFactory, 
            BigEntity entity, long startId, long endId) {
        this.dataSource = dataSource;
        this.hiFactory = hiFactory;
        this.entity = entity;
        this.startId = startId;
        this.endId = endId;
    }

    /**
     * Callable callback method called when this update is actually run.
     */
    public Boolean call() throws Exception {

        final String table = entity.getTableName();
        final String id = entity.getPrimaryKey();
        final String qualifiedId = table+"."+id;
        final String idAlias = entity.getPrimaryKeyAlias();
        final Collection<Join> joins = entity.getJoins();
        
        System.out.println("  starting "+this);
        
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        PreparedStatement updateStmt = null;
        IDSvcInterface idSvc = null;
        
        try {
            conn = dataSource.getConnection();
            ((OracleConnection)conn).setDefaultExecuteBatch(200);
            conn.setAutoCommit(false);
            
            // get appropriate handle interface
            idSvc = hiFactory.getHandleInterface();
            
            // build SQL query for this chunk
            StringBuffer sql = new StringBuffer("SELECT ");
            sql.append(entity.getTableName());
            sql.append(".BIG_ID BIG_ID, ");
            sql.append(entity.getSelectSQL());
            sql.append("\n FROM ");
            sql.append(entity.getFromSQL());
            
            sql.append("\n WHERE ");
            sql.append(qualifiedId);
            sql.append(" >= ?");
            sql.append(" AND ");
            sql.append(qualifiedId);
            sql.append(" <= ?");
            
            if (!joins.isEmpty()) {
                sql.append("\n AND ");
                sql.append(entity.getWhereSQL());
            }
            
            // TODO: remove this debug code
            //String printSql = sql.toString();
            //printSql = printSql.replaceFirst("\\?", ""+startId);
            //printSql = printSql.replaceFirst("\\?", ""+endId);
            //System.err.println("sql: "+printSql);
            
            stmt = conn.prepareStatement(sql.toString());
            stmt.setLong(1, startId);
            stmt.setLong(2, endId);
            
            // prepare to update the database
            final String sqlUpdate = 
                "UPDATE " + table + 
                " SET BIG_ID = ? WHERE " + id + " = ?";
            updateStmt = conn.prepareStatement(sqlUpdate);

            // begin a transaction with the handle service
            if (idSvc instanceof HandleRepositoryIDInterface) {
                ((HandleRepositoryIDInterface)idSvc).beginTransaction();
            }

            rs = stmt.executeQuery();
            rs.setFetchSize(200);
            while (rs.next()) {

                final long idValue = rs.getLong(idAlias);
                final String currBigId = rs.getString("BIG_ID");
                
                // get logical key values
                final StringBuffer uniqueValues = new StringBuffer();
                final List<String> uniqueKey = entity.getUniqueKeyAliases();

                for (String field : uniqueKey) {
                    if (uniqueValues.length() > 0) uniqueValues.append(" ");
                    uniqueValues.append(rs.getString(field));
                }
                
                //System.err.println(uniqueValues);
                
                try {
                    long start = System.currentTimeMillis();
                    
                    // create Big id
                    ResourceIdInfo rid = new ResourceIdInfo(new URI("urn://ncicb"), 
                            entity.getQualifiedClassName() + BIG_ID_DELIMITER + 
                            uniqueValues);

                    URI bigid = idSvc.createOrGetGlobalID(rid);

                    handleTimeSum += System.currentTimeMillis() - start;
                    
                    if (bigid == null) {
                        System.err.println("Possible hash Collision for "+
                                entity.getClassName()+
                                ". Make sure that the logical key ("+
                                rid.resourceIdentification+") is unique.");
                    }
                    else {
                        start = System.currentTimeMillis();
                        if (bigid.toString().equals(currBigId)) {
                            rowsUpdated++; // pretend we updated
                            numTotalUpdates++;
                        }
                        else {
                            // update Big id
                            updateStmt.setObject(1, bigid.toString());
                            updateStmt.setLong(2, idValue);
                            rowsUpdated += ((OraclePreparedStatement)updateStmt).executeUpdate();
                            numTotalUpdates++;
                        }
                        
                        updateTimeSum += System.currentTimeMillis() - start;
                    }
                }
                catch (Exception e) {
                    e.printStackTrace();
                }
            }

            // end database transaction
            rowsUpdated += ((OraclePreparedStatement) updateStmt).sendBatch();
            conn.commit();

            // end handle service transaction
            if (idSvc instanceof HandleRepositoryIDInterface) {
                ((HandleRepositoryIDInterface)idSvc).commitTransaction();
            }

            if (numTotalUpdates > rowsUpdated) {
                System.err.println("Update failed, only "+
                        rowsUpdated+"/"+numTotalUpdates+" updated for "+this);
            }
        }
        catch (SQLException e) {
            e.printStackTrace();
            return Boolean.FALSE;
        }
        finally {
            try {
                if (idSvc != null) {
                        ((HandleRepositoryIDInterface)idSvc).shutdown();
                }
                if (rs!=null) rs.close();
                if (stmt!=null) stmt.close();
                if (updateStmt!=null) updateStmt.close();
                if (conn!=null) conn.close();
            }
            catch (SQLException e) {
                // log but ignore
                e.printStackTrace();
            }
        }
        
        return Boolean.TRUE;
    }

    /**
     * Returns the entity this BatchUpdate is reponsible for updating.
     * @return the Big-managed entity 
     */
    public BigEntity getEntity() {
        return entity;
    }
    
    /** 
     * Returns the average time (ms) updating a row.
     * @return
     */
    public float getAverageUpdateTime() {
        return (float)updateTimeSum / (float)numTotalUpdates;
    }

    /** 
     * Returns the average time (ms) spend creating a handle, per row.
     * @return
     */
    public float getAverageHandleTime() {
        return (float)handleTimeSum / (float)numTotalUpdates;
    }
    
    /**
     * Returns the total number of rows that were processed.
     * @return
     */
    public int getNumUpdated() {
        return numTotalUpdates;
    }

    @Override
    public String toString() {
        return "ChunkUpdate<"+entity+",ids("+startId+","+endId+")>";
    }
    
    /**
     * Test Harness.
     */
    public static void main(String[] args) throws Exception {

        //rs12123003 1 Homo sapiens null 
        //rs12025523 1 Homo sapiens null 
        //rs12025524 1 Homo sapiens null 
        //rs17019253 1 Homo sapiens null 
        //rs17019256 1 Homo sapiens null 
        //rs12756983 1 Homo sapiens null 
        
        final HandleRepositoryIDInterface idSvc = (HandleRepositoryIDInterface)
            IDSvcInterfaceFactory.getInterface(
            ".");
        
        final String className = "gov.nih.nci.cabio.domain.SNP";
        final String uniqueValues = "rs12123002 1 Homo sapiens null ";
        
        // create Big id
        ResourceIdInfo rid = new ResourceIdInfo(new URI("urn://ncicb"), 
                className + BIG_ID_DELIMITER + uniqueValues);
        URI bigid = idSvc.createOrGetGlobalID(rid);

        if (bigid == null) {
            System.err.println("Hash Collision for "+className+
                    ". Make sure that the logical key ("+
                    uniqueValues+") is unique.");
        }
    }
}