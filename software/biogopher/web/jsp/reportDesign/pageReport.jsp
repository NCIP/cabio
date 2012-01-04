<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.ui.*,
	         gov.nih.nci.caBIOApp.report.*,
		 gov.nih.nci.caBIOApp.util.*" %>
<% String dataSourceKeyName = request.getParameter( "gov.nih.nci.caBIOApp.ui.pager.dataSourceKeyName" ); %>
<% String pagerBeanKeyName = request.getParameter( "gov.nih.nci.caBIOApp.ui.pager.pagerBeanKeyName" ); %>
<% PagerBean reportBean = (PagerBean)session.getAttribute( pagerBeanKeyName ); %>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

  <link href="styles/common.css" rel="stylesheet" type="text/css"/>
  <script language="javascript">
  function scroll( direction ){
   var form = document.pagerForm;
   form.pagerAction.value = "scroll";
   form.scrollDirection.value = direction;
   form.submit();
  }
  </script>
 </head>
 <body class="boxCompleteLight">

 <script language="javascript">
  window.opener.top.closeWatchWindow();
 </script>

 <% boolean isMacIE = request.getHeader( "User-Agent" ).indexOf( "Mac" ) != -1; %>
 <% String reportLink = request.getParameter( "reportLink" ); %>
 <div class="headerMediumDark">
  Click <a href="<%=reportLink%>">here</a> to download.
 <% if( isMacIE ){ %>
  Mac user download <a href="macDownloadHelp.html" target="_blank">instructions</a>.
 <% } %>
 </div>
 <p>

<form name="pagerForm" action="pageReport" method="post">

 <% int startIdx = reportBean.getStartIndex(); %>
 <% int displaySize = reportBean.getDisplaySize(); %>
 <% int itemCount = reportBean.getItemCount(); %>
 <% String[] headers = reportBean.getHeaders(); %>
 <% PagerItem[] items = reportBean.getAvailableItems(); %>

 <div class="textMediumDark">
 <%= displaySize == 0 ? 0 : startIdx + 1 %> through <%= startIdx + displaySize %> of <%= itemCount %>
 <p>
  <% if( reportBean.getAllowScrollBegin() ){ %>
   <a href="javascript:scroll( 'begin' )"/>BEGIN</a>
  <% }else{ %>
   BEGIN
  <% } %>&nbsp|&nbsp;
  <% if( reportBean.getAllowScrollBackward() ){ %>
   <a href="javascript:scroll( 'backward' )"/>PREVIOUS</a>
  <% }else{ %>
   PREVIOUS
  <% } %>&nbsp;|&nbsp;
  <% if( reportBean.getAllowScrollForward() ){ %>
   <a href="javascript:scroll( 'forward' )"/>NEXT</a>
  <% }else{ %>
   NEXT
  <% } %>&nbsp;|&nbsp;
  <% if( reportBean.getAllowScrollEnd() ){ %>
   <a href="javascript:scroll( 'end' )"/>END</a>
  <% }else{ %>
   END
  <% } %>
 </p>
 </div>
 <table width="<%= headers.length * 1000 %>">
  <tr>
   <td>
 <table>
  <tr>
   <% for( int i = 0; i < headers.length; i++ ){ %>
    <th>
     <%= headers[i] %>
    </th>
   <% } %>
  </tr>
  <% if( itemCount < 1 ){ %>
   <tr>
    <td colspan="<%=headers.length + 1 %>" class="sampleText">NONE</td>
   </tr>
  <% }else{ %>
   <% for( int rowNum = 0; rowNum < displaySize; rowNum++ ){ %>
    <tr <%=((rowNum % 2) != 0 ? "bgcolor=\"#cccccc\"" : "")%>>
     <% PagerItem item = items[rowNum]; %>
     <% for( int colNum = 0; colNum < headers.length; colNum++ ){ %>
      <td class="sampleText">
       <% String[] vals = item.getValues(); %>
       <% String val = vals[colNum]; %>
       <%= val == null || val.trim().length() == 0 ? "&nbsp;" : val %>
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
 <input type="hidden" name="scrollDirection" value=""/>
 <input type="hidden" name="reportLink" value="<%=reportLink%>"/>
 <input type="hidden" name="gov.nih.nci.caBIOApp.ui.pager.dataSourceKeyName" value="<%= dataSourceKeyName %>"/>
 <input type="hidden" name="gov.nih.nci.caBIOApp.ui.pager.pagerBeanKeyName" value="<%= pagerBeanKeyName %>"/>

</form>

