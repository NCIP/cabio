package gov.nih.nci.caBIOApp.report;

import gov.nih.nci.caBIOApp.util.MessageLog;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

public class ExcelFormatter implements TableFormatter {

    public byte[] format(Table table) throws IOException {
        HSSFExcelSpreadsheet sheet = new HSSFExcelSpreadsheet();
        int numRows = table.getRowCount();
        int numCols = table.getColumnCount();
        MessageLog.printInfo("ExcelFormatter.format(): numRows = " + numRows
                + ", numCols = " + numCols);
        Row header = sheet.createRow();
        for (int colIdx = 0; colIdx < numCols; colIdx++) {
            ((HSSFExcelRow) header).createCell(colIdx,
                table.getColumnName(colIdx));
        }
        for (int rowIdx = 0; rowIdx < numRows; rowIdx++) {
            Row row = sheet.createRow();
            for (int colIdx = 0; colIdx < numCols; colIdx++) {
                ((HSSFExcelRow) row).createCell(colIdx, table.getStringValueAt(
                    rowIdx, colIdx));
            }
        }

        ByteArrayOutputStream out = new ByteArrayOutputStream();
        sheet.write(out);

        return out.toByteArray();
    }
}
