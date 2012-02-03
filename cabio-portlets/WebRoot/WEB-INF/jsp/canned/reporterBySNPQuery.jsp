<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_microarray_reporterbysnp" class="query">

    <html:form action="/cabioportlet/reporterBySNPQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Id of the dbSNP beginning with 'rs'"><label for="queries_microarray_reporterbysnp_dbsnpId">dbSNP Id</label></td><td>
    <html:text property="dbsnpId" size="20" styleId="queries_microarray_reporterbysnp_dbsnpId"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
