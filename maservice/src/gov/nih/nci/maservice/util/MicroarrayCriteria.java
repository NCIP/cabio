package gov.nih.nci.maservice.util;
import gov.nih.nci.iso21090.Ts;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.Ii;
import gov.nih.nci.iso21090.Cd;

/**
 * @author Jim Sun
 * @version 1.0
 * @created 09-Jun-2010 2:21:44 PM
 */
public class MicroarrayCriteria {

	private Ts annotationDate;
	private St annotationVersion;
	private St dbSNPVersion;
	private St description;
	private St genomeVersion;
	private Ii LSID;
	private St manufacturer;
	private St name;
	private Cd type;

	public MicroarrayCriteria(){

	}

	public void finalize() throws Throwable {

	}

	public Ts getAnnotationDate() {
		return annotationDate;
	}

	public void setAnnotationDate(Ts annotationDate) {
		this.annotationDate = annotationDate;
	}

	public St getAnnotationVersion() {
		return annotationVersion;
	}

	public void setAnnotationVersion(St annotationVersion) {
		this.annotationVersion = annotationVersion;
	}

	public St getDbSNPVersion() {
		return dbSNPVersion;
	}

	public void setDbSNPVersion(St dbSNPVersion) {
		this.dbSNPVersion = dbSNPVersion;
	}

	public St getDescription() {
		return description;
	}

	public void setDescription(St description) {
		this.description = description;
	}

	public St getGenomeVersion() {
		return genomeVersion;
	}

	public void setGenomeVersion(St genomeVersion) {
		this.genomeVersion = genomeVersion;
	}

	public Ii getLSID() {
		return LSID;
	}

	public void setLSID(Ii lsid) {
		LSID = lsid;
	}

	public St getManufacturer() {
		return manufacturer;
	}

	public void setManufacturer(St manufacturer) {
		this.manufacturer = manufacturer;
	}

	public St getName() {
		return name;
	}

	public void setName(St name) {
		this.name = name;
	}

	public Cd getType() {
		return type;
	}

	public void setType(Cd type) {
		this.type = type;
	}

}