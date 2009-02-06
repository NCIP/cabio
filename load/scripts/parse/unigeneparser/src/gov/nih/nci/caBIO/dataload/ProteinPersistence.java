package gov.nih.nci.caBIO.dataload;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ListIterator;
import java.util.Vector;

import oracle.jdbc.driver.OraclePreparedStatement;

/**
 * The Protein Persistence is responsible for handling database handling of the
 * protein objects.
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class ProteinPersistence {

	private static PreparedStatement pstmt;

	private static PreparedStatement hpstmt;

	private static Connection conn;

	private static long proteinCounter = -1;

	private static long proteinDBID = -1;

	private static ProteinPersistence onlyInstance = null; // singleton

	private ProteinPersistence() {
		try {
			if (proteinCounter == -1) {
				conn = CoreConnection.instance();
				Statement stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select max(protein_id) from protein");
				rset.next();
				proteinCounter = rset.getLong(1);
				rset.close();
				stmt.close();
				pstmt = conn
						.prepareStatement("INSERT INTO PROTEIN(PROTEIN_ID, PROTEIN_INFO_ID, GENE_INFO_ID, TAXON_ID) VALUES (?,?,?,?)");
				((OraclePreparedStatement) pstmt).setExecuteBatch(100);
				hpstmt = conn
						.prepareStatement("INSERT INTO PROTEIN_HOMOLOGUE(PROTEIN_ID, RELATED_PROTEIN, PERCENT_ALIGNMENT, ALIGN_LENGTH) VALUES (?,?,?,?)");
				((OraclePreparedStatement) pstmt).setExecuteBatch(100);
			}
		} catch (Exception e) {
			System.err.println(e.getMessage() + " initializing protein ");
		}
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static ProteinPersistence instance() {
		if (onlyInstance == null) {
			onlyInstance = new ProteinPersistence();
		}
		return onlyInstance;
	}

	public long getProteinByNumber(long proteinNumber) {
		try {

			Statement stmt = conn.createStatement();
			ResultSet rset = stmt
					.executeQuery("select protein_id from protein where PROTEIN_INFO_ID = "
							+ proteinNumber);
			if (rset.next()) {
				proteinDBID = rset.getLong(1);
			} else {
				proteinDBID = -1;
			}
			rset.close();
			stmt.close();
		} catch (Exception e) {
			System.err.println(e.getMessage() + "protein lookup failed");
		}
		return proteinDBID;
	}

	public long addProtein(Protein proteinToSave) {
		long currentID;
		Taxon taxonToSave;
		Vector homologousProteins = new Vector();
		HomologousProtein homologousProtein;
		currentID = getProteinByNumber(proteinToSave.getProteinNumber());
		try {

			if (currentID < 0) {
				proteinCounter++;
				currentID = proteinCounter;
				pstmt.setLong(1, currentID);
				pstmt.setLong(2, proteinToSave.getProteinNumber());
				pstmt.setString(3, proteinToSave.getGeneInfoID());
				taxonToSave = proteinToSave.getTaxon();
				taxonToSave.addTaxon();
				pstmt.setLong(4, taxonToSave.getTaxonID());
				pstmt.execute();
			}
			homologousProteins = proteinToSave.getHomologousProteins();
			ListIterator protList = homologousProteins.listIterator();
			while (protList.hasNext()) {
				homologousProtein = (HomologousProtein) protList.next();
				hpstmt.setLong(1, currentID);
				long hnum = homologousProtein.addProtein();
				hpstmt.setLong(2, hnum);
				hpstmt.setLong(3, homologousProtein.getAlignmentPercent());
				hpstmt.setLong(4, homologousProtein.getAlignmentAmount());
				hpstmt.execute();
			}
		} catch (Exception e) {
			System.err.println(e.getMessage() + "protein save failed");
		}
		return currentID;
	}

}