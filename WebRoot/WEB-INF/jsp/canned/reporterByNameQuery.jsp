<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_microarray_reporterbyname" class="query">

    <html:form action="/cabioportlet/reporterByNameQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Microarray platform">Microarray</td><td>
    <html:select property="microarray">
    <html:option value="">Select...</html:option>
    <html:optionsCollection name="globalQueries" property="microarrays" value="name" label="description"/>
    </html:select>
    </td></tr>
    
    <tr><td title="Name of the microarray reporter">Reporter Name</td><td>
    <html:text property="reporterId" size="30"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
