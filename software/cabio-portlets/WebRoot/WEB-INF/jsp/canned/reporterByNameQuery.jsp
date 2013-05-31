<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_microarray_reporterbyname" class="query">

    <html:form action="/cabioportlet/reporterByNameQuery">
    <html:hidden property="page" styleId="page"/>

    <table>

    <tr><td title="Microarray platform"><label for="queries_microarray_reporterbyname_microarrayName">Microarray</label></td><td>
    <html:select property="microarray" styleId="queries_microarray_reporterbyname_microarrayName">
    <html:option value="">Select...</html:option>
    <html:optionsCollection name="globalQueries" property="microarrays" value="name" label="description"/>
    </html:select>
    </td></tr>
    
    <tr><td title="Name of the microarray reporter"><label for="reporterId">Reporter Name</label></td><td>
    <html:text property="reporterId" size="30" styleId="reporterId"/>
    </td></tr>

    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
