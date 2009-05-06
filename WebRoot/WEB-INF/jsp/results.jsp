<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript" src="<c:url value="/js/jquery.history.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/cabio_objdetails.js"/>"></script>

<script type="text/javascript"  src="<c:url value="/js/jquery.bgiframe.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.dimensions.min.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.tooltip.js"/>"></script>

<c:choose>
<c:when test="${results.numRecords == 0}">

    <div id="cabioNav">
	   <div id="summary">No results found</div>
    </div>
	
</c:when>
<c:otherwise>

    <div id="cabioNav">
	    <div id="navback">
	        <a href="<%= session.getAttribute("portletURL") %>">&#171; Return to templates</a>
	    </div>
		<div id="summary">Results <b><c:out value="${results.startRecord}"/></b> - <b>
		  <c:out value="${results.endRecord}"/></b> of <b><c:out value="${results.numRecords}"/></b> 
		  (click on a row to view details)
		</div>
    </div>
	     
</c:otherwise>
</c:choose>

<c:if test="${results.numRecords > 0}">

<div class="results" id="objectDetails"></div>
<div class="results" id="searchResults">
<div class="cannedResults">

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
			<c:when test="${attr.lastPart == 'id'}">
	                <div title="<c:out value="${item[attr.name]}"/>" class="id">
	                     <c:out value="${item[attr.name]}"/>
	                </div>			
	          </c:when>

			<c:when test="${attr.lastPart == 'pubmedId'}">
			    <div class="link-extenal" style="text-align: right">
			        <a href="http://www.ncbi.nlm.nih.gov/pubmed/<c:out value="${item[attr.name]}"/>" target="_blank">
			             <c:out value="${item[attr.name]}"/></a>
			    </div>
			</c:when>
			<c:otherwise>
				
	            <c:choose>
	            <c:when test="${fn:length(item[attr.name]) > 90}">
	                <div title="<c:out value="${item[attr.name]}"/>" class="attribute">
	                    <c:out value="${fn:substring(item[attr.name], 0, 87)}"/>
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
	  	</tr>
	</c:forEach>
	
    </table>
    
</c:forEach>

<div id="pager"></div>

<c:if test="${results.numPages > 1}">
<script language="javascript">
    var pager = caBioCommon.createPager(<c:out value="${results.numPages}"/>, <c:out value="${results.page+1}"/>, "caBioResults");
    jQuery("#pager").append(pager);
</script>
</c:if>

<script language="javascript">

var caBioResults = function() {
	return {
	
	loadSearch : function (page) {
        jQuery(".query #page").val(page-1)
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

</div>
</div>

</c:if>