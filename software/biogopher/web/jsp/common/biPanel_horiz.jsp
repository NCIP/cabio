<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<html>
<head>
<template:get name="head"/>
</head>
<frameset frameborder="0" rows="<template:get name="topPanelSize"/>,<template:get name="bottomPanelSize"/>">

 <frame name="topPanel" frameborder="1" src="<template:get name="topPanel"/>"/>
 <frame name="bottomPanel" frameborder="1" src="<template:get name="bottomPanel"/>"/>

</frameset>
</html>

