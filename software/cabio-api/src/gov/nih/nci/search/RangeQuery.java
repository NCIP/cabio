/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.search;

import java.io.Serializable;

/**
 * A range query on a specific assembly of the genome. By default, the reference
 * genome is used. Range queries can allow partial matches if desired.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public abstract class RangeQuery implements Serializable {

    private static final long serialVersionUID = 1234567890L;
        
    private Boolean allowPartialMatches = false;
    
    private String assembly = "reference";
    
    public Boolean getAllowPartialMatches() {
        return allowPartialMatches;
    }
    
    public void setAllowPartialMatches(Boolean allowPartialMatches) {
        this.allowPartialMatches = allowPartialMatches;
    }

    public String getAssembly() {
        return assembly;
    }

    public void setAssembly(String assembly) {
        this.assembly = assembly;
    }
    
    
}
