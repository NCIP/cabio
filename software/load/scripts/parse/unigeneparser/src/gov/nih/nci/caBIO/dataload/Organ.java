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
public class Organ {

	protected String organName;

	protected long organID;

	public Organ() {
	}

	public void setOrganName(String organNameIn) {
		organName = organNameIn.toLowerCase();
	}

	public void setOrganID(long organIDIn) {
		organID = organIDIn;
	}

	public String getOrganName() {
		return organName.toLowerCase();
	}

	public long getOrganID() {
		return organID;
	}

	// looks up organ id by the current name
	public long getOrganIDByName() {
		OrganPersistence currentOrgan = OrganPersistence.instance();
		organID = currentOrgan.getOrganID(organName.toLowerCase());
		return organID;
	}

	public void addOrgan() {
		OrganPersistence saveOrgan = OrganPersistence.instance();
		setOrganID(saveOrgan.addOrgan(this));
	}
}