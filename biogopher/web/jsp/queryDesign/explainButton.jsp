<% String buttonName = request.getParameter( "buttonName" ); %>
<html>
<head>
<link href="styles/common.css" rel="stylesheet" type="text/css"/>
</head>
<body class="boxCompleteDark">
<table>
 <tr>
  <td>
<div class="textMediumLight">
<% if( "addValues".equals( buttonName ) ){ %>
Adds a value to your set of working values.
<% }else if( "removeValues".equals( buttonName ) ){ %>
Removes the selected value from your set of working values.
<% }else if( "acquireValues".equals( buttonName ) ){ %>
Allows you to fetch values from one of the datasources that you supplied.
<% }else if( "browse".equals( buttonName ) ){ %>
Allows you to browse caBIO data and select values to add to your set of working values.
<% }else if( "deleteCriterion".equals( buttonName ) ){ %>
Deletes the currently selected values from your query.
<% }else if( "updateCriteria".equals( buttonName ) ){ %>
Moves your working values into the query that you are building below.
<% }else if( "cancel".equals( buttonName ) ){ %>
Cancels editing of working values without moving them into your query.
<% } %>
</div>
   </td>
  </tr>
</table>
</body>
</html>
