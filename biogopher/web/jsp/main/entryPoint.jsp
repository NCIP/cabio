<%@ taglib uri="/WEB-INF/struts-template.tld" prefix="template" %>

<template:insert template="/multiPanel.jsp">
 <template:put name="tabsPanel" content="main.do" direct="true"/>
 <template:put name="sidebarPanel" content="welcomePanelLeft.html" direct="true"/>
 <template:put name="topPanelSize" content="60%" direct="true"/>
 <template:put name="topPanel" content="welcomePanel.html" direct="true"/>
 <template:put name="middlePanelSize" content="40%" direct="true"/>
 <template:put name="middlePanel" content="initialMiddlePanel.html" direct="true"/>
 <%--<template:put name="bottomPanelSize" content="0" direct="true"/>--%>
</template:insert>
