/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIO.dataload;

import java.util.Hashtable;
import java.util.Vector;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class Protein {

	protected long proteinNumber;

	protected String geneInfoID;

	protected Vector homologousProteins;

	protected long proteinDBID;

	protected Taxon taxon;

	protected Hashtable databaseLinks;

	public Protein() {
		databaseLinks = new Hashtable();
		homologousProteins = new Vector();
		taxon = new Taxon();
	}

	public void setGeneInfoID(String geneInfoIDIn) {
		geneInfoID = geneInfoIDIn;
	}

	public void setProteinNumber(long proteinNumberIn) {
		proteinNumber = proteinNumberIn;
	}

	public void setProteinDBID(long proteinDBIDIn) {
		proteinDBID = proteinDBIDIn;
	}

	public void setHomologousProteins(Vector homologousProteinsIn) {
		homologousProteins = homologousProteinsIn;
	}

	public void setTaxon(Taxon taxonIn) {
		taxon = taxonIn;
	}

	public void setdatabaseLinks(Hashtable databaseLinksIn) {
		databaseLinks = databaseLinksIn;
	}

	public String getGeneInfoID() {
		return geneInfoID;
	}

	public long getProteinNumber() {
		return proteinNumber;
	}

	public long getProteinDBID() {
		return proteinDBID;
	}

	public Vector getHomologousProteins() {
		return homologousProteins;
	}

	public Hashtable getDatabaseLinks() {
		return databaseLinks;
	}

	public Taxon getTaxon() {
		return taxon;
	}

	public long addProtein() {
		try {
			ProteinPersistence saveProtein = ProteinPersistence.instance();
			proteinDBID = saveProtein.addProtein(this);

		} catch (Exception e) {
			System.err.println(e.getMessage());
		}
		return proteinDBID;
	}

}