/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.report;

import gov.nih.nci.caBIO.search.GridCell;
import gov.nih.nci.caBIO.search.GridRow;
import gov.nih.nci.caBIO.search.GridSearchCriteria;
import gov.nih.nci.caBIO.search.GridSearchResultMapping;
import gov.nih.nci.caBIO.search.ObjectGrid;
import gov.nih.nci.caBIO.search.ObjectGridImpl;
import gov.nih.nci.caBIO.search.RowIndex;
import gov.nih.nci.caBIO.search.SearchCriteriaMapping;
import gov.nih.nci.caBIO.search.SelectionNode;
import gov.nih.nci.caBIO.search.SelectionNodeImpl;
import gov.nih.nci.caBIOApp.ui.ColumnSpecification;
import gov.nih.nci.caBIOApp.ui.ReportDesign;
import gov.nih.nci.caBIOApp.util.AppConfig;
import gov.nih.nci.caBIOApp.util.MessageLog;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;

public class ReportGenerator {

    //private ReportDesign myReportDesign = null;
    //private Table outputTable = new CaBIOTable();
    private ReportDesign _reportDesign = null;

    public ReportGenerator(ReportDesign rd) {
        _reportDesign = rd;
        //myReportDesign = rd;
        init();
    }

    private void init() {
        try {
            AppConfig config = AppConfig.getInstance();
        }
        catch (Exception ex) {
            throw new RuntimeException("Couldn't initialize matrix size: "
                    + ex.getMessage());
        }
    }

    public Table generateReport() throws Exception {
        try {
            Table outputTable = new CaBIOTable();
            List colSpecs = _reportDesign.getColumnSpecifications();
            /*
            SelectionNode selectionTree = buildSelectionTree( _reportDesign.getCommonCriteria(),
            					_reportDesign.getJoinObjectNames(),
            					colSpecs );
            */
            SelectionNode selectionTree = _reportDesign.getSelectionTree();
            String basePath = selectionTree.getPathName();
            List rowIndices = _reportDesign.getRowIndices();
            SearchCriteriaMapping[] batchSearch = buildBatchSearch(rowIndices);
            GridSearchCriteria sc = new GridSearchCriteria(selectionTree,
                    batchSearch);
            //sc.setMaxRecordset( new Integer( 1 ) );
            ObjectGrid og = new ObjectGridImpl();
            GridSearchResultMapping[] results = og.search(sc);
            //Set up the output table
            for (Iterator i = colSpecs.iterator(); i.hasNext();) {
                outputTable.addColumn(((ColumnSpecification) i.next()).getNewColumnTitle());
            }
            outputTable.setColumnCount(colSpecs.size());
            //Merge the results
            Table givenTable = _reportDesign.getMergeTable();
            for (int i = 0; i < results.length; i++) {
                MessageLog.printInfo("ON MAPPING " + i);
                GridSearchResultMapping mapping = results[i];
                GridRow[] rows = mapping.getResult();
                MessageLog.printInfo("rows.length = " + rows.length);
                if (rowIndices.size() == 0) {//means we are NOT merging
                    for (int j = 0; j < rows.length; j++) {
                        //build row
                        String[] tableRow = new String[colSpecs.size()];
                        GridRow gridRow = rows[j];
                        for (Iterator sit = colSpecs.iterator(); sit.hasNext();) {
                            ColumnSpecification colSpec = (ColumnSpecification) sit.next();
                            String csp = colSpec.getPath();
                            if (!csp.startsWith(basePath + ".")) {
                                csp = basePath + "." + csp;
                            }
                            MessageLog.printInfo("csp = " + csp);
                            GridCell cell = gridRow.getCell(csp);
                            if (cell != null) {
                                String val = null;
                                Object o = cell.getObject();
                                if (o != null) {
                                    val = o.toString();
                                }
                                int theCol = colSpec.getNewColumnNumber();
                                MessageLog.printInfo(" adding " + val
                                        + " cell to [" + j + "," + theCol + "]");
                                tableRow[theCol] = val;
                            }
                            else {
                                MessageLog.printInfo("cell for " + csp
                                        + " is null.");
                            }
                        }
                        outputTable.addRow(Arrays.asList(tableRow));
                    }
                }
                else {//means we ARE merging
                    MessageLog.printInfo("MERGING...");
                    RowIndex rowIndex = (RowIndex) mapping.getClientData();
                    if (rowIndex == null) {
                        MessageLog.printInfo("ROW INDEX IS NULL");
                    }
                    List rowsToDup = rowIndex.getRowNumbers();
                    GridRow[] gridRows = mapping.getResult();
                    for (Iterator rit = rowsToDup.iterator(); rit.hasNext();) {
                        Integer rowNum = (Integer) rit.next();
                        MessageLog.printInfo("ROW TO DUP " + rowNum);
                        if (gridRows != null && gridRows.length > 0) {
                            MessageLog.printInfo(gridRows.length
                                    + " gridRows for mapping " + i);
                            for (int k = 0; k < gridRows.length; k++) {
                                List rowCopy = copyRow(rowNum.intValue(),
                                    givenTable);
                                GridRow gridRow = gridRows[k];
                                if (gridRow != null) {
                                    for (ListIterator j = colSpecs.listIterator(); j.hasNext();) {
                                        ColumnSpecification colSpec = (ColumnSpecification) j.next();
                                        if (colSpec.isMapped()
                                                && !colSpec.isMergeColumn()) {
                                            String csp = colSpec.getPath();
                                            if (!csp.startsWith(basePath + ".")) {
                                                csp = basePath + "." + csp;
                                            }
                                            MessageLog.printInfo("csp = " + csp);
                                            GridCell gridCell = gridRow.getCell(csp);
                                            if (gridCell != null) {
                                                rowCopy.set(j.previousIndex(),
                                                    gridCell.getObject());
                                            }
                                        }
                                    }//--end iteration through colSpecs
                                    outputTable.addRow(rowCopy);
                                }
                            }//--end iteration through gridRows
                        }
                        else {
                            MessageLog.printInfo("no gridRows for mapping " + i);
                            List rowCopy = copyRow(rowNum.intValue(),
                                givenTable);
                            outputTable.addRow(rowCopy);
                        }
                    }//--end iteration throgh rowToDup
                }
            }
            MessageLog.printInfo("...after merging, adding null cells...");
            //copy over the rows for which the merge cell was empty
            List nullCellRowNums = _reportDesign.getNullCellRowNums();
            for (Iterator i = nullCellRowNums.iterator(); i.hasNext();) {
                Integer rowNum = (Integer) i.next();
                List rowCopy = copyRow(rowNum.intValue(), givenTable);
                outputTable.addRow(rowCopy);
            }
            return outputTable;
        }
        catch (Exception ex) {
            MessageLog.printStackTrace(ex);
            throw ex;
        }
    }

    private List copyRow(int rowNum, Table table) {
        List rowCopy = new ArrayList();
        int colCount = table.getColumnCount();
        for (int i = 0; i < colCount; i++) {
            rowCopy.add(table.getStringValueAt(rowNum, i));
        }
        return rowCopy;
    }

    private SelectionNode buildSelectionTree(
            gov.nih.nci.common.search.SearchCriteria criteria, List joinObjs,
            List colSpecs) throws Exception {
        String mainObjName = (String) joinObjs.get(0);
        String mainObjShortName = mainObjName.substring(mainObjName.lastIndexOf(".") + 1);
        List mainObjAtts = new ArrayList();
        List subObjSpecs = new ArrayList();
        for (Iterator i = colSpecs.iterator(); i.hasNext();) {
            ColumnSpecification colSpec = (ColumnSpecification) i.next();
            if (colSpec.isMapped()) {
                if (colSpec.getObjectName().indexOf(mainObjShortName) != -1) {
                    String attName = colSpec.getAttributeName();
                    colSpec.setPath(mainObjShortName + "." + attName);
                    mainObjAtts.add(attName);
                }
                else {
                    subObjSpecs.add(colSpec);
                }
            }
        }
        SelectionNode tree = new SelectionNodeImpl(mainObjShortName, criteria,
                mainObjAtts);
        //group specs
        String mergeObjName = null;
        HashMap groupedObjSpecs = new HashMap();
        for (Iterator i = subObjSpecs.iterator(); i.hasNext();) {
            ColumnSpecification spec = (ColumnSpecification) i.next();
            String objName = spec.getObjectName();
            if (objName.indexOf(".") != -1) {
                objName = objName.substring(objName.lastIndexOf(".") + 1);
            }
            if (spec.isMergeColumn()) {
                mergeObjName = objName;
            }
            String attName = spec.getAttributeName();
            spec.setPath(mainObjShortName + "." + objName + "." + attName);
            List atts = (List) groupedObjSpecs.get(objName);
            if (atts == null) {
                atts = new ArrayList();
                atts.add(attName);
                groupedObjSpecs.put(objName, atts);
            }
            else {
                atts.add(attName);
            }
        }
        MessageLog.printInfo("ReportGenerator.buildSelectionTree(): mergeObjName = "
                + mergeObjName);
        int idx = 0;
        for (Iterator i = groupedObjSpecs.keySet().iterator(); i.hasNext(); idx++) {
            String objName = (String) i.next();
            List atts = (List) groupedObjSpecs.get(objName);
            String path = mainObjShortName + "." + objName;
            gov.nih.nci.common.search.SearchCriteria filter = null;
            if (objName.equals(mergeObjName)) {
                filter = criteria.getSearchCriteria("gov.nih.nci.caBIO.bean."
                        + objName + "SearchCriteria");
                if (filter != null) {
                    MessageLog.printInfo("...found merge object");
                }
            }
            else {
                filter = (gov.nih.nci.common.search.SearchCriteria) Class.forName(
                    "gov.nih.nci.caBIO.bean." + objName + "SearchCriteria").newInstance();
            }
            SelectionNode node = new SelectionNodeImpl(path, filter, atts);
            tree.insert(node, idx);
        }
        return tree;
    }

    private SearchCriteriaMapping[] buildBatchSearch(List rowIndices)
            throws Exception {
        SearchCriteriaMapping[] batch = null;
        if (rowIndices.size() == 0) {
            batch = new SearchCriteriaMapping[1];
            batch[0] = new SearchCriteriaMapping();
        }
        else {
            batch = new SearchCriteriaMapping[rowIndices.size()];
            for (ListIterator i = rowIndices.listIterator(); i.hasNext();) {
                RowIndex idx = (RowIndex) i.next();
                batch[i.previousIndex()] = new SearchCriteriaMapping(idx,
                        idx.getCriteria());
            }
        }
        return batch;
    }

    private List orderNodes( SelectionNode tree, List colSpecs ){
    List orderedNodes = new ArrayList();
    for( Iterator i = colSpecs.iterator(); i.hasNext(); ){
      ColumnSpecification colSpec = (ColumnSpecification)i.next();
      String objName = colSpec.getObjectName();
      int idx = objName.lastIndexOf( "." );
      if( idx != -1 ){
	objName = objName.substring( idx + 1 );
      }
      String propName = objName + "." + colSpec.getAttributeName();
      for( Enumeration e = tree.preorderEnumeration(); e.hasMoreElements(); ){
	SelectionNode node = (SelectionNode)e.nextElement();
	if( node.getPathName().indexOf( propName ) != -1 ){
	  orderedNodes.add( node );
	  break;
	}
      }
    }
    return orderedNodes;
  }
    /*
    public Table generateReport() {
      try {
        SearchCriteria commonCriteria = myReportDesign.getCommonCriteria();
        commonCriteria.setMaxRecordset( _maxMatrixSize );
        Table mergeTable = myReportDesign.getMergeTable();
        List colSpecifications = myReportDesign.getColumnSpecifications();
        //set the column titles
        for( Iterator i = colSpecifications.iterator(); i.hasNext(); ){
    outputTable.addColumn( ((ColumnSpecification)i.next()).getNewColumnTitle() );
        }
        outputTable.setColumnCount( colSpecifications.size() );
        
        List joinObjectNames = myReportDesign.getJoinObjectNames();
        QueryResolver myQueryResolver = new QueryResolver();
        MessageLog.printInfo( "ReportGenerator: about to call getCaBIOMatrix..." );
        CaBIOMatrix myCaBIOMatrix = myQueryResolver.getCaBIOMatrix(commonCriteria, joinObjectNames);
        MessageLog.printInfo( "ReportGenerator: about to call getRowIndices..." );
        List rowIndices = myReportDesign.getRowIndices();
        if (rowIndices.size() == 0) {
    MessageLog.printInfo( "ReportGenerator: about to call fillTable..." );
    fillTable(colSpecifications, mergeTable, myCaBIOMatrix);
        } else {
    MessageLog.printInfo( "ReportGenerator: about to call QueryResolver.search(rowIndices)..." );
    rowIndices = myQueryResolver.search(rowIndices);
    Iterator rowIterator = rowIndices.iterator();
    while (rowIterator.hasNext()) {
      RowIndex idx = (RowIndex)rowIterator.next();
      
      List objs = idx.getObjects();
      List matrixRows = myCaBIOMatrix.filter(idx.getObjects());
      mergeRows(idx, colSpecifications, mergeTable, matrixRows);
    }
    
        }
      } catch( Exception ex ){
        MessageLog.printStackTrace( ex );
      }
      return outputTable;
    }
    
    private void mergeRows(RowIndex idx, List colSpecifications, Table mergeTable, List matrixRows) {

      ArrayList rowsToDuplicate = idx.getRowNumbers();
      //Loop through each of those row numbers
      for (int i = 0; i < rowsToDuplicate.size(); i++) {
        //for each of those rows grab the values from that Row and put them in a vector
        Integer x = (Integer)rowsToDuplicate.get(i);

        //create an iterator for each of the rows in the matrix
        Iterator myIterator = matrixRows.iterator();
        while (myIterator.hasNext()) {
    //Create a matrixRow
    MatrixRow myMatrixRow = (MatrixRow)myIterator.next();
    Vector mergeRowValues = mergeTable.getRowValues(x.intValue());
    for( Iterator it = colSpecifications.iterator(); it.hasNext(); ){
      ColumnSpecification colSpec = (ColumnSpecification)it.next();
      if( colSpec.isMapped() && !colSpec.isMergeColumn() ){
        int num = colSpec.getNewColumnNumber();
        String propName = COREUtilities.getShortName(colSpec.getObjectName()) + "." + colSpec.getAttributeName();
        String val = myMatrixRow.getCell( propName );
        mergeRowValues.set( num, val );
      }
    }
    outputTable.addRow(mergeRowValues);
        }
      }
    }
    
    private Vector getMatrixRowValues(MatrixRow mr, List colSpecifications) {
      Vector matrixRowValues = new Vector();
      Iterator myNextIterator = colSpecifications.iterator();
      while (myNextIterator.hasNext()) {
        //for each columnSpecification in the list create a column specification
        ColumnSpecification colSpec = (ColumnSpecification)myNextIterator.next();
        //get the value from the specific cell based on the columnSpecification
        //add the value to the matrixRowValues vector

        String val = mr.getCell( colSpec.getObjectName(), colSpec.getAttributeName() );
        if ( val != null ) {
    matrixRowValues.add( val );
        } else {
    matrixRowValues.add("");
        }
      }
      return matrixRowValues;
    }
    
    
    private void fillTable(List colSpecifications, Table mergeTable, CaBIOMatrix matrix) {

      Iterator myIterator = matrix.getIterator();
      while (myIterator.hasNext()) {
        //Create a matrixRow
        MatrixRow myMatrixRow = (MatrixRow)myIterator.next();
        //Create a vector of the values from the matrix row that need to be added to the row
        Vector matrixValues = getMatrixRowValues(myMatrixRow, colSpecifications);
        //Add each value in the matrixValues vector to the mergeRowValues vector
        Vector mergeRowValues = new Vector();
        for (int j = 0; j < matrixValues.size(); j++) {
    mergeRowValues.add(matrixValues.elementAt(j));
        }
        //Add the final vector of values to the outputTable
        //MessageLog.printInfo( "ReportGenerator.fillTable(): adding row: " + mergeRowValues.toString() );
        outputTable.addRow(mergeRowValues);
      }
    }
    */
}
