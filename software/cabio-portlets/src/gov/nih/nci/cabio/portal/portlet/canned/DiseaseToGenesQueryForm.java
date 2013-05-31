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
public class DiseaseToGenesQueryForm extends CGIBaseQueryForm {

    private String disease = "fibroadenoma";

    /**************************************************************************/
    /**                     AUTO-GENERATED BEAN METHODS                       */
    /**************************************************************************/
 
    public String getDisease() {
        return disease;
    }

    public void setDisease(String disease) {
        this.disease = disease;
    }

}
