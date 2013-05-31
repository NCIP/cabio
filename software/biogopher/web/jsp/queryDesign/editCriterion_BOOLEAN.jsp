<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%
String b = "";
gov.nih.nci.caBIOApp.ui.ValueLabelPair[] vals = designQueryForm.getWorkingValues();
if( vals != null && vals.length == 1 ){
b = ( "true".equals( vals[0].getValue() ) ? "true" : "false" );
}
%>
<table width="100%">
  <tr>
    <th colspan="2" class="headerLargeLight">
      <%= designQueryForm.getSelectedCriterion().getObjectLabel() %> - <%= designQueryForm.getSelectedCriterion().getPropertyLabel() %>
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
    <td width="25%">
      <div class="textMediumDark">True:</div>
    </td>
    <td align="left">
      <input type="radio" 
      onclick="valueToAdd.value=labelToAdd.value='true';updateCriterion( 'add' );"
	  <%=("true".equals( b ) ? "checked" : "" )%>/>
    </td>
  </tr>
  <tr>
    <td width="25%">
      <div class="textMediumDark">False:</div>
    </td>
    <td align="left">
      <input type="radio" 
      onclick="valueToAdd.value=labelToAdd.value='false';updateCriterion( 'add' );"
	  <%=("false".equals( b ) ? "checked" : "" )%>/>
    </td>
  </tr>
</table>

