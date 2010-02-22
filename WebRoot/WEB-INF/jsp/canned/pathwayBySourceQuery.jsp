<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_pathwayBySource" class="query">

    <html:form action="/cabioportlet/pathwayBySourceQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Pathway Source">Pathway Source</td><td>
    <html:select property="pathwaySource">
    <html:option value="">Select...</html:option>
    <html:optionsCollection name="globalQueries" property="pathwaySources" label="name"/>
    </html:select>
    </td></tr>
    
    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
