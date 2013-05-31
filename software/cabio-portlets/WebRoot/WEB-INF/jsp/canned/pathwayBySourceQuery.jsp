<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_pathwayBySource" class="query">

    <html:form action="/cabioportlet/pathwayBySourceQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Pathway Source"><label for="pathwaySource">Pathway Source</label></td><td>
    <html:select property="pathwaySource" styleId="pathwaySource">
    <html:option value="">Select...</html:option>
    <html:optionsCollection name="globalQueries" property="pathwaySources" label="name"/>
    </html:select>
    </td></tr>
    
    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
