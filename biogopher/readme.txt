
                           Readme.txt
    
                     BIOgopher: source code
                         Version 2.0
                       October 31, 2003
    
================================================================
                            Contents
================================================================
    
    1.0 Introduction
    2.0 Installation Instructions 
    3.0 Ant
    4.0 Compiling the Source 
    5.0 Tomcat Modifications 
    6.0 Deployment under Tomcat
    7.0 Support
    8.0 License
    
================================================================
                        1.0 Introduction
================================================================
    
    BIOgopher is a bioinformatics tool that facilitates the 
    integration of your local bioinformatics data with public 
    data sources via cancer Bioinformatics Infrastructure 
    Objects (caBIO) at the NCI. As an ad hoc querying and 
    reporting tool, BIOgopher enables researchers to annotate 
    spreadsheets with caBIO data. In particular, BIOgopher 
    presents a web-based, graphical user interface that lets you 
    build complex queries that incorporate data from any number 
    of Excel spreadsheets. The results of these queries are then 
    delivered as an Excel spreadsheet in which the original 
    spreadsheet data and the caBIO data are merged.

    +--------------+
    | Distribution |
    +--------------+
    
    This distribution contains the full source code for 
    BIOgopher version 2.0.
    
           BIOgopher_source_[ver].zip
    
    +-----------+
    | caBIO.jar |
    +-----------+
    
    The BIOgopher source code distribution includes the 
    caBIO.jar version 2.0, which is located in the lib directory.
    BIOgopher is dependent on this version. No earlier versions 
    of caBIO.jar will work with BIOgopher 2.0. Subsequent 
    releases of the caBIO.jar may or may not require you to 
    update your installation of BIOgopher. Please refer to the 
    caCORE website when updating either. 

        - http://ncicb.nci.nih.gov/core/

    +--------------------+
    | Supported Browsers |
    +--------------------+
    
    BIOgopher 2.0 is optimized for IE5.5+. 

    +-----+
    | Ant |
    +-----+
    
    Before compiling the source code you must obtain and 
    install Ant, which is available at:
    
         - http://ant.apache.org/

    +--------+
    | Tomcat |
    +--------+
    
    These instructions assume a configured and working version
    of Tomcat on which to run BIOgopher. Tomcat is available at:

         - http://jakarta.apache.org/tomcat/

    BIOgopher 2.0 has been tested using Tomcat 4.1.18.
    
    +----------+
    | JAVA SDK |
    +----------+

    There are known issues with BIOgopher 2.0 when using
    Tomcat 4.1.18 and JDK 1.3.1. Therefore, it is recommended 
    to use JDK 1.4.1 or higher.   
 
================================================================
                  2.0 Installation Instructions 
================================================================

    Unzip the distribution file into a temp location. You will 
    see the following files and directories:

           [your_temp_dir]
                      |
                      +- readme.txt
                      +- ReleaseNotes*.txt
                      +- build.xml
                      +- build.properties
                      +- \cache
                      +- \config
                      +- \lib
                      +- \src
                      +- \web

    Of particular interest is the build.properties file. This 
    file provides essential information to Ant and the build.xml
    file regarding your deployment of BIOgopher 2.0.

    Open the build.properties file in your favorite text editor. 
    You should see at line 37 the following:


    ##--EDIT THE FOLLOWING PARAMETERS FOR YOUR DEPLOYMENT----##
    ###########################################################


    Beneath this point are the variables that will be used by Ant
    to configure your BIOgopher 2.0 webapp. They need to be 
    modified to resemble your deployment environment for BIOgopher.

    +-----------+
    | caBIO.jar |
    +-----------+

    The name of the caBIO jar file to be used.

           For example:

           caBIO.jar=caBIO.jar

    +---------+
    | log.dir |
    +---------+

    The directory for BIOgopher log files.

           For example:

           log.dir=c:/jakarta-tomcat-4.1.18/webapps/BIOgopher/WEB-INF/logs


    +-----------+
    | cache.dir |
    +-----------+

    The directory within BIOgopher's context into/from which 
    serialized ontology files may be written/read.

           For example:

           cache.dir=c:/jakarta-tomcat-4.1.18/webapps/BIOgopher/WEB-INF/cache


================================================================
                           3.0 Ant  
================================================================
    
    BIOgopher 2.0 is compiled using Ant, an open source compile
    tool. To compile and package BIOgopher you will need to 
    download, install, and configure Ant on your machine.  

    Ant is available at:
    
         - http://ant.apache.org/
    
    Refer to the installation directions included with the 
    Ant distribution.
    
================================================================
                   4.0 Compiling the Source
================================================================
    
    First, make sure that you have the JAVA_HOME environment 
    variable set to point to your installation of the Java SDK.  
    BIOgopher has been compiled with JDKs 1.3.1_07 and 1.4.1_03, 
    so these are going to be the recommended installations of 
    the JDK. Others will probably work, but it is worth noting 
    the version you are using in case you have any problems when
    you package BIOgopher and need some help.   

    After you have installed Ant, change to the directory where 
    you have unzipped BIOgopher 2.0 and the location of your 
    build.properties file and type:
    
        ant 
    
    You should see some messages regarding the packaging and 
    compiling of the webapp. After a few seconds, it will show 
    a successful build message.

    If you look at [your_temp_dir], you should see several new 
    directories.

           [your_temp_dir]
                      |
                      +- \build        [ new ]
                      +- \cache
                      +- \config
                      +- \gen_src      [ new ]
                      +- \lib
                      +- \package      [ new ]
                      +- \src
                      +- \web

    Do not be alarmed. They are created by Ant to complete the 
    packaging of BIOgopher and are only temporary.

    If you choose to modify some of the source or properties of
    your build, you will need to delete the build, gen_src, and 
    package folders to ensure that your new changes are seen and 
    incorporated.
    
================================================================
                   5.0 Tomcat Modifications 
================================================================

    +------------------+
    | Security manager |
    +------------------+

    =========
    IMPORTANT
    =========

    Tomcat MUST be started using the security manager. Thus, 
    Tomcat must be started with the -security option. In 
    addition, for the security manager to function, it requires 
    a configured security policy file.
   
    A Java security policy is required to make calls against the 
    caBIO server because the caBIO.jar uses Java RMI (Remote
    Method Invocation) calls to connect with the caBIO server.
    The policies defined in your security policy file 
    (java.policy, catalina.policy, tomcat.policy) are for the 
    protection of your system--NOT the caBIO server. So, though 
    the following permissions are required for BIOgopher 2.0 to 
    run, they are not to be considered a comprehensive security 
    policy for your system. Therefore, you are free (and 
    encouraged!) to edit the policy file as appropriate for your 
    system. 
        
    For more information, see:
    
        - http://java.sun.com/security/
   
    The policy file is located under the name catalina.policy, 
    which is found in the conf directory of your Tomcat 
    installation. Scroll through the file until you find the 
    following:

          // ========== WEB APPLICATION PERMISSIONS ====
    
    A few lines below, you should see the following:

          grant { 

    (Please note that this is does not say "grant codeBase".) 
    Scroll down until you see the close of the grant section:

          };

    At the end of the grant section, modify the section 
    below to match your system's configuration, and copy and 
    paste the information into catalina.policy (below the 
    close of the grant section). 

          grant {

          	/***START:BIOgopher permissions******/
	
                permission java.util.PropertyPermission "*", "read,write";
                permission java.io.FilePermission "C:\\jakarta-tomcat-4.1.18\\webapps\\BIOgopher\\", "read,write,delete";
                permission java.io.FilePermission "C:\\jakarta-tomcat-4.1.18\\webapps\\BIOgopher\\-", "read,write,delete";
                permission java.net.SocketPermission "*:1024-65535", "connect,accept,resolve";
                permission java.net.SocketPermission "*:80", "connect,accept,resolve";

          	/***END:BIOgopher permissions******/
          };


================================================================
                6.0 Deployment under Tomcat
================================================================

    +---------------+
    | CATALINA_OPTS |
    +---------------+

    Set the following environment variable:

        CATALINA_OPTS=-Xmx512m

    +---------------+
    | BIOgopher.war |
    +---------------+

    After you have completed the directions described in 
    "4.0 Compiling the Source", the package directory will 
    contain the new .war file that can be installed under your 
    instance of Tomcat, as per the information supplied in the 
    build.properties file. 

    Copy 

        [your_temp_dir]/package/BIOgopher.war 

    into 
   
        [your_tomcat_home]/webapps.

    +-----------------+
    | Starting Tomcat |
    +-----------------+

    As mentioned in "5.0 Tomcat Modifications", Tomcat MUST be 
    started using the security manager. Thus, Tomcat must be 
    started with the -security option. 

    Open a command prompt, and change to the bin directory of 
    Tomcat. For example:

         cd c:\jakarta-tomcat-4.1.18\bin

    Launch Tomcat by typing 

         startup -security

    Open a browser, and enter the following and press enter:

         http://localhost:8080/BIOgopher

================================================================
                          7.0 Support 
================================================================

    Please contact the NCICB application support team if you 
    have any specific questions, problems, or suggestions. 
    Telephone support is available Monday to Friday, 9 am - 5 pm 
    Eastern Time, excluding government holidays. You may leave a 
    message, send an email, or submit a support request via the 
    Web at any time.

         - http://ncicbsupport.nci.nih.gov/sw/
         - Telephone: 301-451-4384 (or toll-free: 888-478-4423)
         - Email: ncicb@pop.nci.nih.gov 

    When submitting support requests via email, please include
    the application name and specific problem/question in the 
    subject line of your email. 

================================================================
                          8.0 License
================================================================
    
    BIOgopher version 2.0 software is licensed under the terms
    contained in the file named "caBIOLicense.txt", which can 
    be found online at:
    
        - http://ncicb.nci.nih.gov/core/caBIO/
          technical_resources/core_jar/license
    
    Apache SOAP, Crimson, Xerces, and Xalan are part of Apache
    XML project, Tomcat, ORO, and Lucene are part of Apache
    Jakarta project. All aforementioned Apache projects are
    trademarks of The Apache Software Foundation. For further
    open source licensing issues pertaining to Apache Software
    Foundation, visit:
    
        - http://www.apache.org/LICENSE 
    
    Sun, Sun Microsystems, Solaris, Java, JavaServer Web
    Development Kit, and JavaServer Pages are trademarks or
    registered trademarks of Sun Microsystems, Inc. The jaxp.jar
    and jaxb-rt-1.0-ea.jar are redistributed as whole binary
    jars and are subject to the Sun license terms as stated in
    
        - http://java.sun.com/xml/docs/summer02/LICENSE.html
    
    UNIX is a registered trademark in the United States and
    other countries, exclusively licensed through X/Open
    Company, Ltd.
    
    Windows, WindowsNT, and Win32 are registered trademarks of
    Microsoft Corp. 
    
    All other product names mentioned herein and throughout the
    entire caBIO project are trademarks of their respective
    owners.
    
    
//end
