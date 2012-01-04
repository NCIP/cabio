<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.ui.*,
		 gov.nih.nci.caBIOApp.util.*" %>
<jsp:useBean id="pagerBean" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.pager.PagerBeanImpl"/>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <link href="styles/common.css" rel="stylesheet" type="text/css"/>
  <script language="javascript">
  var upToDate = true;

  function deselectOne( form, id ){
    window.top.topPanel.upToDate = false;
    form.selectedIds.value = id;
    form.pagerAction.value = "deselect";
    form.submit();
  }

  function refresh(){
   window.location = "<%=request.getContextPath()%>/pageCaBIODataHandler?pagerAction=deselect"
  }
  </script>
  <title>Browse CaBIO Data</title>
 </head>
 <body class="boxCompleteLight">
 <script language="javascript">
  if( window.top.topPanel.upToDate != null && !window.top.topPanel.upToDate ){
   window.top.topPanel.refresh();
  }
 </script>
<form name="pagerForm" action="pageCaBIODataHandler" method="post">

 <% String[] headers = pagerBean.getHeaders(); %>
 <% PagerItem[] items = pagerBean.getSelectedItems(); %>

 <table width="<%= headers.length * 1000 %>">
  <tr>
   <td>
 <table>
  <tr>
   <th></th>
   <% for( int i = 0; i < headers.length; i++ ){ %>
    <th>
     <%= headers[i] %>
    </th>
   <% } %>
  </tr>
  <% if( items.length < 1 ){ %>
   <tr>
    <td colspan="<%=headers.length + 1 %>" class="sampleText">NONE</td>
   </tr>
  <% }else{ %>
   <% for( int rowNum = 0; rowNum < items.length; rowNum++ ){ %>
    <tr>
     <% PagerItem item = items[rowNum]; %>
     <td class="sampleText">
      <input type="button" value="Deselect" onclick="deselectOne( this.form, '<%= item.getId() %>' )"/>
     </td>
     <% for( int colNum = 0; colNum < headers.length; colNum++ ){ %>
      <td class="sampleText">
       <% String val = item.getValues()[colNum]; %>
       <%= val == null ? "" : val %>
      </td>
     <% } %>
    </tr>
   <% }//-- end for( int rowNum... %>
  <% } %>
 </table>
   </td>
  </tr>
 </table>

 <input type="hidden" name="pagerAction" value=""/>
 <input type="hidden" name="selectedIds" value=""/>
</form>
</html>

