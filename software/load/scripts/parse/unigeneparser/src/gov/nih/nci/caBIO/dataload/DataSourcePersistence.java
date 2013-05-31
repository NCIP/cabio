/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.Enumeration;
import java.util.Hashtable;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class DataSourcePersistence {

	// allows us to have list of current dataSources without going to db
	protected static Hashtable dataSourceList;

	private static Connection conn = null;

	private static long dataSourceCounter = -1;

	public static final long NO_DATA_SOURCE = -1;

	private static DataSourcePersistence onlyInstance = null; // singleton

	private DataSourcePersistence() {
		try {
			if (dataSourceCounter == -1) {
				dataSourceList = new Hashtable();
				conn = CoreConnection.instance();
				Statement stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select data_source_id, data_source_name from data_source order by data_source_id");
				while (rset.next()) {
					dataSourceCounter = rset.getLong(1);
					dataSourceList.put(new Long(dataSourceCounter), rset
							.getString(2));
				}
				rset.close();
				stmt.close();
			}

		} catch (Exception e) {
			System.err.println(e.getMessage() + "getting dataSource list");
		}
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static DataSourcePersistence instance() {
		if (onlyInstance == null) {
			onlyInstance = new DataSourcePersistence();
		}
		return onlyInstance;
	}

	/**
	 * adds an dataSource
	 */
	private long insertDataSource(String dataSourceName) {
		Long dataSourceKey = new Long(NO_DATA_SOURCE);
		try {
			dataSourceCounter++;
			PreparedStatement stmt = conn
					.prepareStatement("insert into data_source(data_source_id, data_source_name) values(?,?)");
			stmt.setLong(1, dataSourceCounter);
			stmt.setString(2, dataSourceName);
			stmt.execute();
			stmt.close();
			dataSourceKey = new Long(dataSourceCounter);
			dataSourceList.put(dataSourceKey, dataSourceName);
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getMessage() + "in saving new dataSource");
		}
		return dataSourceKey.longValue();
	}

	/**
	 * searches the hashtable to find if the dataSource name exists.
	 */
	public long getDataSourceID(String dataSourceName) {

		Long dataSourceKey = new Long(NO_DATA_SOURCE);
		Enumeration keys = dataSourceList.keys();

		while (keys.hasMoreElements()) {
			Long key = (Long) (keys.nextElement());
			if (dataSourceName.equals(dataSourceList.get(key))) {
				dataSourceKey = key;
			}
		}

		return dataSourceKey.longValue();
	}

	/**
	 * searches the hashtable to find if the dataSource key exists.
	 */
	public String getDataSourceName(long dataSourceIn) {

		Long dataSourceKey = new Long(dataSourceIn);
		return dataSourceList.get(dataSourceKey).toString();
	}

	public long addDataSource(DataSource dataSourceToSave) {
		long dataSourceKey = getDataSourceID(dataSourceToSave
				.getDataSourceName());
		if (dataSourceKey == NO_DATA_SOURCE) {
			dataSourceKey = insertDataSource(dataSourceToSave
					.getDataSourceName());
		}
		return dataSourceKey;
	}

}
