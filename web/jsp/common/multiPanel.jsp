<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<html>
<head>
<html:base/>
<script language="javascript">
    var nextPanel = null;
    var nextLocation = null;
    var activePanel = null;
    var watchWindow = null;

  function closeWatchWindow(){
   if( watchWindow != null ){
     watchWindow.close();
   }
  }

  function errorOccurred(){
    window.location = "index.jsp";
  }
  function doNothing(){
    //nadda
  }
  function cancelEnterKey( evt ){
    //alert( "keyCode = " + evt.keyCode );
    var retVal = true;
    if( evt.keyCode == 13 ){
      retVal = false;
      evt.cancelBubble = true;
      evt.returnValue = false;
    }
    return retVal;
  }
</script>
</head>
<script language="javascript">
if( window.top.location != window.location ){
 window.top.location = window.location;
}
</script>
<frameset rows="95,30,*,20" frameborder="no" border="0" framespacing="0">

 <frame name="header" src="header.htm" marginwidth="0" marginheight="0" scrolling="no"/>

 <frame name="tabsPanel" src="<template:get name="tabsPanel"/>" scrolling="no" marginwidth="0" marginheight="0"/>

 <frameset cols="20,460,*,10" frameborder="no" border="0" framespacing="0">
  <frame src="marginLeft.htm" name="marginLeft" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0" id="marginLeft">
  <frame name="sidebarPanel" src="<template:get name="sidebarPanel"/>" marginwidth="0" marginheight="0"/>

  <frameset rows="<template:get name="topPanelSize"/>,<template:get name="middlePanelSize"/>"
            frameborder="no" border="0" framespacing="0">
   <frame name="topPanel" src="<template:get name="topPanel"/>" marginwidth="0" marginheight="0"/>
   <frame name="middlePanel" src="<template:get name="middlePanel"/>" marginwidth="0" marginheight="0"/>
  </frameset>
 <frame src="marginRight.htm" name="marginRight" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0" id="marginRight">
 </frameset>

 <frame name="footer" src="footer.htm" marginwidth="0" marginheight="0" scrolling="no"/>

</frameset>

</html>

