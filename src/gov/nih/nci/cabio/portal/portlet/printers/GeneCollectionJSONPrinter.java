package gov.nih.nci.cabio.portal.portlet.printers;

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
        cols.put("Cluster Id");
        cols.put("Symbol");
        cols.put("Description");
        json.put("columnNames", cols);
        json.put("count", collection.size());
        
        JSONArray rows = new JSONArray();
        
        int c=0;
        for(Gene gene : collection) {
            if (c >= 200) break;
            
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("Cluster Id", gene.getClusterId());
            jsonObj.put("Symbol", gene.getSymbol());
            jsonObj.put("Description", gene.getFullName());
            rows.put(jsonObj);
            c++;
        }

        json.put("rows", rows);
        return json;
    }
}
