<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_genomics_genebysymbol" class="query">

    <html:form action="/cabioportlet/geneBySymbolQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Unigene or HUGO gene symbol">Gene Symbol</td><td>
    <html:text property="geneSymbol" size="20"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
