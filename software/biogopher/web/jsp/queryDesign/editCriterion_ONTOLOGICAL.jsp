<% String ontObjLabel = designQueryForm.getSelectedCriterion().getObjectLabel(); %>
<table width="100%">
  <tr>
    <th colspan="2" class="headerLargeLight">
      <%= ontObjLabel %>
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
   <td>
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
<input type="hidden" name="tempLabel" value=""/>
<p>
<div class="textMediumDark">
This caBIO object is part of an ontology. Within this application, that means that each
<%= ontObjLabel %> may have a parent <%= ontObjLabel %> and may also have children. When
you press the <em>Add New</em> button, below, a window will appear within which the
<%= ontObjLabel %> ontology will be displayed. My selecting an object from that
ontology you are saying, &quot;Give me data about this <%= ontObjLabel %> and all of its
children.&quot;
</div>

