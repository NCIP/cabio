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
public class GeneBySymbolQueryForm extends PaginatedForm {

    private String geneSymbol = "brca1";

    /**************************************************************************/
    /**                     AUTO-GENERATED BEAN METHODS                       */
    /**************************************************************************/
 
    public String getGeneSymbol() {
        return geneSymbol;
    }

    public void setGeneSymbol(String geneSymbol) {
        this.geneSymbol = geneSymbol;
    }
}
