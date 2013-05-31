<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<template:insert template="/biPanel_horiz.jsp">
 <template:put name="head" direct="true">
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <script language="javascript">
   var watchWindow = null;
   function closeWatchWindow(){
     if( watchWindow != null ){
       watchWindow.close();
     }
   }
   function browse( classname, id, role ){
    window.open( 'browseCaBIO.jsp?beanName=' + classname + '&beanId=' + id + '&roleName=' + role,
                 'browse', 'status,resizable,dependent,scrollbars,width=700,height=500,screenX=100,screenY=100' );
   }
  </script>
 </template:put>
 <template:put name="topPanelSize" content="75%" direct="true"/>
 <template:put name="bottomPanelSize" content="25%" direct="true"/>
 <template:put name="topPanel" direct="true">working.jsp?nextActionName=browseData_upper.jsp</template:put>
 <template:put name="bottomPanel" content="browseData_lower.jsp" direct="true"/>
</template:insert>

