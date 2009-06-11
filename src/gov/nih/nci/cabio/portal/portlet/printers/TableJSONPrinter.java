package gov.nih.nci.cabio.portal.portlet.printers;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Prints a collection in a custom JSON table format.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class TableJSONPrinter implements JSONPrinter {

    protected final int MAX_RESULTS = 200;
    
    public JSONObject objectToJSON(Object obj) 
            throws JSONException {

        // TODO: at some point this could be implemented to print the 
        // table generically. Each subclass could implement callbacks which 
        // return the necessary data. Right now, each subclass is responsible
        // for all the JSON generation.
       
        throw new UnsupportedOperationException();
    }
}
