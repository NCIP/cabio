/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.system.applicationservice.ApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.hibernate.criterion.DetachedCriteria;
import org.hibernate.criterion.Restrictions;

/** 
 * This TestClient was copied from the SDK in order to optimize it for use with 
 * caBIO. The queries were modified to only fetch rownum=1, and collections are
 * no longer printed. 
 */
public class TestClient
{
	public static void main(String args[])
	{
        TestClient client = new TestClient();
		try
		{
			client.testSearch();
		}
		catch(Exception e)
		{
			e.printStackTrace();
		}
	}
	
	public void testSearch() throws Exception
	{
		//Application Service retrieval for secured system
		//ApplicationService appService = ApplicationServiceProvider.getApplicationService("userId","password");
		
		ApplicationService appService = ApplicationServiceProvider.getApplicationService();
		Collection<Class> classList = getClasses();
		for(Class klass:classList)
		{
			System.out.println("Searching for "+klass.getName());
			try
			{
                DetachedCriteria criteria = DetachedCriteria.forClass(klass);
                criteria.add(Restrictions.sqlRestriction("rownum=1"));

				Collection results = appService.query(criteria);
				for(Object obj : results)
				{
					printObject(obj, klass);
					break;
				}
			}catch(Exception e)
			{
				System.out.println(">>>"+e.getMessage());
			}
		}
	}
	
	protected void printObject(Object obj, Class klass) throws Exception {
		System.out.println("Printing "+ obj.getClass().getName());
		Method[] methods = klass.getMethods();
		for(Method method:methods)
		{
			if(method.getName().startsWith("get") 
                    && !method.getName().equals("getClass")
                    && !method.getName().endsWith("Collection"))
			{
				System.out.print("\t"+method.getName().substring(3)+":");
				Object val = method.invoke(obj, (Object[])null);
				if(val instanceof java.util.Set)
					System.out.println("size="+((Collection)val).size());
				else
					System.out.println(val);
			}
		}
		System.out.println("--------");
	}


	protected Collection<Class> getClasses() throws Exception
	{
		Collection<Class> list = new ArrayList<Class>();
		JarFile file = null;
		int count = 0;
		
		for(File f:new File("lib").listFiles())	
		{
			if(f.getName().endsWith("-beans.jar"))
			{
				file = new JarFile(f);
				count++;
			}
		}
		if(file == null) throw new Exception("Could not locate the bean jar");
		if(count>1) throw new Exception("Found more than one bean jar");
		
		Enumeration e = file.entries();
		while(e.hasMoreElements())
		{
			JarEntry o = (JarEntry) e.nextElement();
			if(!o.isDirectory())
			{
				String name = o.getName();
				if(name.endsWith(".class"))
				{
					String klassName = name.replace('/', '.').substring(0, name.lastIndexOf('.'));
					list.add(Class.forName(klassName));
				}
			}
		}
		return list;
	}
}