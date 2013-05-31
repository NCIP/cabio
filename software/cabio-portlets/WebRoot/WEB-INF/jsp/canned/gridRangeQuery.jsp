<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_range_grid" class="query">

    <html:form action="/cabioportlet/gridRangeQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Grid identifier (bigid) of a genomic feature"><label for="gridId">Grid Id</label></td><td>
    <html:text property="gridId" size="40" styleId="gridId"/>
    </td></tr>

    <tr><td title="Genome assembly"><label for="grid_id_range_queries_assembly">Assembly</label></td><td>
    <html:select property="assembly" styleId="grid_id_range_queries_assembly">
    <html:optionsCollection name="globalQueries" property="assemblies" value="value" label="name"/>
    </html:select>
    </td></tr>
    
    <tr><td title="Distance downstream from the feature to search"><label for="grid_id_range_queries_downstreamPad">Downstream Distance</label></td><td>
    <html:text property="downstreamPad" size="10" styleId="grid_id_range_queries_downstreamPad"/>
    </td></tr>

    <tr><td title="Distance upstream from the feature to search"><label for="grid_id_range_queries_upstreamPad">Upstream Distance</label></td><td>
    <html:text property="upstreamPad" size="10" styleId="grid_id_range_queries_upstreamPad"/>
    </td></tr>

    <tr><td title="Genomic feature type(s) to view"><label for="grid_id_range_queries_classFilter">Display</label></td><td>
    <html:select property="classFilter" styleId="grid_id_range_queries_classFilter">
    <html:option value="">All</html:option>
    <html:optionsCollection name="globalQueries" property="classFilterValues" 
                            value="value" label="label"/>
    </html:select>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
