<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_range_grid" class="query">

    <html:form action="/cabioportlet/gridRangeQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Grid identifier (bigid) of a genomic feature">Grid Id</td><td>
    <html:text property="gridId" size="40"/>
    </td></tr>

    <tr><td title="Distance downstream from the feature to search">Downstream Distance</td><td>
    <html:text property="downstreamPad" size="10"/>
    </td></tr>

    <tr><td title="Distance upstream from the feature to search">Upstream Distance</td><td>
    <html:text property="upstreamPad" size="10"/>
    </td></tr>

    <tr><td title="Genomic feature type(s) to view">Display</td><td>
    <html:select property="classFilter">
    <html:option value="">All</html:option>
    <html:optionsCollection property="classFilterValues" value="value" label="label"/>
    </html:select>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
