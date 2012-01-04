package gov.nih.nci.caBIO.dataload;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.Writer;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

/**
 * Writes unique clones to the clone output file.
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class ClonePersistence {

	final private static String TERMINATOR = "%|";

	private static Writer out, out_ct;

	private static long cloneCounter = -1;

	private Map<Long, Long> libIdMap = new HashMap<Long, Long>();

	private static Connection conn = null;

	private static ClonePersistence onlyInstance = null; // singleton

	/**
	 * History of all the unique clones we've seen since the last time
	 * clearHistory() was called. Keyed by "cloneName~LibraryId" and mapping to
	 * the CloneDBId.
	 */
	private Map<String, Long> clones = new HashMap<String, Long>();

	/* Private no-args constructor */
	private ClonePersistence(String filePath) {
		try {
			if (cloneCounter == -1) {
				cloneCounter = 1;
				File cloneFile = new File(filePath, "clone.dat");
				File cloneTaxonFile = new File(filePath, "clonetaxon.dat");
				out = new BufferedWriter(new FileWriter(cloneFile));
				out_ct = new BufferedWriter(new FileWriter(cloneTaxonFile));
				conn = CoreConnection.instance();
				Statement stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select trim(Unigene_ID), trim(Library_ID) from LIBRARY");
				while (rset.next()) {
					Long unigeneId = rset.getLong(1);
					Long libId = rset.getLong(2);
					// System.out.println("Unigene Id " + unigeneId + "libId " +
					// libId);
					libIdMap.put(unigeneId, libId);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static ClonePersistence instance(String filePath) {
		if (onlyInstance == null) {
			onlyInstance = new ClonePersistence(filePath);
		}
		return onlyInstance;
	}

	/**
	 * Clears the history of clones processed by this singleton.
	 */
	public void clearHistory() {
		clones.clear();
	}

	/**
	 * Flush and close the output files.
	 */
	public void cleanup() {
		try {
			out.flush();
			out_ct.flush();
			out.close();
			out_ct.close();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * Writes the specified clone to the output data file. If the clone/library
	 * combination has already been seen, nothing is written to the datafile and
	 * a new Clone is returned containing the CloneDBID of the earlier clone.
	 * Otherwise, the same Clone is returned, with its CloneDBID populated with
	 * a new id.
	 * 
	 * @param cloneToSave
	 * @param taxonName
	 * @return Clone containing the CloneDBID of the clone that was saved
	 */
	public Clone addClone(Clone cloneToSave, String taxonName) {
		if (cloneToSave.cloneID != null) {
			if (cloneToSave.getCloneDBID() == -1) {
				cloneCounter++;
				try {

					final int taxon = (taxonName.equals("Homo sapiens")) ? 5
							: 6;
					final String cloneName = cloneToSave.getCloneID();
					final long UnigeneLibraryId = cloneToSave.getLibraryID();
					final String cloneType = cloneToSave.getCloneType();

					StringBuffer keyBuf = new StringBuffer();
					keyBuf.append(cloneName);
					keyBuf.append("~");
					keyBuf.append(UnigeneLibraryId);

					// check if the clone was already processed
					final String key = keyBuf.toString();
					if (clones.containsKey(key)) {
						Clone clone = new Clone(-1);
						Long dbid = clones.get(key);
						clone.setCloneDBID(dbid.longValue());
						return clone;
					}

					// new clone, save it in the history map
					clones.put(key, new Long(cloneCounter));

					StringBuffer buf = new StringBuffer();
					StringBuffer ctbuf = new StringBuffer();
					buf.append(taxon);
					buf.append(TERMINATOR);
					buf.append(cloneCounter);
					buf.append(TERMINATOR);
					buf.append(cloneName);
					buf.append(TERMINATOR);
					buf.append(UnigeneLibraryId);
					buf.append(TERMINATOR);
					if (cloneType != null) {
						buf.append(cloneType);
						buf.append(TERMINATOR);
					} else {
						buf.append("");
						buf.append(TERMINATOR);
					}
					// System.out.println("Unigene Lib Id is " +
					// UnigeneLibraryId + "Size of libid map is " +
					// libIdMap.size());
					if (libIdMap.containsKey(UnigeneLibraryId)) {
						// System.out.println("Key val is " +
						// libIdMap.get(UnigeneLibraryId) );
						buf.append((Long) libIdMap.get(UnigeneLibraryId));
						buf.append(TERMINATOR);

						ctbuf.append(cloneCounter);
						ctbuf.append(TERMINATOR);
						ctbuf.append(taxon);
						ctbuf.append(TERMINATOR);
						ctbuf.append("\n");
						out_ct.write(ctbuf.toString());
					} else {
						buf.append("");
						buf.append(TERMINATOR);
					}
					buf.append("\n");

					out.write(buf.toString());
					cloneToSave.setCloneDBID(cloneCounter);

				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}
		return cloneToSave;
	}
}
