/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.report;

import java.io.IOException;
import java.io.InputStream;

public class ExcelParser implements TableParser {

    Integer _sheetNum = null;
    Integer _headerRowNum = null;
    Integer _dataStartRowNum = null;

    public ExcelParser(Integer sheetNum, Integer headerRowNum,
            Integer dataStartRowNum) {
        _sheetNum = sheetNum;
        _headerRowNum = headerRowNum;
        _dataStartRowNum = dataStartRowNum;
    }

    public Table parse(InputStream in) throws IndexOutOfBoundsException,
            IOException {
        // MessageLog.printInfo( "ExcelParser.parse()" );
        // MessageLog.printInfo( "parse: _headerRowNum = " + _headerRowNum );
        Table table = null;
        int numRows = -1;
        int numCols = -1;

        SpreadsheetParser parser = new SpreadsheetParserImpl();
        if (_sheetNum == null) {
            _sheetNum = new Integer(0);
        }

        Spreadsheet sheet = parser.parseExcelSpreadsheet(in,
            _sheetNum.intValue());

        Row[] rows = sheet.getRows();

        if (rows.length > 0) {
            // MessageLog.printInfo( "Num Rows: " + rows.length );
            numRows = rows.length;
            Cell[] headers = null;
            if (_headerRowNum == null) {
                headers = new Cell[0];
            }
            else if (_headerRowNum.intValue() > -1
                    && _headerRowNum.intValue() < numRows) {
                headers = rows[_headerRowNum.intValue()].getCells();
            }
            else {
                throw new IndexOutOfBoundsException("Header row number "
                        + (_headerRowNum.intValue() + 1) + " is out of range");
            }
            if (_dataStartRowNum == null) {
                _dataStartRowNum = new Integer(0);
            }
            else if (_dataStartRowNum.intValue() < 0
                    || _dataStartRowNum.intValue() >= numRows) {
                throw new IndexOutOfBoundsException("Data start row number "
                        + (_dataStartRowNum.intValue() + 1)
                        + " is out of range");
            }
            int offset = _dataStartRowNum.intValue();
            table = new CaBIOTable();
            for (int i = 0; i < headers.length; i++) {
                String val = null;
                try {
                    val = (String) headers[i].getCellValue();
                }
                catch (Exception ex) {
                    throw new RuntimeException(
                            "Error getting header value at [" + _headerRowNum
                                    + "," + i + "]: " + ex.getMessage());
                }
                // MessageLog.printInfo( "Header: " + val );
                table.addColumn(val);
            }
            numCols = getColCount(rows);
            table.setColumnCount(numCols);
            table.setRowCount(numRows - offset);

            for (int row = offset; row < numRows; row++) {
                Row r = rows[row];
                Cell[] cells = null;
                if (r != null) {
                    cells = r.getCells();
                }
                for (int col = 0; col < numCols; col++) {
                    if (r != null) {
                        try {
                            if (col < cells.length) {
                                table.setStringValueAt(
                                    (String) cells[col].getCellValue(), row
                                            - offset, col);
                            }
                            else {
                                // there's nothing in this column
                                table.setStringValueAt("", row - offset, col);
                            }
                        }
                        catch (IllegalStateException ex) {
                            throw new RuntimeException(
                                    "Error setting string value at ["
                                            + (row - offset) + "," + col
                                            + "]: " + ex.getMessage());
                        }
                    }
                    else {// row is empty
                        table.setStringValueAt("", row - offset, col);
                    }
                }
            }

        }

        return table;
    }

    private int getColCount(Row[] rows) {
        int colCount = 0;
        for (int i = 0; i < rows.length; i++) {
            Row r = rows[i];
            if (r != null) {
                colCount = r.getNumCells();
                break;
            }
        }
        return colCount;
    }
}
