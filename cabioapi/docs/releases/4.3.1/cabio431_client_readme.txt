
                           caBIO API
                          Version 4.3.1

                         November 2009

================================================================
                            Contents
================================================================

    1.0 Introduction
    2.0 Required Software
          2.1 Java 2 Platform
          2.2 Apache Ant
    3.0 Example Programs
    4.0 License


================================================================
                        1.0 Introduction
================================================================

The caBIO Java API distribution consists of the cabio43*.jar 
files, required library files, demo programs and an Ant build 
script.


================================================================
                     2.0 Required Software 
================================================================
    
----------------------------------------------------------------
2.1 Java 2 Platform (required)
----------------------------------------------------------------

    Java 2 Platform Enterprise Edition (J2EE) or Standard
    Edition (J2SE) is required to compile and run caBIO. 
    J2SDK jdk1.5.0.08 or later version is required. You can 
    download the JDK from Sun Microsystems, Inc. at the 
    following locations:

        http://java.sun.com/j2ee/
        http://java.sun.com/j2se/

----------------------------------------------------------------
2.2 Apache Ant
----------------------------------------------------------------

    To successfully run the TestClient program using the enclosed 
    build file you will need to have Apache Ant installed. The 
    program has been tested with Ant-1.6.5.

    Ant is an open source compile tool available at:
        http://ant.apache.org/


================================================================
                     3.0 Example Programs
================================================================
 
    To run the demos, type "ant -projecthelp" for a list of 
    possible targets. For example, type "ant rundemo" to run all 
    of the examples in the caBIO Technical Guide.

    To use the Java API in your own program, please ensure that 
    your CLASSPATH contains all of the jar files in the lib/ 
    directory as well as the conf/ directory itself.


================================================================
                         4.0 License
================================================================

    The caBIO version 4.3.1 software is licensed under the terms
    contained in the license located at:
    
        http://ncicb.nci.nih.gov/download/cabiolicenseagreement.jsp

    This product includes software developed by the
    Apache Software Foundation (http://www.apache.org/).

    - Apache SOAP, Crimson, Xerces, and Xalan are part of the 
      Apache XML project.

    - Tomcat, ORO, and Lucene are part of the Apache Jakarta 
      project. 

    All aforementioned Apache projects are trademarks of the 
    Apache Software Foundation. For further open source 
    licensing issues pertaining to the Apache Software 
    Foundation, visit:

        http://www.apache.org/LICENSE 

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
    entire caCORE project are trademarks of their respective 
    owners.

    Hibernate is Free Software. The LGPL license is sufficiently 
    flexible to allow the use of Hibernate in both open source 
    and commercial projects.

        http://www.gnu.org/copyleft/lesser.html

    This product includes software developed by Castor 
    (http://www.castor.org), which is licensed under the Exolab 
    license:

        http://www.castor.org/license.html

    The caBIO dataset includes the results of queries to the 
    100K mapping array annotations in the NetAffx(tm) Analysis 
    Center of Affymetrix, Inc. ("Affymetrix").  Use of these 
    annotations are subject to the Affymetrix terms and 
    conditions concerning the use of content obtained from the 
    NetAffx(tm) Analysis Center, which are found at 
    http://www.affymetrix.com/site/terms.affx.

//end