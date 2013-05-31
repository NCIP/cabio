/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.report;

import gov.nih.nci.caBIO.search.Datasource;

import java.util.*;
import java.util.Vector;
import javax.swing.table.DefaultTableModel;

public class CaBIOTable extends DefaultTableModel implements Table, Datasource {

    private String _name = null;

    public CaBIOTable() {
        super();
    }

    public CaBIOTable(List data, List columnNames) {
        super(new Vector(data), new Vector(columnNames));
    }

    public CaBIOTable(int numRows, int numColumns) {
        super(numRows, numColumns);
    }

    public void setName(String name) {
        _name = name;
    }

    public String getName() {
        return _name;
    }

    public void setStringValueAt(String value, int rowIndex, int columnIndex) {
        setValueAt(value, rowIndex, columnIndex);
    }

    public String getStringValueAt(int rowIndex, int columnIndex) {
        String s = null;
        Object val = getValueAt(rowIndex, columnIndex);
        if (val != null) {
            s = val.toString();
        }
        return s;
    }

    public void addColumn(String columnName) {
        super.addColumn(columnName);
    }

    public void addColumn(String columnName, List columnData) {
        super.addColumn(columnName, new Vector(columnData));
    }

    public void addRow(List rowData) {
        super.addRow(new Vector(rowData));
    }

    public void addRow(Vector rowData) {
        super.addRow(rowData);
    }

    public void insertRow(int rowNum, List rowData) {
        super.insertRow(rowNum, new Vector(rowData));
    }

    public Vector getRowValues(int rowNum) {
        Vector rowContents = new Vector();
        int columnCount = super.getColumnCount();
        for (int i = 0; i < columnCount; i++) {
            rowContents.add(getValueAt(rowNum, i));
        }
        return rowContents;
    }

    public Object clone() {
        int numRows = getRowCount();
        int numColumns = getColumnCount();
        // CaBIOTable table = new CaBIOTable( numRows, numColumns );
        CaBIOTable table = new CaBIOTable();
        for (int i = 0; i < numColumns; i++) {
            table.addColumn(getColumnName(i));
        }
        table.setColumnCount(numColumns);
        table.setRowCount(numRows);
        for (int rowIndex = 0; rowIndex < numRows; rowIndex++) {
            for (int columnIndex = 0; columnIndex < numColumns; columnIndex++) {
                table.setStringValueAt(new String(getStringValueAt(rowIndex,
                    columnIndex)), rowIndex, columnIndex);
            }
        }
        return table;
    }

    public String toString() {
        StringBuffer myStringBuffer = new StringBuffer();
        int rowCount = this.getRowCount();
        // System.out.println("Number of rows in the FinalTable: " + rowCount +
        // "\n");
        int columnCount = this.getColumnCount();
        // System.out.println("Number of columns in the FinalTable: " +
        // columnCount + "\n");
        for (int i = 0; i < rowCount; i++) {
            for (int j = 0; j < columnCount; j++) {
                myStringBuffer.append(this.getValueAt(i, j));
                myStringBuffer.append("\t");
            }
            myStringBuffer.append("\n");
        }
        return myStringBuffer.toString();
    }
}
