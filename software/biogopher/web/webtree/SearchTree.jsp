<%
    String skin = (String) request.getParameter("skin");    
    if (skin != null && skin.equals("null")) skin = null;
    if (skin == null) skin = "default";
    
%>

<html>
<head>
  <link rel="stylesheet" type="text/css" href="skins/<%=skin%>/SearchTree.css"/>
</head>
<body>
<table>
      <form name="search" action="SearchResults.jsp?skin=<%=skin%>" target="searchResults">
        <tr>
          <td>
            <table>
       
              <tr>
                <td>Search:</td>
                <td><input name="searchTerm" size="25"/>&nbsp;<INPUT type="submit" name="search" value="Search"/></td>
              </tr>
              <tr>              
                <td>&nbsp;</td> 
                <td>
                  <INPUT type="checkbox" name="matchwholewords" value="checked"/>&nbsp;Match Entire Search Terms Only
                </td>                   
              </tr>
            </table>
          </td>
        </tr>
      </form>  
</table>
</body>
</html>
