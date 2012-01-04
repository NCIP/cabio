<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript">
    jQuery(document).ready(function(){
      caBioCommon.createDropBox("#evidence_link2","#evidenceproperties_box2");
    });
</script>


<div id="queries_cancer_diseasetogenes" class="query">

    <html:form action="/cabioportlet/diseaseToGenesQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Disease Name or EVS concept code Id">Disease (name or concept code)</td><td>
    <html:text property="disease" size="30"/>
    </td></tr>
    <tr><td colspan=2>
        <a id="evidence_link2">Advanced search criteria</a>
		<div id="evidenceproperties_box2" class="advancedOptions">
         <jsp:include page="/WEB-INF/jsp/canned/cgiEvidenceProperties.jsp" flush="true"/>
        </div>
    </td></tr>    
    </table>

    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
