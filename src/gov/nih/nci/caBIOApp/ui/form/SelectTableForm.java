package gov.nih.nci.caBIOApp.ui.form;

import gov.nih.nci.caBIOApp.util.*;
import gov.nih.nci.caBIOApp.ui.*;
import gov.nih.nci.caBIOApp.report.*;

import java.util.*;
import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;

import org.apache.struts.action.*;
import org.apache.struts.upload.*;

public class SelectTableForm extends ActionForm{

  private FormFile _uploadedFile = null;
  private List _cachedTables = new ArrayList();
  private Table _selectedTable = null;
  private String _selectedTableName = null;
  private String _worksheetNumber = null;
  private boolean _allowSelection = false;
  private boolean _allowUpload = false;
  private String _headerRowNumber = null;
  private String _dataStartRowNumber = null;

  public void setCachedTables( List l ){
    _cachedTables = l;
  }
  public List getCachedTables(){
    return _cachedTables;
  }
  public void setSelectedTable( Table t ){
    _selectedTable = t;
  }
  public Table getSelectedTable(){
    return _selectedTable;
  }
  public void setSelectedTableName( String s ){
    _selectedTableName = s;
  }
  public String getSelectedTableName(){
    return _selectedTableName;
  }

  public ActionErrors addTable()
    throws ServletException
  {
    MessageLog.printInfo( "addTable: _headerRowNumber = "  + _headerRowNumber );
    ActionErrors errors = new ActionErrors();
    if( _uploadedFile != null ){
      Integer wrkSht = null;
      Integer hdrRow = null;
      Integer datRow = null;
      boolean successful = true;
      try{
	if( _worksheetNumber != null && _worksheetNumber.trim().length() > 0 ){
	  wrkSht = new Integer( Integer.parseInt( _worksheetNumber ) - 1 );
	}
	if( _headerRowNumber != null && _headerRowNumber.trim().length() > 0 ){
	  hdrRow = new Integer( Integer.parseInt( _headerRowNumber ) -1 );
	}
	if( _dataStartRowNumber != null && _dataStartRowNumber.trim().length() > 0 ){
	  datRow = new Integer( Integer.parseInt( _dataStartRowNumber ) -1 );
	}
	MessageLog.printInfo( "wrkSht = " + wrkSht +
			      ", hdrRow = " + hdrRow +
			      ", datRow = " + datRow );
	ExcelParser parser = new ExcelParser( wrkSht, hdrRow, datRow );
	InputStream in = _uploadedFile.getInputStream();
	_uploadedFile.destroy();
	_selectedTable = parser.parse( in );
	MessageLog.printInfo( "AFTER PARSING" );
      }catch( IndexOutOfBoundsException ex ){
	MessageLog.printStackTrace( ex );
	errors.add( "worksheetNumber", new ActionError( "errors.outOfRange", ex.getMessage() ) );
	successful = false;
      }catch( IOException ex ){
	MessageLog.printStackTrace( ex );
	errors.add( "uploadedFile", 
		    new ActionError( "errors.invalidFormat", _uploadedFile.getFileName() ) );
	successful = false;
      }catch( Exception ex ){
	MessageLog.printStackTrace( ex );
	throw new ServletException( "error adding table", ex );
      }
      if( _selectedTable != null ){
	String filename = _uploadedFile.getFileName();
	int dotIdx = filename.lastIndexOf( "." );
	String newName = null;
	if( dotIdx > 0 && dotIdx < filename.length() - 1 ){
	  newName =
	    filename.substring( 0, dotIdx ) +
	    "[" + _worksheetNumber + "]" +
	    filename.substring( dotIdx );
	}else{
	  newName = filename + "[" + _worksheetNumber + "]";
	}
	_selectedTable.setName( newName );
	_cachedTables.add( _selectedTable );
      }else{
	if( successful ){
	  MessageLog.printInfo( "SelectTableForm.addTable(): Empty file." );
	  errors.add( "worksheetNumber", new ActionError( "errors.emptyfile", _worksheetNumber ) );
	}
      }
    }else{
      MessageLog.printWarning( "SelectTableForm.addTable(): no file uploaded." );
    }
    return errors;
  }

  public void selectTable()
    throws ServletException
  {
    if( _selectedTableName != null ){
      for( Iterator i = _cachedTables.iterator(); i.hasNext(); ){
	Table t = (Table)i.next();
	if( _selectedTableName.equals( t.getName() ) ){
	  _selectedTable = t;
	  break;
	}
      }
    }else{
      MessageLog.printInfo( "SelectTableForm.selectTable(): _selectedTableName is null" );
    }
  }

  public void setUploadedFile( FormFile f ){
    _uploadedFile = f;
  }
  public FormFile getUploadedFile(){
    return _uploadedFile;
  }
  public void setWorksheetNumber( String s ){
    _worksheetNumber = s;
  }
  public String getWorksheetNumber(){
    return _worksheetNumber;
  }

  public void setAllowSelection( boolean b ){
    _allowSelection = b;
  }
  public boolean getAllowSelection(){
    return _allowSelection;
  }

  public void setAllowUpload( boolean b ){
    _allowUpload = b;
  }
  public boolean getAllowUpload(){
    return _allowUpload;
  }

  public void setHeaderRowNumber( String s ){
    _headerRowNumber = s;
  }
  public String getHeaderRowNumber(){
    return _headerRowNumber;
  }

  public void setDataStartRowNumber( String s ){
    _dataStartRowNumber = s;
  }
  public String getDataStartRowNumber(){
    return _dataStartRowNumber;
  }

  public void clear(){
    _uploadedFile = null;
    _cachedTables = new ArrayList();
    _selectedTable = null;
    _selectedTableName = null;
    _worksheetNumber = null;
    _headerRowNumber = null;
    _dataStartRowNumber = null;
    //_allowSelection = false;
    //_allowUpload = false;
  }

  public ActionErrors validate( ActionMapping mapping,
				HttpServletRequest request ){
    ActionErrors errors = new ActionErrors();
    String wrkSht = request.getParameter( "worksheetNumber" );
    String hdrRow = request.getParameter( "headerRowNumber" );
    String datRow = request.getParameter( "dataStartRowNumber" );
    MessageLog.printInfo( "validate: headerRowNumber = " + request.getParameter( "headerRowNumber" ) );
    if( wrkSht != null && wrkSht.trim().length() > 0 ){
      try{
	Integer.parseInt( wrkSht.trim() );
      }catch( NumberFormatException ex ){
	errors.add( "worksheetNumber", new ActionError( "errors.nan", wrkSht ) );
      }
    }
    if( hdrRow != null && hdrRow.trim().length() > 0 ){
      try{
	Integer.parseInt( hdrRow.trim() );
      }catch( NumberFormatException ex ){
	errors.add( "worksheetNumber", new ActionError( "errors.nan", hdrRow ) );
      }
    }
    if( datRow != null && datRow.trim().length() > 0 ){
      try{
	Integer.parseInt( datRow.trim() );
      }catch( NumberFormatException ex ){
	errors.add( "worksheetNumber", new ActionError( "errors.nan", datRow ) );
      }
    }
    return errors;
  }
  
}

