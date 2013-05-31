/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.system.util;

import gov.nih.nci.cabio.domain.ArrayReporterPhysicalLocation;
import gov.nih.nci.cabio.domain.CytobandPhysicalLocation;
import gov.nih.nci.cabio.domain.GenePhysicalLocation;
import gov.nih.nci.cabio.domain.NucleicAcidPhysicalLocation;
import gov.nih.nci.cabio.domain.PhysicalLocation;
import gov.nih.nci.cabio.domain.SNPPhysicalLocation;
import gov.nih.nci.cabio.domain.TranscriptPhysicalLocation;
import gov.nih.nci.search.RangeQuery;
import gov.nih.nci.search.RelativeRangeQuery;

import java.util.ArrayList;
import java.util.List;

/**
 * This class overrides SDK's ClassCache, to provide some filtering.
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class CaBioClassCache extends ClassCache {

    /** drop down list of target classes for range queries */
    private static final List<String> rangeTargets = new ArrayList<String>();
    static {
        rangeTargets.add("Please choose");
        rangeTargets.add(PhysicalLocation.class.getName());
        rangeTargets.add(GenePhysicalLocation.class.getName());
        rangeTargets.add(SNPPhysicalLocation.class.getName());
        rangeTargets.add(NucleicAcidPhysicalLocation.class.getName());
        rangeTargets.add(CytobandPhysicalLocation.class.getName());
        rangeTargets.add(TranscriptPhysicalLocation.class.getName());
        rangeTargets.add(ArrayReporterPhysicalLocation.class.getName());
    }
    
    @Override
    public List<String> getPkgClassNames(String packageName) {

        List<String> names = super.getPkgClassNames(packageName);
        if (!packageName.equals("gov.nih.nci.search")) return names;
        
        // filter the search package
        List<String> filtered = new ArrayList<String>();
        for(String name : names) {
            if (!name.equals(RangeQuery.class.getName()) &&
                    !name.equals(RelativeRangeQuery.class.getName())) {
                filtered.add(name);
            }
        }
        return filtered;
    }

    @Override
    public List<String> getAssociations(String className) {

        // filter RangeQuery classes
        if (className.endsWith("RangeQuery")) {
            return rangeTargets;
        }
        
        return super.getAssociations(className);
    }
}
