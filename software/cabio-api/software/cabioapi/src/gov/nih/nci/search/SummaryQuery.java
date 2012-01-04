package gov.nih.nci.search;

import java.io.Serializable;
import java.util.List;

/**
 * FreestyleLM query which returns a summary of results -- the number of 
 * matching objects per class.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class SummaryQuery implements Serializable {

    private static final long serialVersionUID = 1234567890L;

    private String keyword;
    private List<SummaryResult> results;

    public String getKeyword() {
        return keyword;
    }

    public void setKeyword(String keyword) {
        this.keyword = keyword;
    }
    
    public List<SummaryResult> getResults() {
        return results;
    }

    public void setResults(List<SummaryResult> results) {
        this.results = results;
    }   
}
