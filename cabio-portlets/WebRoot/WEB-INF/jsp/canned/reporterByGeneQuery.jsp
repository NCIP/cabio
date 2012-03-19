<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_microarray_reporterbygene" class="query">

    <html:form action="/cabioportlet/reporterByGeneQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Gene symbol or alias"><label for="queries_microarray_reporterbygene_geneSymbol">Gene Symbol or Alias</label></td><td>
    <html:text property="geneSymbol" size="30" styleId="queries_microarray_reporterbygene_geneSymbol"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
