<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_pathwayByProtein" class="query">

    <html:form action="/cabioportlet/pathwayByProteinQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Protein Name or Accession"><label for="queries_pathwayByProtein_proteinNameAccession">Protein Name or UniProt Accession</label></td><td>
    <html:text property="proteinNameAccession" size="30" styleId="queries_pathwayByProtein_proteinNameAccession"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
