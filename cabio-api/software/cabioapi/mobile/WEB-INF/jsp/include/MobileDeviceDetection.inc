<%!
  public String[] mobileTags = { "cellphone",
                                  "iemobile",
                                  "midp",
                                  "mini",
                                  "mmp",
                                  "mobile",
                                  "nokia",
                                  "pda",
                                  "phone",
                                  "pocket",
                                  "ppc",
                                  "psp",
                                  "symbian",
                                  "up.browser",
                                  "up.link",
                                  "wap",
                                  "windows ce" };
  
  public boolean isMobile( String browserInfo )
  {
    for ( int n=0; n<mobileTags.length; n++ )
    {
      if ( browserInfo.toLowerCase().contains( mobileTags[n].toLowerCase() ) )
      {
        return true;
      }
    }
    return false;
  }
%>
<%
  String bInfo = (String)request.getHeader( "User-Agent" );
  
  if ( isMobile( bInfo ) )
  {
    response.sendRedirect( "MobileHome.action" );
  }
  else
  {
    //response.sendRedirect( "home.jsp" );
  }
%>
