
              caBIO: Source Code and Server Installation
                           Version 4.1
                           May 22, 2008
      
================================================================
                            Contents
================================================================
    
    1.0 Introduction
    2.0 Required Software 
          2.1 Java 2 Platform
          2.2 Servlet Container
        
    3.0 Install in Tomcat
          3.1 Edit server.xml
          3.2 Deploy the war file

    4.0 Install in JBoss
          4.1 Deploy configuration files
          4.2 Deploy the war file
   
    5.0 Tests
         5.1 Web application
         5.2 Unit tests
        
    6.0 Building caBIO
    
    7.0 License
    
================================================================
                       1.0 Introduction
================================================================
    
    This document contains the instructions for installing 
    a local version of caBIO version 4.1 on a machine running a
    Windows 2000/NT/UNIX/LINUX operating system.  
    
     
================================================================
                     2.0 Required Software 
================================================================
    
----------------------------------------------------------------
2.1 Java 2 Platform (required)
----------------------------------------------------------------

    Java 2 Platform Enterprise Edition (J2EE) or Standard
    Edition (J2SE) is required to compile and run caCORE. 
    J2SDK jdk1.5.0.08 or later version is required. You can 
    download the JDK from Sun Microsystems, Inc. at the 
    following locations:
    
        http://java.sun.com/j2ee/
        http://java.sun.com/j2se/

----------------------------------------------------------------
2.2 Servlet Container
----------------------------------------------------------------
    This installation assumes that you have either JBoss 4.0.5.GA 
    or Tomcat 4.1 or later installed.

    If using JBoss skip to section "4.0. Install in JBoss"
    If using Tomcat proceed to the next section.

    If you don't have either they can be found at:

      JBOSS:  http://sourceforge.net/projects/jboss/
      TOMCAT: http://jakarta.apache.org/tomcat/

================================================================
                   3.0 Install in Tomcat
================================================================
    
----------------------------------------------------------------
 3.1 Edit server.xml
----------------------------------------------------------------

    Consult Tomcat documentation on the proper way to configure 
    your data sources in the server.xml file.

----------------------------------------------------------------
 3.2 Deploy the war file 
----------------------------------------------------------------

    The cabio41.war file should be dropped into the Tomcat 
    webapps directory.
  
    Restart Tomcat.


================================================================
                   4.0 Install in JBoss
================================================================
     

----------------------------------------------------------------
 4.1 Deploy configuration files
----------------------------------------------------------------

  The server-specific configuration files can be found under the 
  deploy directory in the source distribution.


  1) Install data directory
     
     Copy the provided deploy/data directory to some place 
     accessible by the JBoss instance, such as 
     $JBOSS_HOME/server/default/data

  
  2) Configure Grid Id Handle API

     Configure the data/cacore.properties file to point to the
     location you installed the data directory in Step 1.

     Configure the data/svr_1/config.dct file with your Oracle 
     database connection information.


  3) Install FreestyleLM indexes

     If you generated indexes for the database, place them 
     under data/indexes.


  4) Install JDBC drivers
  
     Copy the deploy/lib/ojdbc14.jar file into 
     $JBOSS_HOME/server/default/lib if you are using an 
     Oracle database.

 
  5) Deploy cabio-oracle-ds.xml

     Configure the deploy/conf/cabio-oracle-ds.xml file with 
     your Oracle database connection information, and place it 
     into the JBoss deploy directory.


  6) Deploy properties-service.xml

     Configure the deploy/conf/properties-service.xml file to 
     point to the data/cacore.properties file you installed
     in Step 1. Deploy the properties-service.xml into 
     the JBoss deploy directory.    


----------------------------------------------------------------
 4.2 Deploy the war file 
----------------------------------------------------------------

    Copy the deploy/cabio41.war to the JBoss deploy directory 
    and restart JBoss.
    

================================================================
                          5.0 Tests
================================================================

    Assuming you are running Tomcat or JBoss locally, the 
    following tests should work.
    
----------------------------------------------------------------
5.1 Web application
----------------------------------------------------------------

    The following URL should display the caBIO Home Page if 
    everything is working correctly:
   
        http://localhost:8080/cabio41


----------------------------------------------------------------
5.1 Unit tests
----------------------------------------------------------------

    Run the unit tests by typing:

    cd test
    ant alltests


================================================================
                       6.0 Building caBIO
================================================================
   	
    To rebuild the caBIO war file, the directory structures must
    be appropriately configured. The caBIO root directory must
    be called "cabioapi", or configured differently in the 
    build.xml. The best way to achieve this is to simply rename 
    the source directory to cabioapi.
    
    You will also need to have installed the caCORE SDK version 
    4.0 in the ../cacoresdk/SDK4 directory. You can obtain the 
    SDK from NCICB download site:

	http://ncicb.nci.nih.gov/download/ 

    Once the SDK is in place, just run "ant build-system" from 
    your base caBIO installation directory. 

    The following arguments are optional:

    -DSERVER_URL="http://yourserver/cabio41"
        Configures the default server pointed to by the clients
        which are built.

    -DCACHE_PATH="/path/to/cache"
        Configures the Hibernate EHCache path (defaults to 
        the JVM's temp directory).

    -DINDEX_BASE="/path/to/indexes"
        Configures the FreestyleLM index path.

    The cabio41.war file will be saved to your output\webapp
    directory. In order for the war file to work properly with 
    your client, use the client found in output/remote-client.

    To rebuild the source package, type "ant dist-source". This 
    will create the source distribution under output/source.

    
================================================================
                         7.0 License
================================================================
    
    The caBIO version 4.1 software is licensed under the terms
    contained in the license located at:
    
        http://ncicb.nci.nih.gov/download/cabiolicenseagreement.jsp
    
    This product includes software developed by the
    Apache Software Foundation (http://www.apache.org/).
    -Apache SOAP, Crimson, Xerces, and Xalan are part of Apache
    XML project.
    -Tomcat, ORO, and Lucene are part of the Apache Jakarta project. 

    All aforementioned Apache projects are trademarks of 
    the Apache Software Foundation. For further
    open source licensing issues pertaining to Apache Software
    Foundation, visit:
    
        http://www.apache.org/LICENSE 

    Hibernate is Free Software. The LGPL license is sufficiently 
    flexible to allow the use of Hibernate in both open source 
    and commercial projects.
    
        http://www.gnu.org/copyleft/lesser.html
    
    This product includes software developed by Castor 
    (http://www.castor.org), which is licensed under the 
    Exolab license:

        http://www.castor.org/license.html


    Sun, Sun Microsystems, Solaris, Java, JavaServer Web
    Development Kit, and JavaServer Pages are trademarks or
    registered trademarks of Sun Microsystems, Inc. The jaxp.jar
    and jaxb-rt-1.0-ea.jar are redistributed as whole binary
    jars and are subject to the Sun license terms as stated in
    
        http://java.sun.com/xml/docs/summer02/LICENSE.html
    
    UNIX is a registered trademark in the United States and
    other countries, exclusively licensed through X/Open
    Company, Ltd.

    Oracle is a registered trademark of Oracle Corporation.
   
    Windows, WindowsNT, and Win32 are registered trademarks of
    Microsoft Corp. 
    
    All other product names mentioned herein and throughout the
    entire caBIO project are trademarks of their respective
    owners.
    
    
//end