<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_pathwayByName" class="query">

    <html:form action="/cabioportlet/pathwayByNameQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Name of the pathway"><label for="queries_pathwayByName_pathwayName">Pathway Name</label></td><td>
    <html:text property="pathwayName" size="30" styleId="queries_pathwayByName_pathwayName"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
