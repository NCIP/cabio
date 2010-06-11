package gov.nih.nci.maservice.util;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.Ii;
import gov.nih.nci.iso21090.Cd;

/**
 * @author Jim Sun
 * @version 1.0
 * @created 09-Jun-2010 2:21:46 PM
 */
public class OrganismCriteria {

	private St commonName;
	private Ii ncbiTaxonomyId;
	private St scientificName;
	private Cd taxonomyRank;

	public OrganismCriteria(){

	}

	public St getCommonName() {
		return commonName;
	}

	public void setCommonName(St commonName) {
		this.commonName = commonName;
	}

	public Ii getNcbiTaxonomyId() {
		return ncbiTaxonomyId;
	}

	public void setNcbiTaxonomyId(Ii ncbiTaxonomyId) {
		this.ncbiTaxonomyId = ncbiTaxonomyId;
	}

	public St getScientificName() {
		return scientificName;
	}

	public void setScientificName(St scientificName) {
		this.scientificName = scientificName;
	}

	public Cd getTaxonomyRank() {
		return taxonomyRank;
	}

	public void setTaxonomyRank(Cd taxonomyRank) {
		this.taxonomyRank = taxonomyRank;
	}
}