<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<html>
<head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

 <html:base/>
 <script language="javascript">
  function selectItem( form, whatSelected ){
   //alert( "whatSelected == " + whatSelected );
   if( 'queryDesign' == whatSelected &&
       form.selectedQueryDesignId.selectedIndex != -1 ){
    form.selectedReportDesignId.selectedIndex = -1;
    //alert( "about to select query design" );
    form.label.value = form.newReportLabel.value;
    form.nextStep.value = "create";
    form.submit();
   }else if( 'reportDesign' == whatSelected &&
             form.selectedReportDesignId.selectedIndex != -1 ){
    form.selectedQueryDesignId.selectedIndex = -1;
    //alert( "about to select report design" );
    form.nextStep.value = "select";
    form.submit();
   }else{
    //alert( "doing nothing" );
    //do nothing
   }
  }
  function renameReport( form ){
   form.label.value = prompt( "Please enter the new name for your report.", "NAME" );
   if( form.label.value != null &&
       form.label.value != "" &&
       form.label.value != "NAME" ){
    form.nextStep.value = "rename";
    form.submit();
   }
  }
  function removeReport( form ){
   if( confirm( "This report will be permanently deleted. Continue?" ) ){
    form.nextStep.value = "remove";
    form.submit();
   }
  }
  function finish(){
   var form = document.createReportForm;
   form.nextStep.value = "cancel";
   form.submit();
  }
 </script>
</head>
<body>
 <html:errors/>
 <%@ include file="/reportDesignSelection_main.jsp" %>

 <script language="javascript">
  window.top.tabsPanel.refresh( "createReport" );
  window.top.setActivePanel( window.top.topPanel );
  var contextPath = "<%=request.getContextPath()%>";
  window.top.sidebarPanel.location = contextPath + "/emptySidebarPanel.html";
  window.top.middlePanel.location = contextPath + "/emptyMiddlePanel.html";
 </script>
</body>
</html>

