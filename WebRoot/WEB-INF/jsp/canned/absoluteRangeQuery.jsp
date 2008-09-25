<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div id="queries_range_absolute" class="query">

    <html:form action="/cabioportlet/absoluteRangeQuery">
    <html:hidden property="page" styleId="page"/>

    <bean:define id="absoluteRangeQueryForm" name="AbsoluteRangeQueryForm" 
            type="gov.nih.nci.cabio.portal.portlet.canned.AbsoluteRangeQueryForm"/>

    <script language="javascript">
    var taxonChromosomes = {
    <c:forEach var="taxon" varStatus="status"
        items="${globalQueries.taxonValues}">
        
        '<c:out value="${taxon.abbreviation}"/>' : [
            <c:forEach var="chrom" varStatus="innerStatus"
                items="${globalQueries.taxonChromosomes[taxon.abbreviation]}">
            '<c:out value="${chrom.number}"/>'<c:if test="${not innerStatus.last}">,</c:if>
            </c:forEach>
        ]<c:if test="${not status.last}">,</c:if>
        
    </c:forEach>
    }
    
    function selectChromosome(number) {
        jQuery("#queries_range_absolute_chromList option[@value='"+number+"']").attr("selected","selected")
    }
    
    function populateChromosome() {
        selectList = jQuery("#queries_range_absolute_taxonList")
        options = '<option value="">Select...</option>';
        chroms = taxonChromosomes[selectList.val()];
        for(i=0; i<chroms.length; i++) {
            options += '<option value="'+chroms[i]+'">'+chroms[i]+'</option>';
        }
        jQuery("#queries_range_absolute_chromList").empty().append(options);
        selectChromosome('1');
    }
    
    function selectTaxon(taxon) {
        jQuery("#queries_range_absolute_taxonList option[@value='"+taxon+"']").attr("selected","selected")
        populateChromosome();
    }
    
    jQuery(document).ready(function(){
        selectTaxon('<c:out value="${absoluteRangeQueryForm.taxon}"/>');
        selectChromosome('<c:out value="${absoluteRangeQueryForm.chromosomeNumber}"/>');
    });

    </script>
    
    <table>

    <tr><td title="Species or taxon">Species</td><td>
    <html:select property="taxon" styleId="queries_range_absolute_taxonList" onchange="populateChromosome(this)">
    <html:option value="">Select...</html:option>
    <html:optionsCollection name="globalQueries" property="taxonValues" 
                            value="abbreviation" label="scientificName"/>
    </html:select>
    </td></tr>
    
    <tr><td title="Chromosome number">Chromosome</td><td>
    <html:select property="chromosomeNumber" styleId="queries_range_absolute_chromList">
    </html:select>
    </td></tr>

    <tr><td title="Genome assembly">Assembly</td><td>
    <html:text property="assembly" size="10"/>
    <%--
    <html:select property="assembly">
    <html:option value="">Select...</html:option>
    <html:options name="globalQueries" property="assemblyValues"/>
    </html:select>
    --%>
    </td></tr>
    
    <tr><td title="Start position on the chromosome">Start Position</td><td>
    <html:text property="start" size="10"/>
    </td></tr>

    <tr><td title="End position on the chromosome">End Position</td><td>
    <html:text property="end" size="10"/>
    </td></tr>

    <tr><td title="Genomic feature type(s) to view">Display</td><td>
    <html:select property="classFilter">
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
