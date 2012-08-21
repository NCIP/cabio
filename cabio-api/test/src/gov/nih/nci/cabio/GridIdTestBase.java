package gov.nih.nci.cabio;

import gov.nih.nci.common.util.ReflectionUtils;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;

import java.util.List;

import junit.framework.TestCase;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

/**
 * Supports tests to ensure all big ids are populated and working. 
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public abstract class GridIdTestBase extends TestCase {

    private final CaBioApplicationService appService = AllTests.getService();
    
    protected void testGridId(Object obj) throws Exception {
        
        // retrieve the first object in the database
        DetachedCriteria criteria = DetachedCriteria.forClass(obj.getClass());
        criteria.add(Restrictions.sqlRestriction("rownum=1"));
        List results = appService.query(criteria);
        assertNotNull(results);
        assertEquals("result size",1,results.size());
        obj = results.get(0);
        assertNotNull(obj);
        
        // get the grid id
        String bigid = String.valueOf(ReflectionUtils.get(obj, "bigid"));
        
        // ensure the grid id exists
        assertNotNull(bigid);
        assertNotSame("",bigid);
        assertTrue(appService.exist(bigid));
        
        // ensure the grid id points to the correct object
        Object dataObj = appService.getDataObject(bigid);
        
        // get the internal id
        String id = String.valueOf(ReflectionUtils.get(obj, "id"));
        String did = String.valueOf(ReflectionUtils.get(dataObj, "id"));
        assertEquals("id",id,did);
        
    }
}
