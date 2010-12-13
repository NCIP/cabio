package gov.nih.nci.caBIOApp.report;
import java.io.*;
import java.util.*;
import java.net.*;

public class TableCell implements Cell {
	private Object cellValue;
	
	public void setCellValue(Object s){
	   cellValue = s;
	}
	
    public Object getCellValue() {
	   return cellValue;
	}
	
	public String toString() {
	   String cellV = (String)this.cellValue;
	   return cellV;
	}
}
