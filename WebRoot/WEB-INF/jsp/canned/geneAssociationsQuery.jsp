<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_cancer_geneassociations" class="query">

    <html:form action="/cabioportlet/geneAssociationsQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Unigene or HUGO gene symbol">Gene Symbol</td><td>
    <html:text property="geneSymbol" size="30"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
