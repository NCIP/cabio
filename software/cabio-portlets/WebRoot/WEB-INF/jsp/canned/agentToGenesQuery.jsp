<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="/WEB-INF/jsp/init.jsp"%>

<script type="text/javascript">
	jQuery(document).ready(function() {
		caBioCommon.createDropBox("#evidence_link", "#evidenceproperties_box");
	});
</script>

<div id="queries_cancer_agenttogenes" class="query">

	<html:form action="/cabioportlet/agentToGenesQuery">
		<html:hidden property="page" styleId="page" />

		<table>

			<tr>
				<td title="Agent name or EVS concept code"><label for="agent">Agent
						(name or concept code)</label>
				</td>
				<td><html:text property="agent" size="30" styleId="agent" /></td>
			</tr>
			<tr>
				<td colspan=2><a id="evidence_link">Advanced search
						criteria</a>
					<div id="evidenceproperties_box" class="advancedOptions">
						<c:set var="parent" value="agentToGenes" scope="request"/>
						<jsp:include page="/WEB-INF/jsp/canned/cgiEvidenceProperties.jsp"
							flush="true"/>
					</div></td>
			</tr>
		</table>

		<html:submit>Search</html:submit>
		<html:reset>Reset</html:reset>

	</html:form>
</div>
