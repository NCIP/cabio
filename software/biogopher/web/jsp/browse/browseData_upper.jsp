<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.ui.*,
		 gov.nih.nci.caBIOApp.sod.*,
		 gov.nih.nci.caBIOApp.util.*" %>
<jsp:useBean id="pagerBean" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.pager.PagerBeanImpl"/>
<%
   SODUtils sod = SODUtils.getInstance();
   SearchableObject so = sod.getSearchableObject( (String)session.getAttribute( "browse.objName" ) );
   Attribute att = sod.getAttribute( so, (String)session.getAttribute( "browse.propName" ) );
%>
 <% int startIdx = pagerBean.getStartIndex(); %>
 <% int displaySize = pagerBean.getDisplaySize(); %>
 <% int itemCount = pagerBean.getItemCount(); %>
 <% String[] headers = pagerBean.getHeaders(); %>
 <% PagerItem[] items = pagerBean.getAvailableItems(); %>
 <% MessageLog.printInfo( "items.length = " + items.length ); %>
<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <link href="styles/common.css" rel="stylesheet" type="text/css"/>
  <script language="javascript">
  var upToDate = true;

  function scroll( direction ){
   var form = document.pagerForm;
   form.pagerAction.value = "scroll";
   form.scrollDirection.value = direction;
   form.submit();
  }
  function finish( form ){
   form.pagerAction.value = "finish";
   form.submit();
  }
  function doCheckAll( form, set ) {
    var obj;
 
    for (i = 0; i < form.elements.length; i++)
    {
 	obj = form.elements[i];

        if (obj.type.toLowerCase() == 'checkbox')
             obj.checked = set;
    }
  }
  function selectAll( form ){
    doCheckAll( form, true );
    window.top.bottomPanel.upToDate = false;
    form.pagerAction.value = "select";
    form.submit();
  }

  function selectOne( checkbox ){
   if( checkbox.checked ){
    var form = checkbox.form;
    //form.selectedIds = new Array( checkbox.value );
    window.top.bottomPanel.upToDate = false;
    form.pagerAction.value = "select";
    form.submit();
   }else{
    checkbox.checked = true;
   }
  }

  function refresh(){
   window.location = "<%=request.getContextPath()%>/pageCaBIODataHandler?pagerAction=select"
  }

  </script>
  <title>Browse CaBIO Data</title>
 </head>
 <body class="boxCompleteLight">
 <script language="javascript">

  window.top.closeWatchWindow();

  if( !window.top.bottomPanel.upToDate ){
   window.top.bottomPanel.refresh();
  }
 </script>

 <div class="headerMediumDark">Browse <%= so.getLabel() %> - <%= att.getLabel() %></div>

<form name="pagerForm" action="pageCaBIODataHandler" method="post">

 <p>
  <input type="button" value="Done" onclick="finish( this.form )"/>&nbsp;
  <input type="button" value="Select All" onclick="selectAll( this.form )"/>&nbsp;
 </p>
 <div class="textMediumDark">
 <%= displaySize == 0 ? 0 : startIdx + 1 %> through <%= startIdx + displaySize %> of <%= itemCount %>
 <p>
  <% if( pagerBean.getAllowScrollBegin() ){ %>
   <a href="javascript:scroll( 'begin' )"/>BEGIN</a>
  <% }else{ %>
   BEGIN
  <% } %>&nbsp|&nbsp;
  <% if( pagerBean.getAllowScrollBackward() ){ %>
   <a href="javascript:scroll( 'backward' )"/>PREVIOUS</a>
  <% }else{ %>
   PREVIOUS
  <% } %>&nbsp;|&nbsp;
  <% if( pagerBean.getAllowScrollForward() ){ %>
   <a href="javascript:scroll( 'forward' )"/>NEXT</a>
  <% }else{ %>
   NEXT
  <% } %>&nbsp;|&nbsp;
  <% if( pagerBean.getAllowScrollEnd() ){ %>
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
   <th></th>
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
     <% PagerItem item = items[rowNum]; %>
     <td class="sampleText">
      <input type="checkbox" name="selectedIds" 
             onclick="selectOne( this )" value="<%= item.getId() %>"
	     <%= item.isSelected() ? " checked" : "" %>/>
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
 <input type="hidden" name="scrollDirection" value=""/>
 <input type="hidden" name="doRefresh" value=""/>

</form>
</html>

