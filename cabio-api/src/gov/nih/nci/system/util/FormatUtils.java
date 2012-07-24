package gov.nih.nci.system.util;

/**
 * Utility methods for formatting various values for display.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class FormatUtils {

    /**
     * Format a camel case name into a label with spaces. 
     * @param name
     * @return
     */
    public static String formatCamelCaseAsLabel(String name) {
        
        if (name == null || "".equals(name)) return "";
        
        StringBuffer out = new StringBuffer();
        out.append(Character.toUpperCase(name.charAt(0)));
        
        boolean ucRun = true;
        for(int i=1; i<name.length(); i++) {
            char c = name.charAt(i);
            boolean nextIsLower = i+1<name.length() && Character.isLowerCase(name.charAt(i+1));
            if (Character.isUpperCase(c)) {
                if (!ucRun || nextIsLower) {
                    out.append(" ");
                    ucRun = true;
                }
            }
            else {
                ucRun = false;
            }

            out.append(c);
            
        }
        return out.toString();
    }
    
    public static final void main(String[] args) {

        String[] testCases = {"SNP","Gene","GenePhysicalLocation",
                "leadOrganizationId","NIHAdminCode","legacySNPId"};
        
        for(String testCase : testCases)
            System.out.println(testCase+" -> "+formatCamelCaseAsLabel(testCase));
    }
}
