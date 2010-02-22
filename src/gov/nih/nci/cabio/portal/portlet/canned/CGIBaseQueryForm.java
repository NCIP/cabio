package gov.nih.nci.cabio.portal.portlet.canned;

/**
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class CGIBaseQueryForm extends PaginatedForm {
    private String sentenceType = "all";  // negation_status: yes, no or everything
    private String finishedSentence = "";  // finished or include everything
    private String cellline = "";   // cellline_status: yes or no

    public String getFinishedSentence() {
		return finishedSentence;
	}

	public void setFinishedSentence(String finishedSentence) {
		this.finishedSentence = finishedSentence;
	}

	public String getCellline() {
		return cellline;
	}
	public void setCellline(String cellline) {
		this.cellline = cellline;
	}
	public String getSentenceType() {
		return sentenceType;
	}

	public void setSentenceType(String sentenceType) {
		this.sentenceType = sentenceType;
	}
}
