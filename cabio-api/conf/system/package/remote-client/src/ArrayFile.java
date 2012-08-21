import gov.nih.nci.cabio.annotations.ArrayAnnotationService;
import gov.nih.nci.cabio.annotations.ArrayAnnotationServiceImpl;
import gov.nih.nci.cabio.domain.ArrayReporter;
import gov.nih.nci.cabio.domain.ExpressionArrayReporter;
import gov.nih.nci.common.util.ReflectionUtils;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.io.FileWriter;
import java.io.PrintWriter;
import java.util.Collection;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
 * Sample caBIO-generated array annotation file.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class ArrayFile {

    private static Log log = LogFactory.getLog(ArrayFile.class);
    
    public static void main(String[] args) throws Exception {
        
        PrintWriter out = new PrintWriter(new FileWriter("arrayfile.txt"));
        
        CaBioApplicationService appService = 
            (CaBioApplicationService)ApplicationServiceProvider.getApplicationServiceFromUrl("http://cabioapi-qa.nci.nih.gov/cabio42");

        ArrayAnnotationService am = new ArrayAnnotationServiceImpl(appService);

        String arrayName = "HG-U133_Plus_2";
        
        Collection<ArrayReporter> reps = 
            am.getReportersForPlatform(arrayName);

        out.println("Name\tSymbol\tHUGO Symbol\tUnigene Id\t" +
        		"Sequence Type\tSequence Source\tTarget Id\t" +
        		"Target Description\tCytoband\tChromosome\tStart\tEnd");
        
        int c = 0;
        for(ArrayReporter rep : reps) {

            ExpressionArrayReporter er = (ExpressionArrayReporter)rep;
            
            out.println(resolve(er,"name")+"\t"
                +resolve(er,"gene.symbol")+"\t"
                +resolve(er,"gene.hugoSymbol")+"\t"
                +resolve(er,"gene.clusterId")+"\t"
                +resolve(er,"sequenceType")+"\t"
                +resolve(er,"sequenceSource")+"\t"
                +resolve(er,"targetId")+"\t"
                +resolve(er,"targetDescription")+"\t"
                +resolve(er,"cytogeneticLocationCollection[0].startCytoband.name")+"\t"
                +resolve(er,"physicalLocationCollection[0].chromosome.number")+"\t"
                +resolve(er,"physicalLocationCollection[0].chromosomalStartPosition")+"\t"
                +resolve(er,"physicalLocationCollection[0].chromosomalEndPosition"));
            
            if (c++ > 500) break;  
        }

        out.close();
    }
    
    /**
     * Code borrowed from caBIO Portlet's ResultItem.
     * @param object
     * @param path
     * @return
     */
    private static Object resolve(Object object, String path) {

        if (object == null) return "";
        
        int d = path.indexOf('.');
        String attr = (d < 0) ? path : path.substring(0,d);

        int a = attr.indexOf('[');
        int b = attr.indexOf(']');
        int index = -1;
        if (a > 0) {
            index = Integer.parseInt(attr.substring(a+1,b));
            attr = attr.substring(0,a);
        }
        
        Object nextObj;
        try {
            nextObj = ReflectionUtils.get(object, attr);
        }
        catch (Exception e) {
            log.error("Attribute error for "+path,e);
            return "ERROR";
        }

        if (d < 0) {
            // this is the target attribute
            return (nextObj == null) ? "" : nextObj;
        }
        else {
            String nextPath = path.substring(d+1);
            if (nextObj instanceof List) {
                List nextList = (List)nextObj;
                
                // just need one element from the list
                if (index >= 0) {
                    try {
                        nextObj = nextList.get(index);
                    }
                    catch (IndexOutOfBoundsException e) {
                        return "";
                    }
                    return resolve(nextObj, nextPath);
                }
                
                // aggregate all the elements in the list
                StringBuffer buf = new StringBuffer();
                int c = 0;
                for(Object e : (List)nextObj) {
                    if (c++ > 0) buf.append(", ");
                    buf.append(resolve(e, nextPath));
                }
                return buf.toString();
            }
            else {
                return resolve(nextObj, nextPath);
            }
        }
    }
    
}