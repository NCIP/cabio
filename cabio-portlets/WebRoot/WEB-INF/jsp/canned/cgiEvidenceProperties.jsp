<%@ include file="/WEB-INF/jsp/init.jsp" %>           
	    <table>
	       <tr><td>
	         <html:checkbox property="sentenceType" styleId="${requestScope.parent}_sentenceType">&nbsp;<label for="${requestScope.parent}_sentenceType">Include negative associations</label></html:checkbox>
	       </td></tr>
	       <tr><td>
	         <html:checkbox property="unfinishedSentence" styleId="${requestScope.parent}_unfinishedSentence">&nbsp;<label for="${requestScope.parent}_unfinishedSentence">Include unfinished curation status</label></html:checkbox>
	       </td></tr>
	       <tr><td>
	         <html:checkbox property="cellline" styleId="${requestScope.parent}_cellline">&nbsp;<label for="${requestScope.parent}_cellline">Include data collected from cell lines</label></html:checkbox>
	       </td></tr>	           
	    </table>	    	    	  
    
