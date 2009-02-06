<%@page contentType="text/html"%>
<HTML>
<HEAD>
<title>SearchIndex</title>
</HEAD>
<BODY>


<%@ page import="gov.nih.nci.search.*,
		 gov.nih.nci.system.web.util.*,			 
		 java.util.*" %>
<%

	String searchString = request.getParameter("searchString")!= null?request.getParameter("searchString"):"";
	String queryType = request.getParameter("FULL_TEXT_SEARCH")!= null?request.getParameter("FULL_TEXT_SEARCH"):"";
	String fuzzySearch = request.getParameter("FUZZY_SEARCH")!= null?"true":"false";
	String pageSize = request.getParameter("PAGE_SIZE")!= null?request.getParameter("PAGE_SIZE"):"";	
	String startIndex = request.getParameter("startIndex")!= null?request.getParameter("startIndex"):"";	
	String words = request.getParameter("WORDS")!= null?request.getParameter("WORDS"):"";	
	String exclude = request.getParameter("EXCLUDE_TEXT")!= null?request.getParameter("EXCLUDE_TEXT"):"";	
	String excludeReplacement = null;
	if ( exclude !=null )
	{	
        excludeReplacement= exclude.trim().replaceAll("[ \t,]+", " -");
    } 
	
	
	IndexSearchUtils searchUtils = new IndexSearchUtils();
	SearchQuery searchQuery = null;
	String url = request.getContextPath()+"/IndexService";
	String httpurl = "";
	
	if(startIndex.equals("") && searchString.equals("")){
	    url = request.getContextPath()+"/indexSearch.jsp";	   
	}else if(!startIndex.equals("") && searchString.equals("")){
	    //check if session is valid
	    if(session.getAttribute("indexSearchUtils")!=null){
	        searchUtils = (IndexSearchUtils)session.getAttribute("indexSearchUtils");
	        searchUtils.setStartIndex(Integer.parseInt(startIndex));
	    }else{
	        url = request.getContextPath()+"/indexSearch.jsp";	
	    }
	}else {	    
	    searchQuery = new SearchQuery();
	    Sort sorter = new Sort();
	    sorter.setSortByClassName(new Boolean(true));
	    searchQuery.setSort(sorter);
	    String query = "";
	    if(!words.equals("")){
	    	for(StringTokenizer st = new StringTokenizer(searchString," ");st.hasMoreTokens();){
	    		String token = st.nextToken();
	    		if(words.equals("WITH_ALL") && exclude.equals("")){
				query+= "+" + token +" ";
	    		}else if(words.equals("WITH_ALL") && exclude.length()>0){
	    			if(token.equalsIgnoreCase(exclude)){
	    				query += "-"+token +" "; 
	    			}else{
	    				query += "+"+token +" ";
	    			}	    			
	    		}else if(words.equals("WITH_ANY") && exclude.length()>0){
	    			if(token.equalsIgnoreCase(exclude)){
	    				query += "-"+token +" "; 
	    			}else{
	    				query += token +" ";
	    			}   
	    		}	    	    	
	    	}	    	
	    	
	    }
	  
	    if(query.equals("")){
	    	query = searchString;
	    	if(!exclude.equals("")){
	    		if(query.toLowerCase().indexOf(exclude.toLowerCase())<0){
	    			query = "-"+ searchString;
	    		}else{
	    			query += " -"+ excludeReplacement;
	    		}	    		
	    	}
	    	searchQuery.setKeyword(query);
	    }else{
	    	if(!exclude.equals("")){
	    		if(query.toLowerCase().indexOf(exclude.toLowerCase())<0){
	    			query += "-"+ excludeReplacement;
	    		}
	      	}
	      	searchQuery.setKeyword(query);	    	
	    }
	    
	    if(pageSize.length()>0){            	
	    	       searchUtils.setPageSize(Integer.parseInt(pageSize));
        }
        if(fuzzySearch!=null){
        		searchQuery.setFuzzySearch(Boolean.valueOf(fuzzySearch).booleanValue());
        }
            
            
        if (searchString.startsWith("hdl://")){
            url = request.getContextPath()+"/GetHTML?query=gov.nih.nci.search.GridIdQuery&gov.nih.nci.search.GridIdQuery[@bigId="+
              searchString+"]&pageSize="+searchUtils.getPageSize();
        
        }
	    else if(queryType.equals("")){
	    
	        searchQuery.setQueryType("HIBERNATE_SEARCH");
	        
	        String postfix = "";
	        if(fuzzySearch.equalsIgnoreCase("true")){
	           postfix = "%7E";
	        }
	        
        	url = request.getContextPath()+"/GetHTML?query=gov.nih.nci.search.SearchQuery&gov.nih.nci.search.SearchQuery[@keyword="+
        	  searchString+postfix+"][@queryType=HIBERNATE_SEARCH]&pageSize="+searchUtils.getPageSize();
	        
        }  
      
	      
	}
	
    if(searchQuery != null){
        searchUtils.setSearchQuery(searchQuery);
    }
	session.setAttribute("indexSearchUtils", searchUtils);	
	response.sendRedirect(url);		

%>



</BODY>
</HTML>