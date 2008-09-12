package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.domain.Microarray;
import gov.nih.nci.cabio.portal.portlet.StaticQueries;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

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
    
    public List<Microarray> getMicroarrays() {
        return StaticQueries.getMicroarrays();
    }
    
    
}
