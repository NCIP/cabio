package gov.nih.nci.caBIO.dataload;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class Clone {

	protected long cloneDBID;

	protected String cloneID;

	protected long libraryID;

	protected String filePath;

	// holds clone relative location type. it will be either 5' or 3' for some
	// clone.
	protected String cloneType;

	public Clone(String filePath) {
		cloneDBID = -1;
		this.filePath = filePath;
	}

	public Clone(long cloneIDIn) {
		cloneDBID = cloneIDIn;
	}

	public void setCloneDBID(long cloneDBIDIn) {
		cloneDBID = cloneDBIDIn;
	}

	public void setCloneID(String cloneIDIn) {
		cloneID = cloneIDIn;
	}

	public void setLibraryID(long libraryIDIn) {
		libraryID = libraryIDIn;
	}

	public void setCloneType(String cloneTypeIn) {
		cloneType = cloneTypeIn;
	}

	public String getCloneType() {
		return cloneType;
	}

	public String getCloneID() {
		return cloneID;
	}

	public long getCloneDBID() {
		return cloneDBID;
	}

	public long getLibraryID() {
		return libraryID;
	}

	public Clone addClone(String taxonName) {
		if (cloneID != null) {
			ClonePersistence saveClone = ClonePersistence.instance(filePath);
			return saveClone.addClone(this, taxonName);
		}
		return this;
	}
}