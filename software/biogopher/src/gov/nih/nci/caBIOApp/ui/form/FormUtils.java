/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.ui.ValueLabelPair;

import java.util.Iterator;
import java.util.List;
import java.util.Set;

import org.apache.struts.action.ActionError;

public class FormUtils {

    public static ActionError validateRequiredName(String name, String msgKey,
            String[] subs) {
        ActionError error = null;
        if (name == null || name.trim().length() == 0) {
            error = buildActionError(msgKey, subs);
        }
        return error;
    }

    /**
     * This method requires a message key that points to a message
     * with 2 substitutions. First one is the proposed name, second,
     * one is the suggested name.
     */
    public static ActionError validateUniqueName(String name, Set names,
            String msgKey) {
        ActionError error = null;
        if (names.contains(name)) {
            String sugg = null;
            int i = 1;
            do {
                sugg = name + i;
            } while (names.contains(sugg));
            error = buildActionError(msgKey, new String[] { name, sugg });
        }
        return error;
    }

    public static ActionError buildActionError(String msgKey, String[] subs) {
        ActionError error = null;
        switch (subs.length) {
        case 0:
            error = new ActionError(msgKey);
            break;
        case 1:
            error = new ActionError(msgKey, subs[0]);
            break;
        case 2:
            error = new ActionError(msgKey, subs[0], subs[1]);
            break;
        case 3:
            error = new ActionError(msgKey, subs[0], subs[1], subs[2]);
            break;
        case 4:
            error = new ActionError(msgKey, subs[0], subs[1], subs[2], subs[3]);
            break;
        default:
            throw new IllegalArgumentException(
                    "Only less four or fewer substitutions allowed.");
        }
        return error;
    }

    public static ValueLabelPair getVLP(List vlps, String val) {
        ValueLabelPair theVLP = null;
        for (Iterator i = vlps.iterator(); i.hasNext();) {
            ValueLabelPair aVLP = (ValueLabelPair) i.next();
            if (aVLP.getValue().equals(val)) {
                theVLP = aVLP;
                break;
            }
        }
        return theVLP;
    }

    public static boolean isLong(String val) {
        boolean isLong = true;
        try {
            Long l = new Long(val);
        }
        catch (Exception ex) {
            isLong = false;
        }
        return isLong;
    }

    public static String escapeApostrophes(String s) {
        String result = null;
        if (s != null) {
            StringBuffer sb = new StringBuffer(s.length());
            for (int i = 0; i < s.length(); i++) {
                if ('\'' == s.charAt(i)) {
                    sb.append("\\'");
                }
                else {
                    sb.append(s.charAt(i));
                }
            }
            result = sb.toString();
        }
        return result;
    }
}
