/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class Chromosome {

	protected Taxon taxon;

	protected String chromosomeNumber;

	protected long chromosomeID;

	public Chromosome() {
		chromosomeID = -1;
		taxon = new Taxon();
	}

	public void setTaxon(Taxon taxonIn) {
		taxon = taxonIn;
	}

	public void setChromosomeNumber(String chromosomeNumberIn) {
		chromosomeNumber = chromosomeNumberIn;
	}

	public void setChromosomeID(long chromosomeIDIn) {
		chromosomeID = chromosomeIDIn;
	}

	public Taxon getTaxon() {
		return taxon;
	}

	public String getChromosomeNumber() {
		return chromosomeNumber;
	}

	public long getChromosomeID() {
		return chromosomeID;
	}

	/**
	 * Looks up chromosome id by the current number and species
	 */
	public long getChromosomeIDByNumberAndTaxon() {
		ChromosomePersistence currentChromosome = ChromosomePersistence
				.instance();
		chromosomeID = currentChromosome.getChromosomeID(this);
		// System.out.println("Chromosome Id is " + chromosomeID);
		return chromosomeID;
	}

	public long addChromosome() {
		ChromosomePersistence saveChromosome = ChromosomePersistence.instance();
		return saveChromosome.addChromosome(this);
	}
}
