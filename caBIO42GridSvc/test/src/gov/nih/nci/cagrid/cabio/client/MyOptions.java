package gov.nih.nci.cagrid.cabio.client;

import org.kohsuke.args4j.Option;
import org.kohsuke.args4j.Argument;
import java.util.List;
import java.util.ArrayList;

public class MyOptions {    
    @Option(name="-url",usage="caDSR Data Service URL")
    public String caDsrServiceURL = null;

	@Option(name="-n",usage="Project Short name")
    public String projectName;

    @Option(name="-v",usage="Project Version")
    public String projectVersion;

    @Option(name="-beanfile", usage="Bean File Name")        // no usage
    public String beanFileName = "cabio42-beans.jar";
        
}
