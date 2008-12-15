<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript" src="<c:url value="/js/jquery.history.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/cabio_objdetails.js"/>"></script>

<script type="text/javascript"  src="<c:url value="/js/jquery.bgiframe.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.dimensions.min.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.tooltip.js"/>"></script>

<div class="results" id="objectDetails"></div>
<div class="results" id="searchResults">
<div class="cannedResults">
<c:choose>
<c:when test="${results == null || results.numRecords == 0}">

	<div class="summary">No results found</div>
	
</c:when>
<c:otherwise>

	<div class="summary">Results <b><c:out value="${results.startRecord}"/></b> - <b>
	  <c:out value="${results.endRecord}"/></b> of <b><c:out value="${results.numRecords}"/></b> 
	  (click on a row to view details)
	</div>
	      
  	<c:forEach var="element" items="${results.items}">
	<c:set var="classConfig" value="${objectConfig.classes[element.key]}"/>
   
    <h3><c:out value="${classConfig.label}"/></h3>
    <table>
    
	<tr>
	
   	<c:forEach var="attr" items="${classConfig.attributes}">
		<th><c:out value="${attr.label}"/></th>
	</c:forEach>
	
	</tr>
	
   	<c:forEach var="item" items="${results.items[element.key]}">
   	
   	    <tr onclick="caBioResults.loadDetails(this, '<c:out value="${item._className}"/>', '<c:out value="${item.id}"/>')"
   	        onmouseover="caBioResults.changeStyle(this, 'highlight')" 
   	        onmouseout="caBioResults.changeStyle(this, '')">

	   	<c:forEach var="attr" items="${classConfig.attributes}">
			<td>
			<c:choose>
			<c:when test="${attr.lastPart == 'pubmedId'}">
			    <div class="link-extenal" style="text-align: right">
			        <a href="http://www.ncbi.nlm.nih.gov/pubmed/<c:out value="${item[attr.name]}"/>" target="_blank">
			             <c:out value="${item[attr.name]}"/></a>
			    </div>
			</c:when>
			<c:otherwise>
				
	            <c:choose>
	            <c:when test="${fn:length(item[attr.name]) > 100}">
	                <div title="<c:out value="${item[attr.name]}"/>" class="attribute">
	                    <c:out value="${fn:substring(item[attr.name], 0, 97)}"/>
	                    <b>...</b>
	                </div>
	            </c:when>
	            <c:otherwise>
                    <c:out value="${item[attr.name]}"/>
	            </c:otherwise>
	            </c:choose>
			    
			</c:otherwise>
			</c:choose>
			</td>
		</c:forEach>
		<!-- 
		<td>
		    <div class="link-extenal" style="text-align: right">
                <a href="<bean:message key="cabio.restapi.url"/>GetHTML<c:out value="${item._querystr}"/>" target="_blank">
                    <c:out value="${item.id}"/></a>
            </div>
        </td>
         -->
	  	</tr>
	</c:forEach>
	
    </table>
    
</c:forEach>

<div class="pages">
<c:if test="${results.numPages > 1}">
    
	<c:if test="${results.page > 0}">
		<a href='javascript:caBioResults.loadPage(<c:out value="${results.page-1}"/>)'>Previous</a>
	</c:if>
	
	<c:forEach begin="0" end="${results.numPages-1}" varStatus="status">
	
		<c:choose>
			<c:when test='${status.index == results.page}'>
				<c:out value="${status.index+1}"/>
			</c:when>
			<c:when test='${status.index > results.page-6 && status.index < results.page+6 }'>
				<a href="javascript:caBioResults.loadPage(<c:out value="${status.index}"/>)"><c:out value="${status.index+1}"/></a>
			</c:when>
		</c:choose>
	
	</c:forEach>
	
	<c:if test="${results.page < results.numPages-2}">
		<a href='javascript:caBioResults.loadPage(<c:out value="${results.page+1}"/>)'>Next</a>
	</c:if>
	
</c:if>
</div>

<script language="javascript">

var caBioResults = function() {
	return {
	
	loadPage : function (page) {
        jQuery(".query #page").val(page)
		jQuery(".query form").submit()
	},
	
    changeStyle : function (obj, newClass) {
        obj.className = newClass;
    },
    
    loadDetails : function (obj, className, id) {
        obj.className = '';
        caBioObjectDetails.loadDetails(className, id);
    }
    
	};
}();

jQuery(document).ajaxError(caBioCommon.restError);

jQuery(document).ready(function(){
    jQuery.historyInit(caBioCommon.loadFromHash);
    jQuery(".attribute").Tooltip({
        showURL: false 
    });
});

</script>

</c:otherwise>
</c:choose>

</div>
</div>
