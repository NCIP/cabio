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
public class OrganPersistence {

	// allows us to have list of current organs without going to db
	protected static Hashtable organList;

	private static Connection conn = null;

	private static long organCounter = -1;

	public static final long NO_ORGAN = -1;

	private static OrganPersistence onlyInstance = null; // singleton

	private OrganPersistence() {
		try {
			if (organCounter == -1) {
				organList = new Hashtable();
				conn = CoreConnection.instance();
				Statement stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select organ_id, description from Organ order by organ_id");
				while (rset.next()) {
					organCounter = rset.getLong(1);
					organList.put(new Long(organCounter), rset.getString(2));
				}
				rset.close();
				stmt.close();
			}

		} catch (Exception e) {
			System.err.println(e.getMessage() + "getting organ list");
		}
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static OrganPersistence instance() {
		if (onlyInstance == null) {
			onlyInstance = new OrganPersistence();
		}
		return onlyInstance;
	}

	/**
	 * adds an organ
	 */
	private long insertOrgan(String organName) {
		Long organKey = new Long(NO_ORGAN);
		try {
			organCounter++;
			PreparedStatement stmt = conn
					.prepareStatement("insert into organ(organ_id, description) values(?,?)");
			stmt.setLong(1, organCounter);
			stmt.setString(2, organName);
			stmt.execute();
			stmt.close();
			organKey = new Long(organCounter);
			organList.put(organKey, organName);
		} catch (Exception e) {
			e.printStackTrace();
			System.err.println(e.getMessage() + "in saving new Organ");
		}
		return organKey.longValue();
	}

	/**
	 * searches the hashtable to find if the organ key exists.
	 */
	public long getOrganID(String organName) {

		Long organKey = new Long(NO_ORGAN);
		Enumeration keys = organList.keys();

		while (keys.hasMoreElements()) {
			Long key = (Long) (keys.nextElement());
			if (organName.equals(organList.get(key))) {
				organKey = key;
			}
		}

		return organKey.longValue();
	}

	public long addOrgan(Organ organToSave) {
		long organKey = getOrganID(organToSave.getOrganName());
		if (organKey == NO_ORGAN) {
			organKey = insertOrgan(organToSave.getOrganName());
		}
		return organKey;
	}

}