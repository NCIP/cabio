<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript">
    jQuery(document).ready(function(){
      caBioCommon.createDropBox("#evidence_link3","#evidenceproperties_box3");
    });
</script>

<div id="queries_cancer_geneassociations" class="query">

    <html:form action="/cabioportlet/geneAssociationsQuery">
    <html:hidden property="page" styleId="page"/>

    <table>
    
    <tr><td title="Gene symbol or alias">Gene Symbol or Alias</td><td>
    <html:text property="geneSymbol" size="30"/>
    </td></tr>
    <tr><td colspan=2>
        <a id="evidence_link3">Advanced search criteria</a>
		<div id="evidenceproperties_box3">
         <jsp:include page="/WEB-INF/jsp/canned/cgiEvidenceProperties.jsp" flush="true"/>
        </div>
    </td></tr>
    </table>
    
    <html:submit>Search</html:submit>
    <html:reset>Reset</html:reset>

    </html:form>
</div>
