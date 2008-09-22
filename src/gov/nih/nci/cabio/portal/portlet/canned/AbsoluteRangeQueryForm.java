package gov.nih.nci.cabio.portal.portlet.canned;

import gov.nih.nci.cabio.domain.Chromosome;
import gov.nih.nci.cabio.portal.portlet.GlobalQueries;

import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class AbsoluteRangeQueryForm extends PaginatedForm {

    private static Log log = LogFactory.getLog(AbsoluteRangeQueryForm.class);
        
    private String taxon = "Hs";
    private String chromosomeNumber = "1";
    private String assembly = "reference";
    private String start = "109433764";
    private String end = "109433982";
    private String classFilter = "";

    public Long getChromosomeId() {
        GlobalQueries queries = (GlobalQueries)
            getServlet().getServletContext().getAttribute("globalQueries");
        List<Chromosome> chroms = queries.getTaxonChromosomes().get(taxon);
        for(Chromosome c : chroms) {
            if (c.getNumber().equals(chromosomeNumber)) return c.getId();
        }
        return null;
    }

    
    /**************************************************************************/
    /**                     AUTO-GENERATED BEAN METHODS                       */
    /**************************************************************************/

    public String getTaxon() {
        return taxon;
    }

    public void setTaxon(String taxon) {
        this.taxon = taxon;
    }

    public String getChromosomeNumber() {
        return chromosomeNumber;
    }

    public void setChromosomeNumber(String chromosomeNumber) {
        this.chromosomeNumber = chromosomeNumber;
    }

    public String getStart() {
        return start;
    }

    public void setStart(String start) {
        this.start = start;
    }

    public String getEnd() {
        return end;
    }

    public void setEnd(String end) {
        this.end = end;
    }

    public String getClassFilter() {
        return classFilter;
    }

    public void setClassFilter(String classFilter) {
        this.classFilter = classFilter;
    }

    public String getAssembly() {
        return assembly;
    }

    public void setAssembly(String assembly) {
        this.assembly = assembly;
    }
    
}
