<%@ page import="gov.nih.nci.caBIOApp.ui.*,
	         gov.nih.nci.caBIOApp.util.*" %>
<%
WorkflowState state = (WorkflowState)session.getAttribute( UIConstants.WORKFLOW_STATE_KEY );
int numPops = 100;
String numPopsStr = request.getParameter( "numPops" );
if( numPopsStr != null ){
 numPops = Integer.parseInt( numPopsStr );
}
StringBuffer sb = new StringBuffer( "Popping: " );
for( int i = 0; i < numPops && state.isNested(); i++ ){
 sb.append( state.getAction() );
 state.popState();
 if( i + 1 < numPops && state.isNested() ){
  sb.append( " -> " );
 }
}
String nextLoc = state.getAction() + ".do";
MessageLog.printInfo( sb.toString() );
MessageLog.printInfo( "Forwarding to: " + nextLoc );
%>
<jsp:forward page="<%=nextLoc%>"/>