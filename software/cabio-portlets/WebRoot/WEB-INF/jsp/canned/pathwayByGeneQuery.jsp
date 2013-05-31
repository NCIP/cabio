<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_pathwayByGene" class="query">

    <html:form action="/cabioportlet/pathwayByGeneQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Gene symbol or alias"><label for="queries_pathwayByGene_geneSymbol">Gene Symbol or Alias</label></td><td>
    <html:text property="geneSymbol" size="30" styleId="queries_pathwayByGene_geneSymbol"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
