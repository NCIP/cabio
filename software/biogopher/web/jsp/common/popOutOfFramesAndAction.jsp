<%
  String newURL = request.getContextPath() + state.getAction() + ".do?" +
                  "nextStep=" + state.getNextStep() + "&" +
		  "lastStep=" + state.getLastStep();
%>
<script language="javascript">
 window.top.location = '<%= newURL %>';
</script>
