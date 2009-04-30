<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_genomics_gobysymbol" class="query">

    <html:form action="/cabioportlet/goByProteinNameAccessionQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Protein Name or Accession">Protein Name or Uniprot Accession<br></td><td>
    <html:text property="proteinNameAccession" size="20"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
