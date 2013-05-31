/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.util;

import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.PrintStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class AppConfig {

    private static AppConfig _instance = null;
    private String _spreadsheetParserClassname = null;
    private String _exportDir = null;
    private String _sodFactClassname = null;
    private List _actionParams = new ArrayList();
    private HashMap _managerDir = null;
    //private List _ontologyClassnames = new ArrayList();
    private List _ontInfo = new ArrayList();
    private Integer _maxMatrixSize = null;

    /* 
    static{
      try{
        _instance = new AppConfig();
      }catch( Exception ex ){
        MessageLog.printStackTrace( ex );
      }
    }
    */
    private AppConfig() throws ConfigurationException {
        init();
    }

    private void init() throws ConfigurationException {
        System.out.println("AppConfig.init()");
        try {
            Config config = unmarshalConfig();
            LoggerInfo li = config.getLoggerInfo();
            setupLogger(li);
            SpreadsheetParserInfo spi = config.getSpreadsheetParserInfo();
            setSpreadsheetParserClassname(spi.getClassname());
            SODFactoryInfo sfi = config.getSODFactoryInfo();
            setSODFactoryClassname(sfi.getClassname());
            ActionConfigInfo aci = config.getActionConfigInfo();
            List apis = aci.getActionParamsInfo();
            for (Iterator i = apis.iterator(); i.hasNext();) {
                ActionParamsInfo api = (ActionParamsInfo) i.next();
                ActionParams ap = new ActionParams();
                ap.setPath(api.getPath());
                List params = api.getParams();
                for (Iterator j = params.iterator(); j.hasNext();) {
                    Param param = (Param) j.next();
                    ap.addParam(param.getName(), param.getValue());
                }
                addActionParams(ap);
            }
            /*
            List ois = config.getOntologyInfo();
            for( Iterator i = ois.iterator(); i.hasNext(); ){
              _ontologyClassnames.add( ((OntologyInfo)i.next()).getClassname() );
            }
            */
            _ontInfo = config.getOntologyInfo();
            _maxMatrixSize = new Integer(config.getMatrixInfo().getMaxSize());
        }
        catch (Exception ex) {
            throw new ConfigurationException("Error configuring.", ex);
        }
    }

    public static AppConfig getInstance() throws ConfigurationException {
        if (_instance == null) {
            _instance = new AppConfig();
        }
        return _instance;
    }

    /*
      public void setupLogger( String info, String warning, String error, boolean verbose )
    throws FileNotFoundException, SecurityException
      {
    MessageLog.setInfoStream( new PrintStream(new FileOutputStream(info)) );
    MessageLog.setWarningStream( new PrintStream(new FileOutputStream(warning)) );
    MessageLog.setErrorStream( new PrintStream(new FileOutputStream(error)) );
    MessageLog.setVerboseOn( verbose );
    MessageLog.printInfo( "Logging Initialized.", true );
      }
    */
    public void setupLogger(LoggerInfo li) throws FileNotFoundException,
            SecurityException {
        String infoLogFileName = li.getInfo();
        String warningLogFileName = li.getWarning();
        String errorLogFileName = li.getError();
        boolean verbose = li.getVerbose();
        if (verbose) {
            if (infoLogFileName != null && !"off".equals(infoLogFileName)) {
                MessageLog.setInfoOn(true);
                MessageLog.setInfoStream(new PrintStream(new FileOutputStream(
                        infoLogFileName)));
                MessageLog.printInfo("initialized");
            }
            else {
                MessageLog.setInfoOn(false);
            }
            if (warningLogFileName != null && !"off".equals(warningLogFileName)) {
                MessageLog.setWarningOn(true);
                MessageLog.setWarningStream(new PrintStream(
                        new FileOutputStream(warningLogFileName)));
                MessageLog.printWarning("initialized");
            }
            else {
                MessageLog.setWarningOn(false);
            }
            if (errorLogFileName != null && !"off".equals(errorLogFileName)) {
                MessageLog.setErrorOn(true);
                MessageLog.setErrorStream(new PrintStream(new FileOutputStream(
                        errorLogFileName)));
                MessageLog.printError("initialized");
            }
            else {
                MessageLog.setErrorOn(false);
            }
        }
    }

    public void setSpreadsheetParserClassname(String s) {
        _spreadsheetParserClassname = s;
    }

    public String getSpreadsheetParserClassname() {
        return _spreadsheetParserClassname;
    }

    public void setExportDir(String s) {
        _exportDir = s;
    }

    public String getExportDir() {
        return _exportDir;
    }

    public void setSODFactoryClassname(String s) {
        //MessageLog.printInfo( "Setting _sodFactClassname to: " + s );
        _sodFactClassname = s;
    }

    public String getSODFactoryClassname() {
        //MessageLog.printInfo( "Returning _sodFactClassname: " + _sodFactClassname );
        return _sodFactClassname;
    }

    public void addActionParams(ActionParams param) {
        _actionParams.add(param);
    }

    public ActionParams getActionParams(String path) {
        ActionParams a = null;
        for (Iterator i = _actionParams.iterator(); i.hasNext();) {
            ActionParams ap = (ActionParams) i.next();
            String p = ap.getPath();
            /*
            MessageLog.printInfo( "Looking for: " + path +
            	    ", compared to: " + p );
            */
            if (path.equals(p)) {
                a = ap;
                break;
            }
        }
        return a;
    }

    private Config unmarshalConfig() throws ConfigurationException {
        Config config = null;
        String filename = System.getProperty("gov.nih.nci.caBIOApp.config.filename");
        if (filename == null) filename = "webapp-config.xml";
        ClassLoader cl = this.getClass().getClassLoader();
        InputStream in = cl.getResourceAsStream(filename);
        try {
            config = new Config();
            config = config.unmarshal(in);
        }
        catch (Exception ex) {
            throw new ConfigurationException("Error unmarshalling " + "Config",
                    ex);
        }
        finally {
            if (in != null) {
                try {
                    in.close();
                }
                catch (Exception ex) {
                    MessageLog.printStackTrace(ex);
                }
            }
        }
        return config;
    }

    /*
    public List getOntologyClassnames(){
      return _ontologyClassnames;
    }
    */
    public List getOntologyInfo() {
        return _ontInfo;
    }

    public Integer getMaxMatrixSize() {
        return _maxMatrixSize;
    }
}
