package gov.nih.nci.caBIOApp.report;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;

public class SpreadsheetParserImpl implements SpreadsheetParser {

    public Spreadsheet parseExcelSpreadsheet(InputStream in, int worksheetNum)
            throws IndexOutOfBoundsException, IOException {
        return new HSSFExcelSpreadsheet(new HSSFWorkbook(in), worksheetNum);
    }

    public Spreadsheet parseDelimitedFile(InputStream in, String delimiter)
            throws Exception {
        return null;
    }

    public static void main(String[] args) {

        String usage = "Usage: <arg> <filename> [delimiter]\n"
                + "\tArgs: -e = excel file, -d = delimited file";

        if (args.length < 2 || args.length > 3) {
            System.out.println(usage);
            System.exit(1);
        }

        if ("-e".equals(args[0])) {
            System.out.println("\n\nCreating new spreadsheet:");
            Spreadsheet s = new HSSFExcelSpreadsheet();
            for (int i = 0; i < 10; i++) {

                Row r = s.createRow();
                for (int j = 0; j < 10; j++) {

                    r.createCell(Integer.toString(i) + Integer.toString(j));

                }

            }
            try {
                OutputStream out = new FileOutputStream("toaddto-" + args[1]);
                s.write(out);
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }

            Spreadsheet orig = null;
            try {
                SpreadsheetParser p = new SpreadsheetParserImpl();
                orig = p.parseExcelSpreadsheet(new FileInputStream(args[1]), 0);
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }

            System.out.println("s.getRows() = " + s.getRows().length);

            orig.addRows(s.getRows());
            try {
                OutputStream out = new FileOutputStream("modified-" + args[1]);
                orig.write(out);
            }
            catch (Exception ex) {
                ex.printStackTrace();
            }

        }
        else if ("-t".equals(args[0])) {

        }
        else {
            System.out.println(usage);
            System.exit(1);
        }
        System.exit(0);
    }

}
