package gov.nih.nci.caBIOApp.report;

public interface Row {

    public Cell createCell(String s);

    public void addCell(Cell c);

    public void addCells(Cell[] l);

    public void setCells(Cell[] l);

    public Cell[] getCells();

    public int getNumCells();

}