<%
    String treeClass      = (String) request.getParameter("treeClass");
    String treeParams     = (String) request.getParameter("treeParams");
    String skin           = (String) request.getParameter("skin");
    String treeDirective  = (String) request.getParameter("treeDirective");
    
    if (skin != null && skin.equals("null")) skin = null;
    if (skin == null) skin = "default";

    // URL encode parameters
    if (treeClass != null) treeClass = java.net.URLEncoder.encode(treeClass);    
    if (treeParams != null) treeParams = java.net.URLEncoder.encode(treeParams);    
    if (skin != null) skin = java.net.URLEncoder.encode(skin);    
    if (treeDirective != null) treeDirective = java.net.URLEncoder.encode(treeDirective);    

    
%>

<HTML>
<script language="JavaScript1.2" src="skins/<%=skin%>/JavaScript.js"></script>
<HEAD>
<TITLE>NCI Center for Bioinformatics</TITLE>
<META http-equiv="Content-Type" content="text/html;">
</HEAD>
<frameset name="master" rows="126,*" cols="*" framespacing="0" frameborder="no" border="0" bordercolor="0">
  <frame src="skins/<%=skin%>/TopHeader.html" name="headerFrame" frameborder="no" scrolling="no" noresize marginwidth="0" marginheight="0" id="headerFrame">
  <frameset cols="400, *" framespacing="5" frameborder="yes" border="5" bordercolor="#660099">
    <frameset rows="160,*" framespacing="5" frameborder="yes" border="5" bordercolor="#660099">
      <frameset rows="52,*" frameborder="NO" border="0" framespacing="0">
        <frame src="skins/<%=skin%>/SearchHeader.html" name="searchHeader" scrolling="NO" noresize id="searchHeader" >
        <frame src="SearchTree.jsp?skin=<%=skin%>" name="searchInput" frameborder="no" scrolling="no" marginwidth="10" marginheight="10" id="searchContent">
      </frameset>
      <frameset rows="52,*" frameborder="NO" border="0" framespacing="0">
        <frame src="skins/<%=skin%>/ResultsHeader.html" name="resultsHeader" frameborder="no" scrolling="NO" noresize marginwidth="0" id="resultsHeader" >
        <frame src="SearchResults.jsp?skin=<%=skin%>" name="searchResults" frameborder="no" marginwidth="15" marginheight="10" id="resultsContent">
      </frameset>
    </frameset>
    <frameset rows="52,*" frameborder="NO" border="0" framespacing="0">
      <frame src="skins/<%=skin%>/TreeBrowserHeader.html" name="treeHeader" scrolling="NO" noresize id="treeHeader" >
      <frame src="WebTreeLoader.jsp?treeClass=<%=treeClass%>&treeParams=<%=treeParams%>&skin=<%=skin%>&treeDirective=<%=treeDirective%>" name="tree" frameborder="no" marginwidth="20" marginheight="10" id="treeContent">
    </frameset>
  </frameset>
</frameset>
<noframes></noframes>    

</HTML>
