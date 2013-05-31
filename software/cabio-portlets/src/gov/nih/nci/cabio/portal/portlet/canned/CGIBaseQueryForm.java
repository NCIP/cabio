/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet.canned;

/**
 * @author <a href="mailto:sunj2@mail.nih.gov">Jim Sun</a>
 */
public class CGIBaseQueryForm extends PaginatedForm {
    private String sentenceType = "";  // negation_status: yes, no or everything
    private String unfinishedSentence = "";  // finished or include everything
    private String cellline = "";   // cellline_status: yes or no

    public String getUnfinishedSentence() {
		return unfinishedSentence;
	}

	public void setUnfinishedSentence(String unfinishedSentence) {
		this.unfinishedSentence = unfinishedSentence;
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
