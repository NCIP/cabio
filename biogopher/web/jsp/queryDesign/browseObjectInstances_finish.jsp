<%@ page import="gov.nih.nci.caBIOApp.ui.pager.*,
                 gov.nih.nci.caBIOApp.sod.*,
		 gov.nih.nci.caBIOApp.util.*,
		 java.util.*" %>
<jsp:useBean id="designQueryForm" 
             scope="session"
	     class="gov.nih.nci.caBIOApp.ui.form.DesignQueryForm"/>
<% PagerItem[] items = (PagerItem[])session.getAttribute( "gov.nih.nci.caBIOApp.ui.pager.selectedItems" );
   if( items != null ){
      ArrayList vals = new ArrayList();
      String propName = (String)session.getAttribute( "browse.propName" );
      String objName = (String)session.getAttribute( "browse.objName" );
      SODUtils sod = SODUtils.getInstance();
      SearchableObject so = sod.getSearchableObject( objName );
      List labelProps = so.getLabelProperties();
      int idx = -1;
      for( int i = 0; i < labelProps.size(); i++ ){
         String s = (String)labelProps.get( i );
         if( propName.equals( s ) ){
	    idx = i;
	    break;
	 }
      }
      if( idx > -1 ){
         for( int i = 0; i < items.length; i++ ){
	    /*
	    MessageLog.printInfo( "The values in items[" + i + "]:" );
	    String[] vs = items[i].getValues();
	    for( int j = 0; j < vs.length; j++ ){
	      MessageLog.printInfo( vs[j] );
	    }
	    */
	    String val = items[i].getValues()[idx];
	    if( val != null && !"".equals( val ) ){
	       vals.add( val );
	    }
	    //MessageLog.printInfo( "The value in vals[" + i + "]=" + vals[i] );
	    
	 }
	 designQueryForm.setSelectedValues( (String[])vals.toArray( new String[vals.size()] ) );
	 designQueryForm.setUpdateOperation( "add" );
	 designQueryForm.updateCriterion();
      }else{
         throw new JspException( "no index for " + propName );
      }
   }else{
      MessageLog.printInfo( "browseObjectInstances_finish.jsp: no items selected" );
   }
%>
<html>
<head>
<META HTTP-EQUIV="Expires" CONTENT="Fri, Jun 12 1981 08:20:00 GMT">
<META HTTP-EQUIV="Pragma" CONTENT="no-cache">
<META HTTP-EQUIV="Cache-Control" CONTENT="no-cache">
</head>
<script language="javascript">
 window.top.opener.updateCriterion( window.top.opener.top.topPanel.designQueryForm, "add" );
 window.top.close();
</script>
</html>
