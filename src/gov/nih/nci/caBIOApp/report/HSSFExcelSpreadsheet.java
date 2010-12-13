package gov.nih.nci.caBIOApp.report;

import java.util.*;
import java.io.*;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.poifs.filesystem.*;

public class HSSFExcelSpreadsheet implements Spreadsheet{

  protected HSSFWorkbook _workbook = null;
  protected HSSFSheet _sheet = null;
  protected String _name = null;

  HSSFExcelSpreadsheet(){
    _workbook = new HSSFWorkbook();
    _sheet = _workbook.createSheet();
  }

  HSSFExcelSpreadsheet( HSSFWorkbook wb, int worksheetNum )  
    throws IndexOutOfBoundsException
  {
    _workbook = wb;
    int numSheets = wb.getNumberOfSheets();
    if( worksheetNum < 0 || worksheetNum >= numSheets ){
      throw new IndexOutOfBoundsException( "No worksheet at index " + ( worksheetNum + 1 ) );
    } 
    _sheet = wb.getSheetAt( worksheetNum );
  }

  protected HSSFWorkbook getWorkbook(){
    return _workbook;
  }

  protected HSSFSheet getSpreadsheet(){
    return _sheet;
  }

  public Row createRow(){
    if( _sheet == null ){
      throw new IllegalStateException( "spreadsheet has not been set" );
    }
    int numRows = getNumRows();
    short newRowNum = (short)( numRows );
    HSSFRow hr = _sheet.createRow( newRowNum );
    return new HSSFExcelRow( hr );
  }

  public void addRow( Row row ){
    if( _sheet == null ){
      throw new IllegalStateException( "spreadsheet has not been set" );
    }
    int numRows = getNumRows();
    short newRowNum = (short)( numRows );
    HSSFRow hr = _sheet.createRow( newRowNum );
    Row r = new HSSFExcelRow( hr );
    r.addCells( row.getCells() );
  }

  public void addRows( Row[] rows ){
    if( _sheet == null ){
      throw new IllegalStateException( "spreadsheet has not been set" );
    }
    for( int i = 0; i < rows.length; i++ ){
      addRow( rows[i] );
    }
  }

  public void setRows( Row[] rows ){
    if( _sheet == null ){
      throw new IllegalStateException( "spreadsheet has not been set" );
    }
    for( Iterator i = _sheet.rowIterator(); i.hasNext(); ){
      _sheet.removeRow( (HSSFRow)i.next() );
    }
    addRows( rows );
  }

  public Row[] getRows(){
    int numRows = getNumRows();
    Row[] rows = new Row[ numRows ];
    for( int i = 0; i < numRows; i++ ){
      HSSFRow row = _sheet.getRow( (short)i );
      if( row == null ){
	rows[i] = null;
      }else{
	rows[i] = new HSSFExcelRow( row );
      }
    }
    return rows;
  }

  public byte[] getBytes(){
    if( _workbook == null ){
      throw new IllegalStateException( "workbook has not been set" );
    }
    return _workbook.getBytes();
  }

  public void write( OutputStream out )
    throws IOException
  {
    if( _workbook == null ){
      throw new IllegalStateException( "workbook has not been set" );
    }
    _workbook.write( out );
  }

  public void setName( String s ){
    _name = s;
  }
  public String getName(){
    return _name;
  }
  public int getNumRows(){
    int numRows = 0;
    int lastRowNum = _sheet.getLastRowNum();
    int physNumRows = _sheet.getPhysicalNumberOfRows();
    if( physNumRows == 0 ){
      numRows = 0;
    }else{
      numRows = lastRowNum + 1;
    }
    return numRows;
  }
}

