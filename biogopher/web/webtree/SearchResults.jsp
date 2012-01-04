<%@ page import="java.io.*"%>
<%@ page import="java.util.*" %>
<%@ page import="gov.nih.nci.ncicb.webtree.*" %>

<%
    HttpSession userSession = request.getSession();
        
    String searchTerm      = (String) request.getParameter("searchTerm");
    String matchWholeWords = (String) request.getParameter("matchwholewords");
    String skin            = (String) request.getParameter("skin");
    
    if (skin != null && skin.equals("null")) skin = null;
    if (skin == null) skin = "default";
    
    // get evs tree object from session
    BDWebTree webTree = null;
    webTree = (BDWebTree) userSession.getAttribute("webTree");
    
    // search concept tree for search term
    Vector searchResults  = null;
    Vector synonyms = null;
    
    boolean matchWholeWordsFlag = false;
            
    if (webTree != null)
    {
      if (searchTerm != null)
      {
        boolean includeSynonyms = true; 
        if (matchWholeWords != null && matchWholeWords.equals("checked"))
        {
          matchWholeWordsFlag = true;
        }
        
        searchResults = webTree.searchTree(searchTerm, includeSynonyms, matchWholeWordsFlag);
        synonyms = webTree.getSynonyms();        
      }    
    }        
%> 
<html>
<head>
  <link rel="stylesheet" type="text/css" href="skins/<%=skin%>/SearchResults.css"/>
  <script language="JavaScript1.2" src="skins/<%=skin%>/JavaScript.js"></script>
</head>
</head>
<body>
<table width="100%">
<%  
    // loop through results vector and display
    if (searchResults != null)
    {
      if (searchResults.size() > 0)
      {
%>
<%      if (synonyms != null && synonyms.size() > 1)
        {           
%>         
    <tr><td><a class="synonymsIncludedMessage" href="#synonyms">&nbsp;&nbsp;Search Results Include Alternative Terms</a></td></tr>
<%      }
%>          

    <tr width="100%"><td>        
      <table width="100%" cellpadding="5">
<%
        // results found, display them
        Enumeration resultsEnum = searchResults.elements();
        while (resultsEnum.hasMoreElements())
        {
          WebNode myWebNode = (WebNode) resultsEnum.nextElement();

          if (myWebNode != null)
          {
            String myId = myWebNode.getId();
            String myName = myWebNode.getName(); 
%>
        <tr>
<%        // render concept name 
          String linkAction = myWebNode.getAction();
          if (linkAction.length() > 0)
          { %>
          <td class="searchResult"><a class="link" target="_top" href="<%=linkAction%>"><%=myName%></a></td>                
<%        }
          else 
          { %>
          <td class="searchResult"><%=myName%></td>                
<%        }  %>

          <td  class="searchResult" width=120>
            <a class="link" target="tree" href="WebTree.jsp?targetId=<%=java.net.URLEncoder.encode(myId)%>&amp;treeAction=highlight#<%=java.net.URLEncoder.encode(myId)%>">
              <img src="skins/<%=skin%>/images/TreeHighlightUP.gif" width="97" height="18" border="0" alt="highlight this term in the data tree">
            </a>
          </td>
        </tr>                             
<%            
          }
        }        
%>
      </table>
      </td></tr>
<%
      }
      else
      {
        // results set empty..nothing found
%>
     	  <tr><td class="noMatches">No Matches Found</td></tr>   
<%    } %>

      <tr>
        <td>
<%      if (synonyms != null && synonyms.size() > 1)
        {           
%>        <a name="synonyms"></a>
          <table width="100%" height="100%" border="0" cellpadding="2" cellspacing="0" id="synonyms">
          <tr> <td height="15" <img src="images/transparent.gif" width="1" height="1" hspace="0" vspace="0" border="0"></td> </tr>
          <tr><td height="5" class="synonymsTitle">Alternate Search Terms Used</td></tr>        
          <tr> 
            <td height="100%" align="left" valign="top" class="synonyms">
<%
          Enumeration synonymsEnum = synonyms.elements();         
          int count = 0;
          while (synonymsEnum.hasMoreElements())
          { 
            count++;
            String mySynonym = (String) synonymsEnum.nextElement();
            if (!(mySynonym.toLowerCase().equals(searchTerm.toLowerCase())))
            {
              out.print(mySynonym);
              if (count < synonyms.size()) out.print("<b>&nbsp;/&nbsp;</b></font>"); 
            }
          }       
%>                                     
            </td>
         </tr>
        <tr> 
          <td height="1" class="synonymsTitle"><img src="images/transparent.gif" width="1" height="1" hspace="0" vspace="0" border="0"></td>
        </tr>
        <tr> <td height="15" <img src="images/transparent.gif" width="1" height="1" hspace="0" vspace="0" border="0"></td> </tr>
        </table>        
<%      } %>    
        </td>      
      </tr>
<%
      // get post search message if any 
      String postSearchMsg = webTree.getPostSearchMsg();
      if (postSearchMsg != null) 
      { %>
      <tr><td><%=postSearchMsg%></td></tr>                
<%    }
    }
    else
    {
      // no search performed yet %>
      <script language="JavaScript1.2">
        var now = new Date();
        var glob = now.getHours()+now.getSeconds()+now.getMilliseconds();
        var targetURL = "skins/<%=skin%>/initSearchPage.html?glob="+glob;
        window.location.href = targetURL;     
      </script>      
<%  }  %>      
  </table>
</body>
</html>
