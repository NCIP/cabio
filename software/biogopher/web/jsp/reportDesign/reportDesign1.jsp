<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<html>
<head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">

</head>
<script language="javascript">
 var contextPath = "<%= request.getContextPath() %>";
 window.top.topPanel.location = contextPath + "/designReportInstructions.html";
 window.top.middlePanel.location = contextPath + "/reportSummary.jsp";
 location = contextPath + "/objectTreeHandler";
</script>
</html>
