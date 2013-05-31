<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<table width="100%">
  <tr>
    <th colspan="2" class="headerLargeLight">
      <%= designQueryForm.getSelectedCriterion().getObjectLabel() %> - <%= designQueryForm.getSelectedCriterion().getPropertyLabel() %>
    </th>
  </tr>
  <tr>
    <td>
      <div class="headerMediumDark">
       <center>Working Values</center>
      </div>
    </td>
  </tr>  
  <tr>
    <td width="100%">
      <div class="textMediumDark">
      <center>
      <select name="selectedValues" multiple="true">
	<% if( ((ValueLabelPair[])designQueryForm.getWorkingValues()).length == 0 ){ %>
	<option value="            ">
	  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  </option>
	  <% } %>
	  <logic:iterate id="value" name="designQueryForm" property="workingValues"
	  type="gov.nih.nci.caBIOApp.ui.ValueLabelPair">
	 <%
	  String label = value.getLabel();
	  if( label != null ){
	    if( label.length() > 20 ){
	      label = label.substring( 0, 20 ) + "...";
	    }
	  }
	 %>
           <option value="<%=value.getValue()%>"><%=label%></option>
	  </logic:iterate>
      </select>
      </center>
      </div>
    </td>
    
  </tr>
</table>

