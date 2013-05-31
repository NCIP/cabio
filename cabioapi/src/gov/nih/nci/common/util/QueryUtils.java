/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.common.util;

import java.util.regex.Pattern;

import org.apache.log4j.Logger;

/**
 * Methods for constructing queries.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class QueryUtils {

    private static Logger log = Logger.getLogger(QueryUtils.class);
    
    public static String createCountQuery(String hql) {
        
        String h = hql.trim();
        
        // do not eager load anything because it may expand the number of rows
        h = h.replaceAll("(FETCH|fetch)", "");
        
        if (h.toUpperCase().startsWith("FROM")) {
            return "select count(*) "+h;
        }
        else {
            Pattern p = Pattern.compile("select (.*?) from", Pattern.CASE_INSENSITIVE);
            return p.matcher(h).replaceFirst("select count(*) from");
        }
    }
}
