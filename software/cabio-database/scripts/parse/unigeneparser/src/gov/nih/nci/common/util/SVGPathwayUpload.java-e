/**
 * Created on Jan 27, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package gov.nih.nci.common.util;
import java.io.*;
import java.io.FileInputStream;
import java.io.IOException;
import java.sql.*;
import java.util.*;
import java.util.Date;
import java.text.*;
/**
 * @author LeThai
 *
 */
public class SVGPathwayUpload {

    /**
     * @param args
     */
private String SVGPath;

    public  SVGPathwayUpload(String path)
    {
        SVGPath = path;
    }

    public void connectToOracleDB(String connectionUrl, String username, String password)
    {
        Connection conn = null;
        int count=0;
        try {
            // Load the JDBC driver

            String driverName = "oracle.jdbc.driver.OracleDriver";
            Class.forName(driverName).newInstance();

	    Properties props = new Properties();
	    props.put("user",username);
	    props.put("password",password);
	    props.put("SetBigStringTryClob", "true");
//
            conn = DriverManager.getConnection(connectionUrl, props);
            System.out.println("I'm ready");

            String st = "select * FROM bio_pathways_TV where pathway_id = 116";
            Statement stmt;
            ResultSet rset;
            stmt = conn.createStatement();
            rset = stmt.executeQuery(st);
            conn.setAutoCommit(false);


            StringBuilder sb;
            System.out.println("resultSet: " + rset);
            while(rset.next())
            {
                String pathway_diagram = rset.getString("PATHWAY_DIAGRAM_NAME");

                if(pathway_diagram != null)
                {
                    int pathway_id = rset.getInt("PATHWAY_ID");
                    sb = readSVGFile(pathway_diagram);

                   // System.out.println("trying to create clob: " );
                  //  oracle.sql.CLOB newClob = oracle.sql.CLOB.createTemporary(conn, false, oracle.sql.CLOB.DURATION_SESSION);

                    // int rc = newClob.setString(1, sb.toString());
                    //System.out.println("number of character written to clob: " + rc);
                    PreparedStatement prepareInsert= null;

                    try {

                        prepareInsert = conn.prepareStatement(
                        "UPDATE BIO_PATHWAYS_TV SET PATHWAY_DIAGRAM = ? WHERE PATHWAY_ID = ? AND PATHWAY_DIAGRAM_NAME = ?");

                        prepareInsert.setString(1, sb.toString());
                        prepareInsert.setInt(2, pathway_id);
                        prepareInsert.setString(3, pathway_diagram);

                        System.out.println("prepareInsert " + prepareInsert.toString());

                        prepareInsert.executeUpdate();
                       // newClob.freeTemporary();

                    }
                    catch(Exception e){
                        System.out.println(e.getMessage());

                    }
                    finally
                    {
                        prepareInsert.close();

                    }

                    count++;
                    // this is for testing only
                    //if (count == 3) break;
                }
            }
            System.out.println(count);
        } catch (Exception e) {
            // Could not connect to the database
            System.out.println(e.getMessage());
        }
        finally
        {
            try{
                conn.commit();
                conn.close();
                System.out.println("count = " + count);
            }
            catch(Exception e)
            {
                System.out.println("Unable to close DB Connection.");
                e.printStackTrace();
            }
        }
    }

    public StringBuilder readSVGFile(String fileName)
    {
        String filePath = SVGPath;
        String s="";
        StringBuilder sb = new StringBuilder();
        try
        {
            InputStreamReader in = new InputStreamReader(new FileInputStream(filePath + fileName));
            BufferedReader d  = new BufferedReader(in);

            int pos =0, pos2=0;
            String xmlnamespace = "xmlns=" + "\"http://www.w3.org/2000/svg\" xmlns:xlink=\"http://www.w3.org/1999/xlink\"";


            while((s = d.readLine() ) != null)
            {
                pos = s.indexOf("<svg");
                if (pos >= 0)
                {
                    pos2 = s.indexOf(">");

                    if(pos2 > 0)
                    {
                        //System.out.println("old string: " + s);
                        s = s.substring(0, pos2 ) + " " + xmlnamespace + ">";
                        System.out.println("new string: " +s);
                    }

                }
                sb.append(s);
                sb.append("\n");
            }
            d.close();
        }
        catch (IOException e)
        {
            System.out.println("Unable to read data from file.");
            e.printStackTrace();
        }
        //System.out.println(sb);
        return sb;

    }





    public static void main(String[] args) {
        // TODO Auto-generated method stub

        SVGPathwayUpload db = new SVGPathwayUpload("/cabio/cabiodb/cabio42/scripts/parse/unigeneparser/src/gov/nih/nci/common/util/");
        String serverName = "cbdb-q1001.nci.nih.gov";
        String portNumber = "1521";
        String sid = "BIOQA"; //STAGE
        String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
        String username = "CABIOREFRESH";
        String password = "";
        db.connectToOracleDB(url, username, password);
       // Create a connection to the database

        /*--- stage database --*/
        /*String serverName = "cbiodb20.nci.nih.gov";
        String portNumber = "1521";
        String sid = "CBSTG"; //STAGE
        String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
        String username = "CABIOSTAGE";
        String password = "";


        /*--- qa database ---*/
        /*String serverName = "cbiodb2-d.nci.nih.gov";
        String portNumber = "1521";
        String sid = "CBTEST"; //qa
        String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
        String username = "CABIOQA";
        String password = "";
        */

        /*--- dev database ---*/
        /*String serverName = "cbiodb2-d.nci.nih.gov";
        String portNumber = "1521";
        String sid = "CBDEV9"; //development
        String url = "jdbc:oracle:thin:@" + serverName + ":" + portNumber + ":" + sid;
        String username = "CABIODEV9";
        String password = "";
        */

    }

}
