<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_cancer_agenttogenes" class="query">

    <html:form action="/cabioportlet/agentToGenesQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Agent name or EVS concept code">Agent (name or concept code)</td><td>
    <html:text property="agent" size="30"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
