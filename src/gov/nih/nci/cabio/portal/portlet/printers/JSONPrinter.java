package gov.nih.nci.cabio.portal.portlet.printers;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Converts a domain object into a JSON object.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public interface JSONPrinter {
   
    /**
     * Returns a JSON object (JSONObject or JSONArray) with relevant data 
     * from the genes in the given collection.
     * @param collection
     * @return
     * @throws JSONException
     */
    public JSONObject objectToJSON(Object obj) 
        throws JSONException;
        
}