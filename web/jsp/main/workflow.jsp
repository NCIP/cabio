<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<%--
<%! private String calcImgSrcURL( HttpServletRequest request, String controlName ){
       String currentStep = request.getParameter( "currentStep" );
       StringBuffer url = new StringBuffer( "images/" + controlName );
       if( controlName.equals( currentStep ) ){
          url.append( "On.jpg" );
       }else{
          url.append( "Off.jpg" );
       }
       return url.toString();
    }
%>
--%>
<%! private String getTabTrans( boolean leftOn, boolean rightOn ){
     String imgName = null;
     if( leftOn ){
      imgName = "tabOnOff.jpg";
     }else if( rightOn ){
      imgName = "tabOffOn.jpg";
     }else{
      imgName = "tabOffOff.jpg";
     }
     return imgName;
    }
%>
<%
  // Need to figure out which tab is on.
  boolean sdOn = false, cqOn = false, crOn = false;
  String currentStep = request.getParameter( "currentStep" );
  if( "supplyDatasource".equals( currentStep ) ){
   sdOn = true;
  }else if( "createQuery".equals( currentStep ) ){
   cqOn = true;
  }else if( "createReport".equals( currentStep ) ){
   crOn = true;
  }
%>
<jsp:useBean id="mainForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.MyCaBIOMainForm"/>

<html>
 <head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
  <html:base/>

  <script language="javascript">

    function perform( stepName ){
      window.top.nextLocation = "main.do?lastStep=displayWorkflow&nextStep=" + stepName;
      var numPops = window.top.activePanel.getNumPops();
      if( numPops == "0" ){
        window.top.activePanel.finish();
      }else{
        window.top.activePanel.location = "popState.jsp?numPops=" + numPops + "&bogusParam=" + (new Date()).getTime();
      }
    }
  
    function refresh( stepName ){
     location = "workflow.jsp?currentStep=" + stepName;
    }
  </script>
  <link href="styles/common.css" rel="stylesheet" type="text/css">
 </head>
 <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">

 <script language="javascript">
  if( window.name != "tabsPanel" ){ 
   window.top.location = "index.jsp";
  }
 </script>
  <table border="0" cellpadding="0" cellspacing="0">
   <tr>
    <td>
     <img src="images/shim.gif" width="20" height="20" hspace="0" vspace="0" border="0">
     <a href="javascript:perform( 'supplyDatasource' )">
     <img src="images/supplyDatasource<%= sdOn ? "On" : "Off" %>.jpg" border="0"/><img src="images/<%=getTabTrans( sdOn, cqOn )%>" border="0"/>     
     </a>
    </td>
    <td>
     <a href="javascript:perform( 'createQuery' )">
     <img src="images/createQuery<%= cqOn ? "On" : "Off" %>.jpg" border="0"/><img src="images/<%=getTabTrans( cqOn, crOn )%>" border="0"/>     
     </a>
    </td>
    <td>
     <a href="javascript:perform( 'createReport' )">
     <img src="images/createReport<%= crOn ? "On" : "Off" %>.jpg"
	  border="0"/>
     </a>
    </td>

   </tr>
  </table>
  <script language="javascript">
   isLoaded = true;
  </script>
 </body>
</html>

