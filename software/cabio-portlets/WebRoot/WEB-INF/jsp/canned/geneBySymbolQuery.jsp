<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_genomics_genebysymbol" class="query">

    <html:form action="/cabioportlet/geneBySymbolQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Gene symbol or alias"><label for="queries_genomics_genebysymbol_geneSymbol">Gene Symbol or Alias</label></td><td>
    <html:text property="geneSymbol" size="20" styleId="queries_genomics_genebysymbol_geneSymbol"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
