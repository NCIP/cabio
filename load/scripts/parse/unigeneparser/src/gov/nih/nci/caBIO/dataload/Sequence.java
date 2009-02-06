package gov.nih.nci.caBIO.dataload;

import java.util.Hashtable;

/**
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class Sequence {

	protected String accessionNumber;

	protected long sequenceDBID;

	protected Clone clone;

	protected Hashtable databaseLinks;

	protected String sequenceType;

	protected String Orientation;

	protected long length;

	protected String asciiString;

    public Sequence(String filePath) {
        // databaseLinks = new Hashtable();
        clone = new Clone(filePath);
        sequenceType = "mRNA";
        this.filePath = filePath;
    }
	protected String filePath;

	public void setSequenceDBID(long sequenceDBIDIn) {
		sequenceDBID = sequenceDBIDIn;
	}

	public void setAccessionNumber(String accessionNumberIn) {
		accessionNumber = accessionNumberIn;
	}

	public void setLength(long lengthIn) {
		length = lengthIn;
	}

	public void setDatabaseLinks(Hashtable databaseLinksIn) {
		databaseLinks = databaseLinksIn;
	}

	public void setSequenceType(String sequenceTypeIn) {
		sequenceType = sequenceTypeIn;
	}

	public void setClone(Clone CloneIn) {
		clone = CloneIn;
	}

	public long getSequenceDBID() {
		return sequenceDBID;
	}

	public long getLength() {
		return length;
	}

	public String getAccessionNumber() {
		return accessionNumber;
	}

	public String getOrientation() {
		return accessionNumber;
	}

	public String getSequenceType() {
		return sequenceType;
	}

	public Clone getClone() {
		return clone;
	}

	public void getSequenceByAccession() {
		SequencePersistence getSequence = SequencePersistence
				.instance(filePath);
		getSequence.getSequenceByAccession(this);
	}

	public long addSequence(String taxonName) {
		try {
			SequencePersistence saveSequence = SequencePersistence
					.instance(filePath);
			sequenceDBID = saveSequence.addSequence(this, taxonName);

		} catch (Exception e) {
			System.err.println(e.getMessage());
		}
		return sequenceDBID;
	}

}
