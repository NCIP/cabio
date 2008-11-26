<%@ include file="/WEB-INF/jsp/init.jsp" %>

<div class="cannedResults">
<c:choose>
<c:when test="${results == null || results.numRecords == 0}">

	<div class="summary">No results found</div>
	
</c:when>
<c:otherwise>

	<div class="summary">Results <b><c:out value="${results.startRecord}"/></b> - <b>
	  <c:out value="${results.endRecord}"/></b> of <b><c:out value="${results.numRecords}"/></b>
	</div>
	      
  	<c:forEach var="element" items="${results.items}">
	<c:set var="classConfig" value="${objectConfig.classes[element.key]}"/>
   
    <h3><c:out value="${classConfig.label}"/></h3>
    <table>
	<tr>
	
   	<c:forEach var="attr" items="${classConfig.attributes}">
		<th><c:out value="${attr.label}"/></th>
	</c:forEach>
	
	<th>Details</th>
	</tr>
	
   	<c:forEach var="item" items="${results.items[element.key]}">
	  	<tr>
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
			    <div><c:out value="${item[attr.name]}"/></div>
			</c:otherwise>
			</c:choose>
			</td>
		</c:forEach>
		<td>
		    <div class="link-extenal" style="text-align: right">
                <a href="<bean:message key="cabio.restapi.url"/>GetHTML<c:out value="${item._querystr}"/>" target="_blank">
                    <c:out value="${item.id}"/></a>
            </div>
        </td>
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
	}
	};
}();

</script>

</c:otherwise>
</c:choose>
</div>
