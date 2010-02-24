<%@ include file="/WEB-INF/jsp/init.jsp" %>
           
	    <table>
	       <tr><td>
	         <html:checkbox property="sentenceType">Include negative associations</html:checkbox>
	       </td></tr>
	       <tr><td>
	         <html:checkbox property="unfinishedSentence">Include associations with unfinished curation status</html:checkbox>
	       </td></tr>
	       <tr><td>
	         <html:checkbox property="cellline">Data was collected from a cell line</html:checkbox>
	       </td></tr>	           
	    </table>	    	    	  
    
