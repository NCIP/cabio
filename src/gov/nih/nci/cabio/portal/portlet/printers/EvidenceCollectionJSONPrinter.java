package gov.nih.nci.cabio.portal.portlet.printers;

import gov.nih.nci.cabio.domain.Evidence;
import gov.nih.nci.cabio.domain.EvidenceCode;

import java.util.Collection;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Prints an evidence collection in JSON format. 
 * @see GeneCollectionJSONPrinter
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class EvidenceCollectionJSONPrinter implements JSONPrinter {
    
    public JSONObject objectToJSON(Object obj) 
            throws JSONException {

        Collection<Evidence> collection = (Collection<Evidence>)obj;
        
        JSONObject json = new JSONObject();
        
        JSONArray cols = new JSONArray();
        cols.put("PubMED Id");
        cols.put("Sentence");
        cols.put("Evidence Codes");
        json.put("columnNames", cols);
        json.put("count", collection.size());
        
        JSONArray rows = new JSONArray();
        
        int c=0;
        for(Evidence e : collection) {
            if (c >= 200) break;
            
            StringBuffer sb = new StringBuffer();
            for (EvidenceCode ec : e.getEvidenceCodeCollection()) {
                if (sb.length()>0) sb.append(", ");
                sb.append(ec.getEvidenceCode());
            }
            
            JSONObject jsonObj = new JSONObject();
            jsonObj.put("PubMED Id", e.getPubmedId());
            jsonObj.put("Sentence", e.getSentence());
            jsonObj.put("Evidence Codes", sb.toString());
            rows.put(jsonObj);
            c++;
        }

        json.put("rows", rows);
        return json;
    }
}
