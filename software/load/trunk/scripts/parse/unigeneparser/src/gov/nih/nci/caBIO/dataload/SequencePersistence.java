package gov.nih.nci.caBIO.dataload;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.Writer;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 * Writes sequences to the output file.
 * 
 * @author caCORE Team
 * @version 1.0
 */
public class SequencePersistence {

	final private static String TERMINATOR = "%|";

	private static Writer out;

	private static Clone cloneToSave;

    private static long sequenceCounter = -1;

    private static SequencePersistence onlyInstance = null; // singleton
   
    private Connection conn;

    private SequencePersistence(String filePath) {
        try {
            if (sequenceCounter == -1) {
                sequenceCounter = 1;
                File seqFile = new File(filePath, "sequence.dat");
                out = new BufferedWriter(new FileWriter(seqFile));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Static factory method that makes a single instance of this class.
     */
    public static SequencePersistence instance(String filePath) {
        if (onlyInstance == null) {
            onlyInstance = new SequencePersistence(filePath);
        }
        return onlyInstance;
    }

    public void getSequenceByAccession(Sequence sequenceToGet) {
        try {
            Statement stmt = conn.createStatement();

            // String sqlStatement = "select SEQUENCE_ID, SEQUENCE_TYPE, length,
            // clone_id from sequence ";
            // sqlStatement = sqlStatement + " where accession_number='" +
            // sequenceToGet.getAccessionNumber() + "'";
            String sqlStatement = "select ID, SEQUENCE_TYPE, length, clone_id from nucleic_acid_sequence ";
            sqlStatement = sqlStatement + " where accession_number='"
                    + sequenceToGet.getAccessionNumber() + "'";
            ResultSet rset = stmt.executeQuery(sqlStatement);
            if (rset.next()) {
                sequenceToGet.setSequenceDBID(rset.getLong(1));
                if (rset.getLong(2) == 1)
                    sequenceToGet.setSequenceType("MRNA");
                else
                    sequenceToGet.setSequenceType("GENOMIC");
                sequenceToGet.setLength(rset.getLong(3));
            }
            long cloneDBID = rset.getLong(4);
            if (!(rset.wasNull())) {
                Clone sequenceClone = new Clone(cloneDBID);
                sequenceToGet.setClone(sequenceClone);
            }

            rset.close();
            stmt.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Flush and close the output files.
     */
    public void cleanup() {
        try {
            out.flush();
            out.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public long addSequence(Sequence sequenceToSave, String taxonName) {
        sequenceCounter++;
        String sequenceType;
        String accessionNumber;
        String accessionNumberVersion;
        sequenceToSave.setSequenceDBID(sequenceCounter);

        try {
            // check for version number at the end of the accession number
            int index = sequenceToSave.getAccessionNumber().indexOf('.');

            if (index > 0) {
                accessionNumber = sequenceToSave.getAccessionNumber()
                        .substring(0, index);
                accessionNumberVersion = sequenceToSave.getAccessionNumber()
                        .substring(index + 1);
            } else {
                accessionNumber = sequenceToSave.getAccessionNumber();
                accessionNumberVersion = "";
            }
            StringBuffer myBuff = new StringBuffer("").append(sequenceCounter)
                    .append(TERMINATOR).append(accessionNumber).append(
                            TERMINATOR).append(accessionNumberVersion).append(
                            TERMINATOR);
            sequenceType = sequenceToSave.getSequenceType();
            if (sequenceType.equals("MRNA")) {
                myBuff.append(1).append(TERMINATOR).append("MessengerRNA").append(TERMINATOR);
            } else {
                myBuff.append(2).append(TERMINATOR).append("ExpressedSequenceTag").append(TERMINATOR);
            }
            cloneToSave = sequenceToSave.getClone();
            Clone cloneSaved = cloneToSave.addClone(taxonName);
            long cloneDBID = cloneSaved.getCloneDBID();
            if (cloneDBID != -1) {
                myBuff.append(cloneDBID).append(TERMINATOR);
            }

            out.write(myBuff.toString() + "\n");
            // addSeqDatabaseLinks(sequenceToSave, false);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return sequenceCounter;
    }

}
