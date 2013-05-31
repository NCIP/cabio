/*L
 *  Copyright SAIC
 *
 *  Distributed under the OSI-approved BSD 3-Clause License.
 *  See http://ncip.github.com/cabio/LICENSE.txt for details.
 */

package gov.nih.nci.caBIOApp.report;public class TableCell implements Cell {    private Object cellValue;    public void setCellValue(Object s) {        cellValue = s;    }    public Object getCellValue() {        return cellValue;    }    public String toString() {        String cellV = (String) this.cellValue;        return cellV;    }}