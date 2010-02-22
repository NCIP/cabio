<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_cancer_diseasetogenes" class="query">

    <html:form action="/cabioportlet/diseaseToGenesQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Disease Name or EVS concept code Id">Disease (name or concept code)</td><td>
    <html:text property="disease" size="30"/>
    </td></tr>
    <jsp:include page="/WEB-INF/jsp/canned/cgiEvidenceProperties.jsp" flush="true"/>
    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
