package gov.nih.nci.caBIOApp.report;

import gov.nih.nci.caBIOApp.util.MessageLog;

import java.util.Iterator;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;

public class HSSFExcelRow implements Row {

    protected HSSFRow _row = null;

    HSSFExcelRow(HSSFRow r) {
        if (r == null) {
            throw new IllegalArgumentException("row is null");
        }
        _row = r;
    }

    protected HSSFRow getRow() {
        return _row;
    }

    public Cell createCell(String s) {
        if (_row == null) {
            throw new IllegalStateException("row has not been set");
        }
        int numCells = getNumCells();
        short newCellNum = (short) (numCells);
        MessageLog.printInfo("HSSFExcelRow.createCell(): newCellNum = "
                + newCellNum);
        HSSFCell hc = _row.createCell(newCellNum);
        hc.setCellValue(s);
        return new HSSFExcelCell(hc);
    }

    Cell createCell(int idx, String s) {
        HSSFCell hc = _row.createCell((short) idx);
        hc.setCellValue(s);
        return new HSSFExcelCell(hc);
    }

    public void addCell(Cell c) {
        if (_row == null) {
            throw new IllegalStateException("row has not been set");
        }
        int numCells = getNumCells();
        short newCellNum = (short) (numCells);
        HSSFCell hc = _row.createCell(newCellNum);
        hc.setCellValue((String) c.getCellValue());
    }

    public void addCells(Cell[] l) {
        if (_row == null) {
            throw new IllegalStateException("row has not been set");
        }
        for (int i = 0; i < l.length; i++) {
            addCell(l[i]);
        }
    }

    public void setCells(Cell[] l) {
        if (_row == null) {
            throw new IllegalStateException("row has not been set");
        }
        for (Iterator i = _row.cellIterator(); i.hasNext();) {
            _row.removeCell((HSSFCell) i.next());
        }
        addCells(l);
    }

    public Cell[] getCells() {
        if (_row == null) {
            throw new IllegalStateException("row has not been set");
        }
        int numCells = getNumCells();
        Cell[] cells = new Cell[numCells];
        for (int i = 0; i < numCells; i++) {
            cells[i] = new HSSFExcelCell(_row.getCell((short) i));
        }
        return cells;
    }

    public int getNumCells() {
        int numCells = 0;
        if (_row.getPhysicalNumberOfCells() == 0) {
            numCells = 0;
        }
        else {
            // numCells = _row.getLastCellNum() + 1; <- wrong, because
            // getLastCellNum is 1-based.
            numCells = _row.getLastCellNum();
        }
        return numCells;
    }

}
