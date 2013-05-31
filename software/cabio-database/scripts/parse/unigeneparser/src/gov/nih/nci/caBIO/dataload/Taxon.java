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
public class Taxon {

	protected String scientificName = "";

	protected String commonName = "";

	protected String abbreviation = "";

	protected String ethnicityOrStrain = "";

	protected long taxonID;

	public Taxon() {
		taxonID = -1;
	}

	public Taxon(long taxonIDToGet) {
		Taxon foundTaxon;
		TaxonPersistence currentTaxon = TaxonPersistence.instance();
		foundTaxon = currentTaxon.getTaxon(taxonIDToGet);
		if (foundTaxon == null) {
			System.err.println("Could not find taxon: " + taxonIDToGet);
		} else {
			this.scientificName = foundTaxon.getScientificName();
			this.ethnicityOrStrain = foundTaxon.getEthnicityOrStrain();
			this.taxonID = foundTaxon.getTaxonID();
			this.commonName = foundTaxon.getCommonName();
			this.abbreviation = foundTaxon.getAbbreviation();
		}
	}

	public void setScientificName(String scientificNameIn) {
		scientificName = scientificNameIn;
	}

	public void setCommonName(String commonNameIn) {
		commonName = commonNameIn;
	}

	public void setAbbreviation(String abbreviationIn) {
		abbreviation = abbreviationIn;
	}

	public void setEthnicityOrStrain(String ethnicityOrStrainIn) {
		ethnicityOrStrain = ethnicityOrStrainIn;
	}

	public void setTaxonID(long taxonIDIn) {
		taxonID = taxonIDIn;
	}

	public String getScientificName() {
		return scientificName;
	}

	public String getCommonName() {
		return commonName;
	}

	public String getAbbreviation() {
		return abbreviation;
	}

	public String getEthnicityOrStrain() {
		return ethnicityOrStrain;
	}

	public long getTaxonID() {
		return taxonID;
	}

	// looks up taxon id by the current name
	public long getTaxonIDByNameAndSpecies() {
		TaxonPersistence currentTaxon = TaxonPersistence.instance();
		taxonID = currentTaxon.getTaxonID(this);
		return taxonID;
	}

	public void addTaxon() {

		TaxonPersistence saveTaxon = TaxonPersistence.instance();
		taxonID = saveTaxon.addTaxon(this);

	}
}