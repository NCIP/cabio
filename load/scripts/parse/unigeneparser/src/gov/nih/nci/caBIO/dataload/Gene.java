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
 * @author CORE Team
 * @version 1.0
 */
public class Gene {

	protected String title = "";

	 private String hugoAlias = "";
	protected long geneDBID = -1;

	protected String symbol = "";

	
    protected String startCytoband = "";
	
    protected String endCytoband = "";
	protected String cytoband = "";

	protected String numberOfSequences;

	protected Hashtable databaseLinks;

	protected Hashtable dataSources;

	protected Hashtable sequences;

	protected Hashtable mapLocations;

	protected Vector expressedTissues;

	protected Vector markerdatabaseLinks;
   
	protected Vector alias;

	protected Vector homologues;

	protected Chromosome chromosome;

	protected Protein protein;

	protected Taxon taxon;

	protected String filePath;

	public Gene(String filePath) {
		databaseLinks = new Hashtable();
		sequences = new Hashtable();
		dataSources = new Hashtable();
		mapLocations = new Hashtable();
		expressedTissues = new Vector();
		alias = new Vector();
                markerdatabaseLinks = new Vector(); 
		this.filePath = filePath;
	}

	public void setGeneDBID(long geneDBIDIn) {
		geneDBID = geneDBIDIn;
	}

	public void setTitle(String titleIn) {
		title = titleIn;
	}

	public void setSymbol(String symbolIn) {
		symbol = symbolIn;
	}

    public void setCytoband(String cytobandIn) {
        cytoband = cytobandIn;
    }
    public void setstartCytoband(String cytobandIn) {
	startCytoband = cytobandIn;
    }
    public void setendCytoband(String cytobandIn) {
		endCytoband = cytobandIn;
    }
	public void setDatabaseLinks(Hashtable databaseLinksIn) {
		databaseLinks = databaseLinksIn;
	}
	public void setMarkerDatabaseLinks(Vector markerLinksIn) {
		markerdatabaseLinks = markerLinksIn;
	}

	public void setDataSources(Hashtable dataSourcesIn) {
		dataSources = dataSourcesIn;
	}

	public void setMapLocations(Hashtable mapLocationsIn) {
		mapLocations = mapLocationsIn;
	}

	public void setSequences(Hashtable sequencesIn) {
		sequences = sequencesIn;
	}

	public void setExpressedTissues(Vector expressedTissuesIn) {
		expressedTissues = expressedTissuesIn;
	}

	public void setAlias(Vector aliasIn) {
		alias = aliasIn;
	}

	public void setHomologues(Vector homologuesIn) {
		homologues = homologuesIn;
	}

	public void setChromosome(Chromosome chromosomeIn) {
		chromosome = chromosomeIn;
	}

	public void setProtein(Protein proteinIn) {
		protein = proteinIn;
	}

	public void setTaxon(Taxon taxonIn) {
		taxon = taxonIn;
	}

	public long getGeneDBID() {
		return geneDBID;
	}

	public String getTitle() {
		return title;
	}

	public String getSymbol() {
		return symbol;
	}

    public String getCytoband() {
        return cytoband;
    }
    public String getStartCytoband() {
		return startCytoband;
	}
    public String getEndCytoband() {
		return endCytoband;
	}

	public Hashtable getDatabaseLinks() {
//		if (databaseLinks.isEmpty()) {
//			GenePersistence getGene = GenePersistence.instance(filePath);
//			getGene.getGeneDatabaseLinks(this);
		//}
		return databaseLinks;
	}
	public void setHugoAlias (String hAlias) {
		hugoAlias = hAlias;
	}

	public String getHugoAlias () {
		
		return hugoAlias;
		 
	}
	public Vector getmarkerDatabaseLinks() {
		return markerdatabaseLinks;
	} 

	public Hashtable getDataSources() {
		return dataSources;
	}

	public Hashtable getMapLocations() {
		return mapLocations;
	}

	public Hashtable getSequences() {
		return sequences;
	}

	public Vector getExpressedTissues() {
		return expressedTissues;
	}

	public Vector getAlias() {
		return alias;
	}

	public Vector getHomologues() {
		return homologues;
	}

	public Chromosome getChromosome() {
		return chromosome;
	}

	public Protein getProtein() {
		return protein;
	}

	public Taxon getTaxon() {
		return taxon;
	}

	public void deleteDatabaseLinks() {
		databaseLinks.clear();
	}

	public void deleteMarkerDatabaseLinks() {
		markerdatabaseLinks.clear();
	}

	public void deleteSequences() {
		databaseLinks.clear();
	}

	public void addGeneSequences() {
		GenePersistence saveGene = GenePersistence.instance(filePath);
		saveGene.addGeneSequences(this, true, "");
	}

	public void updateGeneDatabaseLinks() {
		GenePersistence saveGene = GenePersistence.instance(filePath);
		String tmp = "";
		String tax = "";
		saveGene.addGeneDatabaseLinks(this, true, tmp, tax);
		saveGene.addMarkerDatabaseLinks(this, true, tmp, tax);
	}

	public void addGene() {
		GenePersistence saveGene = GenePersistence.instance(filePath);
		saveGene.addGene(this);
	}
}
