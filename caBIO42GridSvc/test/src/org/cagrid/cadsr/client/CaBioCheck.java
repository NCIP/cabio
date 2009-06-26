package org.cagrid.cadsr.client;

import java.io.File;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import gov.nih.nci.cadsr.umlproject.domain.Project;
import gov.nih.nci.cadsr.umlproject.domain.UMLClassMetadata;
import gov.nih.nci.cadsr.umlproject.domain.UMLPackageMetadata;

public class CaBioCheck {
	private static String projectName = "caBIO";
	private static String projectVersion = "4.2";
	private static String beansFileName = "cabio42-beans.jar";
	//private static String cadsrDataServiceUrl = "http://cadsr-dataservice-sandbox.nci.nih.gov:80/wsrf/services/cagrid/CaDSRDataService";
	private static String cadsrDataServiceUrl = "http://cadsr-dataservice.nci.nih.gov:80/wsrf/services/cagrid/CaDSRDataService";
	
    /**
     * @param args
     */
    public static void main(String[] args) {
        try {
        	CaBioCheck check = new CaBioCheck();
        	Collection<String> classList = check.getClasses();
        	
            CaDSRUMLModelService client = new CaDSRUMLModelService(cadsrDataServiceUrl);
            System.out.println("Finding projects");
            Project[] projects = client.findAllProjects();
            Project cabio = null;
            for (Project p : projects) {
                if (p.getShortName().equals(projectName) && p.getVersion().equals(projectVersion)) {
                    cabio = p;
                    break;
                }
            }
            
            System.out.println("Finding packages");
            UMLPackageMetadata[] packages = client.findPackagesInProject(cabio);
            String fullClassname = "";
            int totalClasses = 0;
            for (UMLPackageMetadata pack : packages) {
                System.out.println("Package " + pack.getName());
                UMLClassMetadata[] classes = client.findClassesInPackage(cabio, pack.getName());
                for (UMLClassMetadata clazz : classes) {
                	fullClassname = String.format("%s.%s", pack.getName(), clazz.getName());
                    if ( classList.contains(fullClassname) )
                    {
                      System.out.println("\t" + clazz.getName());
                    }
                    else 
                    {
                    	System.out.println("\t" + clazz.getName() + " ***NOT FOUND***");
                    }
                    totalClasses++;
                }
            }
            
            System.out.println( String.format("Total classes in caDSR: %d", totalClasses));
            System.out.println( String.format("Total classes in %s: %d", beansFileName, classList.size()));
            
            System.out.println("DONE");
            
            
        } catch (Exception ex) {
            ex.printStackTrace();
        }

    }

	private Collection<String> getClasses() throws Exception
	{
		//Collection<Class> list = new ArrayList<Class>();
		Collection<String> list = new ArrayList<String>();
		JarFile file = null;
		int count = 0;
		for(File f:new File("lib").listFiles())
		{
			if(f.getName().equalsIgnoreCase(beansFileName))
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
					list.add(klassName);
				}
			}
		}
		return list;
	}    
}
