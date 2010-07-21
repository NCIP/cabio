package gov.nih.nci.iso21090.junit;

import gov.nih.nci.iso21090.Bl;
import gov.nih.nci.iso21090.Cd;
import gov.nih.nci.iso21090.EdText;
import gov.nih.nci.iso21090.Ii;
import gov.nih.nci.iso21090.Int;
import gov.nih.nci.iso21090.St;
import gov.nih.nci.iso21090.Ts;
import junit.framework.Assert;

/**
 * Tests ISO21090 types for consistency with the invariant specification. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ISOAssert  {

    /**
     * Tests the internal consistency of a CD instance.
     * @param cd
     */
    public static void assertConsistent(Cd cd) {
        
        Assert.assertNotNull(cd);
        if (cd.getNullFlavor() != null) return;
        
        // "if the value is not null then code or originalText shall have a value"
        Assert.assertTrue(cd.getCode() != null || cd.getOriginalText() != null);
        assertConsistent(cd.getOriginalText());
        
        if (cd.getCode() != null) {
            Assert.assertNotNull(
                "if code has a value then codeSystem shall have a value",
                cd.getCodeSystem());
        }
        if (cd.getCodeSystemName() != null) {
            Assert.assertNotNull(
                "codeSystemName can only have a value if codeSystem has a value",
                cd.getCodeSystem());
        }
        if (cd.getCodeSystemVersion() != null) {
            Assert.assertNotNull(
                "codeSystemVersion can only have a value if codeSystem has a value",
                cd.getCodeSystem());
        }

        if (cd.getDisplayName() != null && cd.getDisplayName().getValue() != null) { 
            Assert.assertNotNull(
                "displayName can only have a value if code has a value",
                cd.getCode());
        }
    }

    /**
     * Tests the internal consistency of a II instance.
     * @param cd
     */
    public static void assertConsistent(Ii ii) {
        
        Assert.assertNotNull(ii);
        if (ii.getNullFlavor() != null) return;
        
        Assert.assertNotNull(
            "a root shall be present if the II is not nullFlavored",
            ii.getRoot());
    }

    /**
     * Tests the internal consistency of a ST instance.
     * @param cd
     */
    public static void assertConsistent(St st) {
        
        Assert.assertNotNull(st);
        if (st.getNullFlavor() != null) return;
                
        // "if there is a value, there shall be at least one character"
        Assert.assertNotNull(st.getValue());
        Assert.assertTrue(st.getValue().length() > 0);
        
    }

    /**
     * Tests the internal consistency of a BL instance.
     * @param cd
     */
    public static void assertConsistent(Bl bl) {
        
        Assert.assertNotNull(bl);
        if (bl.getNullFlavor() != null) return;
        
        // "the BL shall have a value if it does not have a nullFlavor"
        Assert.assertNotNull(bl.getValue());
    }

    /**
     * Tests the internal consistency of a INT instance.
     * @param cd
     */
    public static void assertConsistent(Int i) {
        
        Assert.assertNotNull(i);
        if (i.getNullFlavor() != null) return;
        
        // "a value or an uncertain range must be provided if not nullFlavored"
        Assert.assertNotNull(i.getValue());
    }
    
    /**
     * Tests the internal consistency of a TS instance.
     * @param cd
     */
    public static void assertConsistent(Ts ts) {
        
        Assert.assertNotNull(ts);
        if (ts.getNullFlavor() != null) return;
        
        // "if the TS is not nullFlavored, a value or an uncertain range must be present"
        Assert.assertNotNull(ts.getValue());        
    }

    /**
     * Tests the internal consistency of a ED.TEXT instance.
     * @param cd
     */
    public static void assertConsistent(EdText edtext) {
        
        Assert.assertNotNull(edtext);
        if (edtext.getNullFlavor() != null) return;

        // "either reference, data, value or xml shall be provided if not 
        // nullFlavored, and at least one byte of data shall be referenced"
        Assert.assertNotNull(edtext.getValue());
        Assert.assertTrue(edtext.getValue().length() > 0);

        // "the content cannot be provided as a text or data - it shall be text and/or reference"
        Assert.assertNull("data is not allowed for EdText",edtext.getData()); 
        
        // "thumbnail, compression and translations are not allowed"
        Assert.assertNull("compression is not allowed for EdText",edtext.getCompression()); 
              
    }
}
