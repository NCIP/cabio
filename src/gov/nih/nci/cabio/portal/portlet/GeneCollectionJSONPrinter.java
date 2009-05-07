package gov.nih.nci.cabio.portal.portlet;

import gov.nih.nci.cabio.domain.Gene;

import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Prints a gene collection in JSON format. The structure looks like this:
 * 
 * {
 *   "columnNames":["Symbol","Description"]
 *   "rows":[
 *      {"Description":"Guanylin","Symbol":"GUCA2A"},
 *      {"Description":"Thrombopoietin","Symbol":"THPO"},
 *      ...
     ]
 * }
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class GeneCollectionJSONPrinter implements JSONPrinter {

    public JSONObject objectToJSON(Object obj) 
            throws JSONException {

        Collection<Gene> collection = (Collection<Gene>)obj;
        
        JSONObject json = new JSONObject();
        
        JSONArray cols = new JSONArray();
        cols.put("Symbol");
        cols.put("Description");
        json.put("columnNames", cols);
        
        JSONArray rows = new JSONArray();
        
        for(Gene gene : collection) {
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("Symbol", gene.getSymbol());
            jsonObj.put("Description", gene.getFullName());
            rows.put(jsonObj);
        }

        json.put("rows", rows);
        return json;
    }
}
