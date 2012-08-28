package gov.nih.nci.cabio.dataload;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * 
 * @author caCORE Team, modified by Sue Pan
 * @version 1.0
 */
public class DataConnection {

	private static Connection onlyInstance = null;

	private DataConnection() {
	}

	public static Connection instance(String dbURL, String dbUser,
			String dbPassword) {
		if (onlyInstance == null) {
			try {
				DriverManager
						.registerDriver(new oracle.jdbc.driver.OracleDriver());
				onlyInstance = DriverManager.getConnection(dbURL, dbUser,
						dbPassword);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return onlyInstance;
	}
}
