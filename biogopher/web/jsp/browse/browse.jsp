<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.ui.*,
		 gov.nih.nci.caBIOApp.sod.*,
		 gov.nih.nci.caBIOApp.util.*" %>
<jsp:useBean id="browserBean" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.pager.PagerBeanImpl"/>
<% String browserTitle = request.getParameter( "browserTitle" ); %>
<% if( browserTitle == null ){ browserTitle = (String)request.getAttribute( "browserTitle" ); } %>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

  <script language="javascript">
  var upToDate = true;

   function browse( classname, id, role ){
    var now = new Date()
    window.open( 'browseCaBIO.jsp?beanName=' + classname + '&beanId=' + id + '&roleName=' + role,
                 'browse' + now.getMilliseconds(), 'status,resizable,dependent,scrollbars,width=700,height=500,screenX=100,screenY=100' );
   }

  function scroll( direction ){
   var form = document.pagerForm;
   form.pagerAction.value = "scroll";
   form.scrollDirection.value = direction;
   form.submit();
  }

  </script>
  <title>Browse CaBIO Data</title>
  <link href="styles/common.css" rel="stylesheet" type="text/css"/>
 </head>
 <body class="boxCompleteLight">

<div class="headerMediumDark>"Browse <%=browserTitle%></div>
<p>

<form name="pagerForm" action="browse" method="post">

 <% int startIdx = browserBean.getStartIndex(); %>
 <% int displaySize = browserBean.getDisplaySize(); %>
 <% int itemCount = browserBean.getItemCount(); %>
 <% String[] headers = browserBean.getHeaders(); %>
 <% PagerItem[] items = browserBean.getAvailableItems(); %>
 <% MessageLog.printInfo( "items.length = " + items.length ); %>
 <div class="textMediumDark">
 <%= displaySize == 0 ? 0 : startIdx + 1 %> through <%= startIdx + displaySize %> of <%= itemCount %>
 <p>
  <% if( browserBean.getAllowScrollBegin() ){ %>
   <a href="javascript:scroll( 'begin' )"/>BEGIN</a>
  <% }else{ %>
   BEGIN
  <% } %>&nbsp|&nbsp;
  <% if( browserBean.getAllowScrollBackward() ){ %>
   <a href="javascript:scroll( 'backward' )"/>PREVIOUS</a>
  <% }else{ %>
   PREVIOUS
  <% } %>&nbsp;|&nbsp;
  <% if( browserBean.getAllowScrollForward() ){ %>
   <a href="javascript:scroll( 'forward' )"/>NEXT</a>
  <% }else{ %>
   NEXT
  <% } %>&nbsp;|&nbsp;
  <% if( browserBean.getAllowScrollEnd() ){ %>
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
    <tr>
     <% System.err.println( "retrieving roNum " + rowNum ); %>
     <% PagerItem item = items[rowNum]; %>
     <% if( item == null ){ throw new ServletException( "items[" + rowNum + "] is null." ); } %>
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
 <input type="hidden" name="scrollDirection" value=""/>
 <input type="hidden" name="browserTitle" value="<%=browserTitle%>"/>

</form>

</html>

