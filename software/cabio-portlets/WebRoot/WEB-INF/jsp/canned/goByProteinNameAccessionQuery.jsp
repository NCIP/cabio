<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_genomics_gobysymbol" class="query">

    <html:form action="/cabioportlet/goByProteinNameAccessionQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Protein Name or UniProt Accession"><label for="queries_genomics_gobysymbol_proteionNameAccession">Protein Name or UniProt Accession</label><br></td><td>
    <html:text property="proteinNameAccession" size="20" styleId="queries_genomics_gobysymbol_proteionNameAccession"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
