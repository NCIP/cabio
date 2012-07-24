<%@ include file="/WEB-INF/jsp/init.jsp" %>

<script type="text/javascript" src="<c:url value="/js/jquery.history.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/cabio_objdetails.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.bgiframe.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.dimensions.min.js"/>"></script>
<script type="text/javascript"  src="<c:url value="/js/jquery.tooltip.js"/>"></script>

<div id="caBioSearch">

<c:choose>
<c:when test="${results.numRecords == 0}">

    <div class="caBioNav">
	   <div class="caBioNumResults">No results found</div>
    </div>
	
</c:when>
<c:otherwise>

    <div class="caBioNav">
	    <div class="caBioNavBack">
	        <a href="<%= session.getAttribute("portletURL") %>">&#171; Return to templates</a>
	    </div>
		<div class="caBioNumResults">Results <b><c:out value="${results.startRecord}"/></b> - <b>
		  <c:out value="${results.endRecord}"/></b> of <b><c:out value="${results.numRecords}"/></b> 
		  (click on a row to view details)
		</div>
    </div>
	     
</c:otherwise>
</c:choose>

<c:if test="${results.numRecords > 0}">

<div id="searchResults" class="cannedResults">

  	<c:forEach var="element" items="${results.items}">
	<c:set var="classConfig" value="${objectConfig.classes[element.key]}"/>
   
    <h3><c:out value="${classConfig.plural}" default="${element.key}"/></h3>
    <table>
    
	<tr>
	
    <c:choose>
    <c:when test="${classConfig != null}">
	    <c:forEach var="attr" items="${classConfig.summaryAttributes}">
	        <th scope="col"><c:out value="${attr.label}"/></th>
	    </c:forEach>
    </c:when>
    <c:otherwise>
        <th scope="col"><c:out value="Id"/></th>
    </c:otherwise>
    </c:choose>
	
	</tr>
	
   	<c:forEach var="item" items="${results.items[element.key]}">
   	
   	    <tr onclick="caBioResults.loadDetails(this, '<c:out value="${item._className}"/>', '<c:out value="${item.id}"/>')"
   	        onmouseover="caBioResults.changeStyle(this, 'highlight')" 
   	        onmouseout="caBioResults.changeStyle(this, '')">

	    <c:choose>
	    <c:when test="${classConfig != null}">
    
		   	<c:forEach var="attr" items="${classConfig.summaryAttributes}">
				<td>
                <script type="text/javascript">
                var v = '<c:out value="${item.displayMap[attr.name]}"/>';
                var tv = caBioCommon.trunc(v,90);
                if (tv != v) {
                    document.write('<div title="'+v+'" class="attribute">'+tv+'</div>');
                }
                else {
                    document.write(v);
                }
                </script>
				</td>
			</c:forEach>
		
	    </c:when>
	    <c:otherwise>
	       <td><c:out value="${item.id}"/></td>
		</c:otherwise>
		</c:choose>
			
	  	</tr>
	</c:forEach>
	
    </table>
    
</c:forEach>

<div id="pager"></div>

<script type="text/javascript">

<c:if test="${results.numPages > 1}">
    var pager = caBioCommon.createPager(<c:out value="${results.numPages}"/>, <c:out value="${results.page+1}"/>, "caBioResults");
    jQuery("#pager").append(pager);
</c:if>

var caBioResults = function() {
	return {
	
	loadSearch : function (page) {
        jQuery(".query #page").val(page-1);
		jQuery(".query form").submit();
	},
	
    changeStyle : function (obj, newClass) {
        if (!caBioCommon.isUIEnabled()) return;
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

<div id="caBioDetails" style="display: none">
    <div class="caBioNav"></div>
    <div id="objectDetails"></div>
</div>

</c:if>
