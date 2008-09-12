package gov.nih.nci.cabio.portal.portlet.canned;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GridRangeQueryForm extends PaginatedForm {

    private static Log log = LogFactory.getLog(GridRangeQueryForm.class);
    
    private final GenomicFeature[] classFilterValues = GenomicFeature.values();
    
    private String gridId = "hdl://2500.1.PMEUQUCCL5/DXZ7ZIOFOE";
    private String downstreamPad = "100";
    private String upstreamPad = "100";
    private String classFilter = "";
    
    
    /**************************************************************************/
    /**                     AUTO-GENERATED BEAN METHODS                       */
    /**************************************************************************/
 
    
    public String getGridId() {
        return gridId;
    }
    public void setGridId(String gridId) {
        this.gridId = gridId;
    }
    public String getDownstreamPad() {
        return downstreamPad;
    }
    public void setDownstreamPad(String downstreamPad) {
        this.downstreamPad = downstreamPad;
    }
    public String getUpstreamPad() {
        return upstreamPad;
    }
    public void setUpstreamPad(String upstreamPad) {
        this.upstreamPad = upstreamPad;
    }
    public String getClassFilter() {
        return classFilter;
    }
    public void setClassFilter(String classFilter) {
        this.classFilter = classFilter;
    }
    public GenomicFeature[] getClassFilterValues() {
        return classFilterValues;
    }

    
}
