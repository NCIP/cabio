<%@ include file="/WEB-INF/jsp/init.jsp" %>

    <tr><td colspan=2 title="Evidence Properties">Evidence Properties</td></tr>
    <tr><td colspan=2>
	    <table>
	       <tr><td title="Sentence Types">Sentence Types</td><td>
	       <html:radio property="sentenceType" value="all">All</html:radio>
	       <html:radio property="sentenceType" value="no">Non-negated only</html:radio>
	       <html:radio property="sentenceType" value="yes">Negated only</html:radio>
	       </td></tr>
	       <tr><td colspan=2>
	         <html:checkbox property="finishedSentence">Finished sentences only (exclude unclear, no_fact, and redundant_information)</html:checkbox>
	       </td></tr>
	       <tr><td colspan=2>
	         <html:checkbox property="cellline">Data was collected from a cell line</html:checkbox>
	       </td></tr>	           
	    </table>
    </td></tr>