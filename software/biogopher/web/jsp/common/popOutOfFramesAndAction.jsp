<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%
  String newURL = request.getContextPath() + state.getAction() + ".do?" +
                  "nextStep=" + state.getNextStep() + "&" +
		  "lastStep=" + state.getLastStep();
%>
<script language="javascript">
 window.top.location = '<%= newURL %>';
</script>
