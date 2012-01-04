import java.io.*;
import java.sql.*;
import java.util.*;

public class ReadDBSNP {

   public static void main(String[] args){

      //String dir = "Y:\\qili\\dbsnp\\in\\";

      String in_dir = args[0];
      String out_dir = args[1];
      String db_host = args[2];
      String db_port = args[3];
      String db_name = args[4];
      String username = args[5];
      String password = args[6];
      String[] infiles = new String[24];
      infiles[0] = "ds_flat_ch1.flat";
      infiles[1] = "ds_flat_ch2.flat";
      infiles[2] = "ds_flat_ch3.flat";
      infiles[3] = "ds_flat_ch4.flat";
      infiles[4] = "ds_flat_ch5.flat";
      infiles[5] = "ds_flat_ch6.flat";
      infiles[6] = "ds_flat_ch7.flat";
      infiles[7] = "ds_flat_ch8.flat";
      infiles[8] = "ds_flat_ch9.flat";
      infiles[9] = "ds_flat_ch10.flat";
      infiles[10] = "ds_flat_ch11.flat";
      infiles[11] = "ds_flat_ch12.flat";
      infiles[12] = "ds_flat_ch13.flat";
      infiles[13] = "ds_flat_ch14.flat";
      infiles[14] = "ds_flat_ch15.flat";
      infiles[15] = "ds_flat_ch16.flat";
      infiles[16] = "ds_flat_ch17.flat";
      infiles[17] = "ds_flat_ch18.flat";
      infiles[18] = "ds_flat_ch19.flat";
      infiles[19] = "ds_flat_ch20.flat";
      infiles[20] = "ds_flat_ch21.flat";
      infiles[21] = "ds_flat_ch22.flat";
      infiles[22] = "ds_flat_chX.flat";
      infiles[23] = "ds_flat_chY.flat";


      String input = "/cabio/cabiodb/cabio_data/NCBI_SNP/ds_flat_ch1.flat";
      String out = out_dir + File.separator + "snp.txt";
      String out2 = out_dir + File.separator  + "allele.txt";
      String out3 = out_dir + File.separator  + "location.txt";
      BufferedReader reader=null;
      PrintWriter pw = null;
      PrintWriter pw2 = null;
      PrintWriter pw3 = null;
      try{
          HashMap<String, String> chromosomeId = getChromosomeId(db_host, db_port, db_name, username, password);
           pw = new PrintWriter(new FileWriter(out));
           pw2 = new PrintWriter(new FileWriter(out2));
           pw3 = new PrintWriter(new FileWriter(out3));
          String line = null;
          int seq=10000000;
          String rsnumber = null; 
          String type = null; 
          String validated = null;

          for(int j = 0; j < infiles.length; j++){ 
          reader = new BufferedReader(new FileReader(in_dir + File.separator + infiles[j]));
          while((line = reader.readLine()) != null){
             line = line.trim();
    
             if(line.length() == 0)
               continue;
             
               if(line.startsWith("rs")){
                  if(seq != 10000000)
                  if(type.equals("snp"))
                  pw.println(seq + "%" + rsnumber + "%" + type + "%" + validated + "%" + "gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism");
                  else
                  pw.println(seq + "%" + rsnumber + "%" + type + "%" + validated + "%" + "gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation");
                  
                  seq++;
                  String[] str = line.split("\\|");

                  rsnumber = str[0].trim(); 
                  type = str[3].trim(); 
             
             }

             if(line.startsWith("SNP")){
                String[] str = line.split("\\|");
                String alleles = str[1].trim();

                int first = alleles.indexOf("'");
                int last = alleles.lastIndexOf("'");

                alleles = alleles.substring(first +1, last);

                String[] allele = alleles.split("/");


                for(int i = 0; i < allele.length; i++){
                  pw2.println(seq + "%" + allele[i]);

                }
               

             }


              if(line.startsWith("VAL")){

                String[] str = line.split("\\|");
                validated = str[1].trim();

                int index = validated.indexOf("=");
                validated = validated.substring(index+1);

                if(validated.equals("YES"))
                    validated = "1";
                else
                    validated = "0";


              }


               if(line.startsWith("CTG")){

                    String[] str = line.split("\\|");
                    String assembly = str[1].trim();
                    int index = assembly.indexOf("=");
                    assembly = assembly.substring(index +1);

                    String chromosome = str[2].trim();

                    index = chromosome.indexOf("=");
                    
                    chromosome = chromosome.substring(index + 1);

                    String chr_start = str[3].trim();

                    index = chr_start.indexOf("=");

                    chr_start = chr_start.substring(index + 1);
                    if(chr_start.equals("?"))
                     continue;

                    String ctg_start = str[5].trim();

                    index = ctg_start.indexOf("=");

                    ctg_start = ctg_start.substring(index + 1);
                    
                    String ctg_end = str[6].trim();

                    index = ctg_end.indexOf("=");

                    ctg_end = ctg_end.substring(index + 1);

                    int diff = Integer.parseInt(ctg_end) - Integer.parseInt(ctg_start);

                    int i_chr_end = Integer.parseInt(chr_start) + diff;

                    String chr_end = Integer.toString(i_chr_end);

                     String ori = str[8].trim();

                    index = ori.indexOf("=");

                    ori = ori.substring(index + 1);

                   String key = chromosome + "/" + assembly + "/" + "NCBI37";
                   String chr_id = chromosomeId.get(key);

                   if(chr_id == null) {
                     System.out.println("null chromosomeid, key: " + key);
                     continue; 
                   }

                    pw3.println(seq + "%" + chr_id + "%" + chr_start + "%" + chr_end + "%" + ori);


               }

          }

           reader.close();
          }

               if(type.equals("snp"))
                  pw.println(seq + "%" + rsnumber + "%" + type + "%" + validated + "%" + "gov.nih.nci.maservice.domain.SingleNucleotidePolymorphism");
               else
                  pw.println(seq + "%" + rsnumber + "%" + type + "%" + validated + "%" + "gov.nih.nci.maservice.domain.NucleicAcidSequenceVariation");
      }catch( Exception e){
        e.printStackTrace();
      }finally{
          try{
           if(reader != null)
               reader.close();

          if(pw != null)
              pw.close();


            if(pw2 != null)
              pw2.close();


            if(pw3 != null)
              pw3.close();


        }catch(Exception e2){
        }
      }
   }





   public static HashMap<String, String> getChromosomeId(String host, String port, String db_name, String username, String password) throws Exception{

        //String url="jdbc:oracle:thin:@ncidb-bio-d.nci.nih.gov:1553:BIODEV";
        String url="jdbc:oracle:thin:@" + host + ":" + port + ":" + db_name;
        Connection con = null;

        HashMap <String, String> result = new HashMap<String, String>();
        PreparedStatement stmt=null;
        ResultSet rs = null;


        try{

       
        Class.forName("oracle.jdbc.driver.OracleDriver").newInstance();

        System.out.println("make connection");
        con = DriverManager.getConnection(url, username, password);


       //String  sql = "select name from cytoband";
       String  sql = "select c.name, assembly_source, assembly_version, " +
                     " c.id from ma_chromosome c, ma_genome g " +
                     " where c.genome_id = g.id  and organism_id = 5"; 
                    


       stmt=con.prepareStatement(sql);
      
       rs = stmt.executeQuery();


       while(rs.next()){

        String name = rs.getString(1);
        String assembly_source = rs.getString(2);
        String assembly_version = rs.getString(3);
        int id = rs.getInt(4);

        result.put(name+"/" + assembly_source + "/" + assembly_version, Integer.toString(id));
        

       }

      }catch(Exception e){
         throw e;
      }finally{


       if(stmt != null)
          stmt.close();

       if(rs != null)
          rs.close();
      }

       return result;


   }


}

