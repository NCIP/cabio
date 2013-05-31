/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.cabio.portal.portlet.canned;


/**
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ReporterByNameQueryForm extends PaginatedForm {

    private String microarray = "HG-U133_Plus_2";
    private String reporterId = "1552301_a_at";
    
    /**************************************************************************/
    /**                     AUTO-GENERATED BEAN METHODS                       */
    /**************************************************************************/
    
    public String getMicroarray() {
        return microarray;
    }
    public void setMicroarray(String microarray) {
        this.microarray = microarray;
    }
    public String getReporterId() {
        return reporterId;
    }
    public void setReporterId(String reporterId) {
        this.reporterId = reporterId;
    }
    
}
