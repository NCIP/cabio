<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%
String boolStr = "";
gov.nih.nci.caBIOApp.ui.ValueLabelPair[] wVals = designQueryForm.getWorkingValues();
if( wVals != null && wVals.length == 1 ){
 boolStr = ( "true".equals( wVals[0].getValue() ) ? "true" : "false" );
}
%>
<table width="100%">
 <tr>
  <th colspan="2" class="headerLargeLight">
   <%= designQueryForm.getSelectedCriterion().getObjectLabel() %>
  </th>
 </tr>
   <tr>
    <td colspan="2">
      <div class="headerMediumDark">
       Working Values
      </div>
    </td>
  </tr>
 <tr>
  <td colspan="2"><div class="textMediumDark">Select all instances?</div></td>
 </tr>
 <tr>
  <td width="25%">
   <div class="textMediumDark">True:</div>
  </td>
  <td align="left">
   <input type="radio" 
          onclick="valueToAdd.value=labelToAdd.value='true';updateCriterion( 'add' );"
	  <%=("true".equals( boolStr ) ? "checked" : "" )%>/>
  </td>
 </tr>
 <tr>
  <td width="25%">
   <div class="textMediumDark">False:</div>
  </td>
  <td align="left">
   <input type="radio" 
          onclick="valueToAdd.value=labelToAdd.value='false';updateCriterion( 'add' );"
	  <%=("false".equals( boolStr ) ? "checked" : "" )%>/>
  </td>
 </tr>
</table>
<p>
<div class="textSmallDark">
 <b>NOTE:</b> Selecting 'true' here means that your search will return all <%= designQueryForm.getSelectedCriterion().getObjectLabel() %> data. In other words, the search will not be constrained.
</div>

