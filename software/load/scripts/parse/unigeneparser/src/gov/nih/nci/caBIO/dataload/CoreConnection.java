/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class CoreConnection {

	private static Connection onlyInstance = null;

	private CoreConnection() {
	}

	public static Connection instance() {
		if (onlyInstance == null) {
			try {
				DriverManager
						.registerDriver(new oracle.jdbc.driver.OracleDriver());
				onlyInstance = DriverManager
						.getConnection(
								System
										.getProperty("gov.nih.nci.caBIO.dataload.connectString"),
								System
										.getProperty("gov.nih.nci.caBIO.dataload.user"),
								System
										.getProperty("gov.nih.nci.caBIO.dataload.password"));
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return onlyInstance;
	}
}
