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
import java.util.HashMap;
import java.util.Map;

/**
 * Writes chromosomes to the output file.
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class ChromosomePersistence {

	private Map<String, Chromosome> chromosomeMap = new HashMap<String, Chromosome>();

	private static Connection conn = null;

	private static long chromosomeCounter = -1;

	private static ChromosomePersistence onlyInstance = null; // singleton

	public static final long NO_CHROMOSOME = -1;

	private ChromosomePersistence() {
		try {
			if (chromosomeCounter == -1) {
				conn = CoreConnection.instance();
				Statement stmt = conn.createStatement();
				ResultSet rset = stmt
						.executeQuery("select chromosome_id, taxon_id, chromosome_number from chromosome order by chromosome_id");
				while (rset.next()) {
					chromosomeCounter = rset.getLong(1);
					Chromosome currentChromosome = new Chromosome();
					long taxonId = rset.getLong(2);
					Taxon currentTaxon = new Taxon(taxonId);
					currentChromosome.setChromosomeID(chromosomeCounter);
					currentChromosome.setTaxon(currentTaxon);
					currentChromosome.setChromosomeNumber(rset.getString(3));
					registerChromosome(currentChromosome);
				}
				rset.close();
				stmt.close();
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void registerChromosome(Chromosome chromosome) {
		String key = chromosome.getChromosomeNumber() + "~"
				+ chromosome.getTaxon().getTaxonID();
		chromosomeMap.put(key, chromosome);
	}

	/**
	 * Static factory method that makes a single instance of this class.
	 */
	public static ChromosomePersistence instance() {
		if (onlyInstance == null) {
			onlyInstance = new ChromosomePersistence();
		}
		return onlyInstance;
	}

	private long insertChromosome(Chromosome chromosomeToSave) {
		long chromosomeId = -1;
		try {
			chromosomeCounter++;
			PreparedStatement stmt = conn
					.prepareStatement("insert into chromosome(chromosome_id, taxon_id, chromosome_number) values(?,?,?)");
			stmt.setLong(1, chromosomeCounter);
			Taxon chromosomeTaxon = chromosomeToSave.getTaxon();
			stmt.setLong(2, chromosomeTaxon.getTaxonID());
			stmt.setString(3, chromosomeToSave.getChromosomeNumber());
			stmt.execute();
			stmt.close();
			Chromosome currentChromosome = new Chromosome();
			currentChromosome.setTaxon(chromosomeToSave.getTaxon());
			currentChromosome.setChromosomeID(chromosomeCounter);
			currentChromosome.setChromosomeNumber(chromosomeToSave
					.getChromosomeNumber());
			registerChromosome(currentChromosome);
			chromosomeId = chromosomeCounter;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return chromosomeId;
	}

	/**
	 * searches the hashtable to find if the organ key.
	 */
	public long getChromosomeID(Chromosome chromosomeToFind) {

		Taxon toFindTaxon = chromosomeToFind.getTaxon();
		/** Check to make sure taxon exists */
		if (toFindTaxon.getTaxonID() == -1) {
			toFindTaxon.addTaxon();
		}
		// System.out.println("Finding Chromosome ID for " +
		// chromosomeToFind.getChromosomeNumber() + " and Taxon Id " +
		// toFindTaxon.getTaxonID());
		String key = chromosomeToFind.getChromosomeNumber() + "~"
				+ toFindTaxon.getTaxonID();

		if (chromosomeMap.containsKey(key)) {
			Chromosome chromosome = chromosomeMap.get(key);
			// System.out.println("Finding Chromosome ID for " +
			// chromosomeToFind.getChromosomeNumber() + " and Taxon Id " +
			// toFindTaxon.getTaxonID() + " returned value is " +
			// chromosome.getChromosomeID() );
			return chromosome.getChromosomeID();
		}

		return NO_CHROMOSOME;
	}

	public long addChromosome(Chromosome chromosomeToSave) {
		long chromosomeKey = getChromosomeID(chromosomeToSave);
		if (chromosomeKey == NO_CHROMOSOME) {
			chromosomeKey = insertChromosome(chromosomeToSave);
		}
		// System.out.println(" Adding chromosome Id as " + chromosomeKey );
		chromosomeToSave.setChromosomeID(chromosomeKey);
		return chromosomeKey;
	}
}
