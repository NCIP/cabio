<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>
<frameset frameborder="0" rows="145,*,10%">

 <frame name="header" src="caBIO_base_header.html"/>

 <frameset cols="20%,*">

  <frame name="sidebar" src="<template:get name="sidebar"/>"/>

  <frameset rows="<template:get name="topPaneSize"/>,<template:get name="middlePaneSize"/>,<template:get name="mottomPaneSize"/>">
   <frame name="topPane" src="<template:get name="topPane"/>"/>
   <frame name="middlePane" src="<template:get name="middlePane"/>"/>
   <frame name="bottomPane" src="<template:get name="bottomPane"/>"/>
  </frameset>

 </frameset>

 <frame name="footer" src="<template:get name="footer"/>"/>

</frameset>
