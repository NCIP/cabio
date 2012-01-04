package gov.nih.nci.caBIO.dataload;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;

import oracle.jdbc.driver.OraclePreparedStatement;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class MapPersistence {

	private static Connection conn = null;

	private static long mapCounter = -1;

	private static MapPersistence onlyInstance = null; // singleton

	private static PreparedStatement mstmt;

	private MapPersistence() {
		try {
			if (mapCounter == -1) {
				conn = CoreConnection.instance();
				mstmt = conn
						.prepareStatement("insert into map(map_id, map_location, map_type) values(?,?,?)");
				((OraclePreparedStatement) mstmt).setExecuteBatch(100);
			}
			Statement stmt = conn.createStatement();
			ResultSet rset = stmt.executeQuery("select max(map_id) from map");
			rset.next();
			mapCounter = rset.getLong(1);
			rset.close();
			stmt.close();

		} catch (Exception e) {
			System.err.println(e.getMessage() + "getting map list");
		}
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static MapPersistence instance() {
		if (onlyInstance == null) {
			onlyInstance = new MapPersistence();
		}
		return onlyInstance;
	}

	private long insertMap(Map mapToSave) {
		try {
			mapCounter++;
			mstmt.setLong(1, mapCounter);
			mstmt.setString(2, mapToSave.getMapLocation());
			mstmt.setString(3, mapToSave.getMapType());
			mstmt.execute();
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getMessage() + "in saving new Map");
		}
		return mapCounter;
	}

	public long addMap(Map mapToSave) {
		mapToSave.setMapID(insertMap(mapToSave));
		return mapCounter;
	}
}