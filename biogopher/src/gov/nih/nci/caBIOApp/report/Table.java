package gov.nih.nci.caBIOApp.report;

import java.util.List;
import java.util.Vector;

public interface Table extends Cloneable {

    public void setName(String s);

    public String getName();

    public int getColumnCount();

    public String getColumnName(int columnIndex);

    public int getRowCount();

    public Vector getRowValues(int rowNum);

    public String getStringValueAt(int rowIndex, int columnIndex);

    public void setStringValueAt(String value, int rowIndex, int columnIndex);

    public void addColumn(String columnName);

    public void addColumn(String columnName, List columnData);

    public void addRow(List rowData);

    public void insertRow(int rowNum, List rowData);

    public void moveRow(int startIndex, int endIndex, int toIndex);

    public void removeRow(int rowIndex);

    public Object clone();

    public void setColumnCount(int i);

    public void setRowCount(int i);
}
