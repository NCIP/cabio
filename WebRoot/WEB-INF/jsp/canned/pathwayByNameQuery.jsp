<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_pathwayByName" class="query">

    <html:form action="/cabioportlet/pathwayByNameQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Name of the pathway">Pathway Name</td><td>
    <html:text property="pathwayName" size="30"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
