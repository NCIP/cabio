/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

import gov.nih.nci.search.SearchQuery;
import gov.nih.nci.search.SearchResult;
import gov.nih.nci.system.applicationservice.CaBioApplicationService;
import gov.nih.nci.system.client.ApplicationServiceProvider;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;


public class TestFreestyleLM
{
	public static void main(String args[])
	{
		TestFreestyleLM client = new TestFreestyleLM();
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

		CaBioApplicationService appService = (CaBioApplicationService)ApplicationServiceProvider.getApplicationService();
		try{
			String keywords = "p53^";
			
			String startChars = "^[*?].+";   // check the string starting with * and ?			
			String regex = ".+[^(\\Q\\\\E)][(\\Q()\\\\E)\\[\\]\\^{}!:\"].*";
            					
			// check the start character
			if ( keywords.matches(startChars) )
			{
				// illegal start character
				return;
			}
			// check the other Lucene escape characters		
            if ( keywords.matches(regex) )
            {
            	// it matches the illegal charactors so simply return it
                return;	
            }
            
			SearchQuery query = new SearchQuery();
			query.setKeyword(keywords);

			List results = appService.search(query);
			for(int i=0; i<results.size(); i++){
				SearchResult result = (SearchResult)results.get(i);
				System.out.println("Class: "+ result.getClassName() +"\t"+ result.getId());
			}
			System.out.println("Results: "+ results.size());
		}catch(Exception e){
			System.out.println(">>>"+e.getMessage());
		}

	}

	protected void printObject(Object obj, Class klass) throws Exception {
		System.out.println("Printing "+ obj.getClass().getName());
		Method[] methods = klass.getMethods();
		for(Method method:methods)
		{
			if(method.getName().startsWith("get") && !method.getName().equals("getClass"))
			{
				System.out.print("\t"+method.getName().substring(3)+":");
				Object val = method.invoke(obj, (Object[])null);
				if(val instanceof java.util.Set)
					System.out.println("size="+((Collection)val).size());
				else
					System.out.println(val);
			}
		}
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