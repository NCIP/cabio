package gov.nih.nci.caBIOApp.report;

import org.apache.poi.hssf.usermodel.HSSFCell;

public class HSSFExcelCell implements Cell {

    protected HSSFCell _cell = null;

    HSSFExcelCell(HSSFCell c) {
        _cell = c;
    }

    protected HSSFCell getCell() {
        return _cell;
    }

    public void setCellValue(Object s) {
        if (_cell == null) {
            throw new IllegalStateException("cell has not been set");
        }

        _cell.setCellValue(s.toString());

    }// end setCellValue( String s )

    public Object getCellValue() {
        /*
         * if( _cell == null ){ throw new IllegalStateException(
         * "cell has not been set" ); }
         */
        String val = null;
        if (_cell != null) {
            int cellType = _cell.getCellType();

            switch (cellType) {

            case HSSFCell.CELL_TYPE_BLANK:
                // Do nothing
                break;
            case HSSFCell.CELL_TYPE_BOOLEAN:
                if (_cell.getBooleanCellValue()) {
                    val = "true";
                }
                else {
                    val = "false";
                }
                break;
            case HSSFCell.CELL_TYPE_NUMERIC:
                double d = _cell.getNumericCellValue();
                if (d - (long) d > 0) {
                    val = Double.toString(d);
                }
                else {
                    val = Long.toString((long) d);
                }
                break;
            case HSSFCell.CELL_TYPE_STRING:
                val = _cell.getStringCellValue();
                break;
            default:
                throw new IllegalStateException("unknow cell type: " + cellType);

            }// -- end switch( cellType )
        }
        else {
            val = "";
        }
        return val;
    }// -- end getCellValue()

}// -- end HSSFExcelCell

