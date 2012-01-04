package gov.nih.nci.caBIO.dataload;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Map;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class TaxonPersistence {

	private Map<Long, Taxon> taxonById = new HashMap<Long, Taxon>();

	private Map<String, Taxon> taxonByName = new HashMap<String, Taxon>();

	private Map<String, Taxon> taxonByStrain = new HashMap<String, Taxon>();

	private static Connection conn = null;

	private static long taxonCounter = -1;

	private static TaxonPersistence onlyInstance = null; // singleton

	public static final long NO_TAXON = -1;

	private TaxonPersistence() {
		try {
			if (taxonCounter == -1) {
				conn = CoreConnection.instance();
				Statement stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select taxon_id, SCIENTIFIC_NAME, STRAIN_OR_ETHNICITY from taxon order by taxon_id");
				String stringBuff;
				while (rset.next()) {
					taxonCounter = rset.getLong(1);
					Taxon currentTaxon = new Taxon();
					currentTaxon.setTaxonID(taxonCounter);
					stringBuff = rset.getString(2);
					if (stringBuff == null)
						stringBuff = "";
					currentTaxon.setScientificName(stringBuff);
					stringBuff = rset.getString(3);
					if (stringBuff == null)
						stringBuff = "";
					if (stringBuff != "") {
						currentTaxon.setEthnicityOrStrain(stringBuff);
					}
					registerTaxon(currentTaxon);
				}
				rset.close();
				stmt.close();
			}

		} catch (Exception e) {
			System.err.println(e.getMessage() + "getting taxon list");
		}
	}

	/**
	 * Register the given taxon with all the internal maps.
	 * 
	 * @param taxon
	 */
	private void registerTaxon(Taxon taxon) {

		final Long id = new Long(taxon.getTaxonID());
		final String name = taxon.getScientificName();
		final String strain = taxon.getEthnicityOrStrain();

		taxonById.put(id, taxon);
		if (!taxonByName.containsKey(name)) {
			taxonByName.put(name, taxon);
		}
		if (!taxonByStrain.containsKey(strain) && (strain != "")) {
			taxonByStrain.put(strain, taxon);
		}
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static TaxonPersistence instance() {
		if (onlyInstance == null) {
			onlyInstance = new TaxonPersistence();
		}
		return onlyInstance;
	}

	private long insertTaxon(Taxon taxonToSave) {
		Taxon currentTaxon = null;
		try {
			taxonCounter++;
			PreparedStatement stmt = conn
					.prepareStatement("insert into taxon(taxon_id, SCIENTIFIC_NAME, STRAIN_OR_ETHNICITY) values(?,?,?)");
			stmt.setLong(1, taxonCounter);
			stmt.setString(2, taxonToSave.getScientificName());
			stmt.setString(3, taxonToSave.getEthnicityOrStrain());
			stmt.execute();
			stmt.close();
			currentTaxon = new Taxon();
			currentTaxon.setScientificName(taxonToSave.getScientificName());
			// System.out.println("TaxonId here is " +
			// taxonToSave.getTaxonID());
			currentTaxon.setEthnicityOrStrain(taxonToSave
					.getEthnicityOrStrain());
			// System.out.println("TaxonId here is **" +
			// taxonToSave.getTaxonID());
			registerTaxon(currentTaxon);
			return currentTaxon.getTaxonID();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return -1;
	}

	public Taxon getTaxon(long taxonID) {
		return taxonById.get(new Long(taxonID));
	}

	/**
	 * searches the hashtable to find if the taxon key.
	 */
	public long getTaxonID(Taxon taxonToFind) {

		final String name = taxonToFind.getScientificName();
		final String strain = taxonToFind.getEthnicityOrStrain();

		Taxon foundTaxon = null;

		if (taxonByName.containsKey(name)) {
			// System.out.println("Getting taxon Id by name");
			foundTaxon = taxonByName.get(name);
			// System.out.println(" In this by name Taxon Id of " +
			// foundTaxon.getTaxonID());
		}
		if (taxonByStrain.containsKey(strain)) {
			// System.out.println("Getting taxon Id by strain or ethnicity");
			foundTaxon = taxonByStrain.get(strain);
			// System.out.println(" In this by strain Taxon Id of " +
			// foundTaxon.getTaxonID());
		}

		if (foundTaxon == null) {
			return new Long(NO_TAXON);
		}
		// System.out.println(" Returning Taxon Id of " +
		// foundTaxon.getTaxonID());
		return foundTaxon.getTaxonID();
	}

	public long addTaxon(Taxon taxonToSave) {
		long taxonKey = getTaxonID(taxonToSave);
		if (taxonKey == NO_TAXON) {
			taxonKey = insertTaxon(taxonToSave);
		}
		return taxonKey;
	}
}
