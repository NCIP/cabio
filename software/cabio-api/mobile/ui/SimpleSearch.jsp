<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<html>
<head>
    <title>caBIO Mobile App</title>
    <link href="css/cabio_portlet.css" type="text/css" rel="stylesheet" />
    <link href="css/base.css" type="text/css" rel="stylesheet" />
    <script type="text/javascript" src="js/cabio_common.js"></script>
<script type="text/javascript" src="js/jquery-1.2.3.min.js"></script>
<script type="text/javascript" src="js/jquery.bgiframe.js"></script>
<script type="text/javascript" src="js/jquery.dimensions.min.js"></script>
<script type="text/javascript" src="js/jquery.suggest.js"></script>
<script type="text/javascript" src="js/cabio_formats.js"></script>
<script type="text/javascript" src="js/cabio_objdetails.js"></script>
<script type="text/javascript" src="js/jquery.history.js"></script>
        
<script language="Javascript">
 function resizeControls(){
      var clientWidth = document.body.clientWidth;
      var clientHeight = document.body.offsetHeight;      
      var searchBtnWidth = document.getElementById("searchButton").offsetWidth;
      var keywordInput = document.getElementById("searchText");            
      keywordInput.style.width =  clientWidth - searchBtnWidth -10;
      
      //var searchResultsDiv = document.getElementById("searchResults");  
      //searchResultsDiv.style.width = clientWidth;
      //searchResultsDiv.style.height = clientHeight - 145;
      //searchResultsDiv.style.overflow = "auto";
 }
</script>
        
</head>
<body onResize='resizeControls()' onload='resizeControls()'>

<script>
var PROXY_URL="GetXML";
var GETHTML_URL="GetHTML?query=";
var objectDetailArray = [];
var caBioSimpleSearch = function() {

	// Current state
	var currPage = 1;
    var pageSize = 5;
	var searchString = '';
	
	/**
	 * Concatenate the values of the specified attributes.
	 * @param p hash of attribute names -> values
	 * @param f array of attribute names
	 */
	function concatFields(p, f) { 
	    var r = '';
	    var i = 0;
	    for(k in f) {
	        if (p[f[k]] != undefined) {
	            if (i++>0) r+=", ";
	            r += p[f[k]];
	        }
	    }
	    return r;
	}
	
	function doSearch(page) {
	    currPage = page;
	        
	    searchString = jQuery.trim(jQuery("#searchText").val());
	    
	    if (searchString == '') {
	    	jQuery("#searchResults").empty();
            jQuery("#cabioNav").hide();
	        return;
	    }
	    
        caBioCommon.enabledUI(false);
	     
        // remove special FreestyleLM syntax chars and collapse spaces
	    caBioCommon.searchWords = caBioCommon.tokenize(searchString.replace(
		    new RegExp("(\\\\|\\+|\\-|\\&|\\||\\!|\\(|\\)|\\{|\\}|\\[|\\]|\\^|~|\\*|\\?|\\:)\\s?","g")," ").replace(
		    new RegExp("\\s+","g")," "));
	
	    // add AND if the query string is not already a quoted phrase
	    if (jQuery("#matchAll").is(":checked")) {
	        var a = caBioCommon.tokenize(searchString);
	        for (i in a) if (a[i].match(" ")) a[i] = '"'+a[i]+'"';
	        searchString = a.join(' AND ');
	    }
	    var exclude = jQuery.trim(jQuery("#exclude").val()).replace(
	    				new RegExp("\\s+")," ").split(" ").join(" -");
	    if (exclude) searchString += " -"+exclude;
	   
	    var sh = jQuery("#viewObjects").is(":checked") ? '[@queryType=HIBERNATE_SEARCH]' : '';
	    
	    pageSize = parseInt(jQuery("#pageSize").val());
	    
	    var data = 
	       'query=SearchQuery&SearchQuery[@keyword='+
            searchString+']'+sh+'&pageSize='+
            pageSize+'&startIndex='+((page-1)*pageSize);
	              
	    //jQuery("#debug").append(PROXY_URL+"?"+data)	   
	    jQuery.ajax({ 
	        type: "GET", dataType: "xml", url: PROXY_URL, data: data,
	        success: processResults
	    });
	}
	
	function processResults(xml) {
		   
	    jQuery("#searchResults").empty();
	    
	    qr = jQuery("queryResponse",xml);
	    if (qr.length == 0) {
	        var summary = '<div id="summary">No results found for <b>'+searchString+'</b></div>';
	        jQuery("#cabioNav").empty().append(summary).show();
	    }
	    else {
	        var numRecords = parseInt(jQuery("recordCounter:first",qr).text());
	        var startRecord = parseInt(jQuery("start:first",qr).text());
	        var endRecord = parseInt(jQuery("end:first",qr).text());
            var numPages = Math.ceil(numRecords / pageSize);
	
	        var summary = '<div id="summary">Results <b>'+startRecord+'</b> - <b>'
	                +endRecord+'</b> of <b>'+numRecords+'</b> for <b>'+searchString+'</b></div>';
	        jQuery("#cabioNav").empty().append(summary).show();
	
	        // Attempt to show enough text to fill the current portlet width
	        var width = jQuery("#cabio")[0].offsetWidth;
	        // The conversion numbers are based on linear regression of the 
	        // following "optimal" line lengths establised by experimentation
	        // with different portal layouts:
	        //   columns  width  maxTitleLen  maxDescLen
	        //   50/50    465    70           170
	        //   70/30    665    100          240
	        //   100/0    970    150          350
	        maxTitleLen = parseInt(width*0.15);
	        maxDescLen = parseInt(width*0.36);
		     		    
		    objectDetailArray = [];  // reset the array		      
	        jQuery("class", qr).each(function(){
	
	            var r = caBioCommon.processClassNode(this);
	            objectDetailArray[ r.className + '_' +r.id] = r;
	
	            var f = jQuery("#viewSimple").is(":checked") ? 
	                caBioFormats.summary[r.className] : undefined;
	
	            var title = '';
	            var desc = '';
	            
	            if (f != undefined) {
	                title = caBioCommon.highlight(caBioCommon.trunc(concatFields(r.properties, f['title']), maxTitleLen), caBioCommon.searchWords);
	                desc = caBioCommon.highlight(caBioCommon.trunc(concatFields(r.properties, f['desc']), maxDescLen), caBioCommon.searchWords);
	            }
	            else {
	                for(k in r.properties) {
	                    if ((k.substring(0,1) != '_') && (k != 'id')) {
	                        desc += k+': '+caBioCommon.highlight(caBioCommon.trunc(caBioCommon.escapeXML(r.properties[k]),maxDescLen), caBioCommon.searchWords)+"<br/>";
	                    }
	                }
	            }
	
	            if (title == '') title = r.className+'#'+r.id;
	
	            //detailsUrl = GETHTML_URL+r.className+'&'+r.className+'[@id='+r.id+']';
	
	            // Convert class name for display, i.e.
	            // "gov.nih.nci.cabio.domain.ClinicalTrialProtocol" to
	            // "Clinical Trial Protocol"
	            var cn = r.className;
	            cn = cn.substring(cn.lastIndexOf('.')+1);
	            cn = cn.replace(new RegExp("([A-Z])","g")," $1").substring(1);
	            	            
	            h = '<div class="result"><h2>';
	            h +='<a href="javascript:caBioObjectDetails.loadDetails2(\''+r.className+'\','+r.id+')">';
	            h += title+'</a></h2><span class="desc">'+desc+'</span>';
	            h += '<span class="className">'+cn;
	            if ( r.className == "gov.nih.nci.cabio.domain.Pathway")
	            { 
	                h +='&nbsp;(<a href="GetPathway?name=' + r.properties.name+'">SVG)</a>';
	                //h +='&nbsp;(<a href="javascript:caBioObjectDetails.loadSVG(\'' + r.properties.name+'\','+r.id+')">SVG)</a>';
	            } 
	            h +='</span>';
	            h += '</div>';
	            jQuery("#searchResults").append(h);
	            
	        })
	
	        if (numPages > 1) {
	            caBioCommon.createPager(numPages, currPage, "caBioSimpleSearch");
	            jQuery("#searchResults").append(pages);
	        }
	    }
	    
        jQuery("#objectDetails").hide();
        jQuery("#searchResults").show();
	    caBioCommon.enabledUI(true);
	}
	
	/**** public API ****/
	
	return {
		
	loadSearch : function (page) {	    
        jQuery.historyLoad("caBioSimpleSearch_search_"+page);
	},
	
	
    search : function(hash) {
        doSearch(parseInt(hash));
    }
	};
}();

</script>

<div id="cabio" width="100%" height="0" />

<s:form method="post">
<table>
<tr><td nowrap>
<input id="searchText" type="text" value="" size="33"/>
<input type="submit" value="Search" id="searchButton" onclick="caBioSimpleSearch.loadSearch(1)"/></br>
</td></tr>
<tr><td>
<a id="adv_link" href="javascript:caBioCommon.toggleDropBox2('adv_box')">Advanced Options</a>
<div id="adv_box" style="display: none">
	Match Terms:
	<input type="radio" name="matchMode" id="matchAny" checked="checked"> any 
	<input type="radio" name="matchMode" id="matchAll"> all 
	<br/>
	Exclude: <input id="exclude" type="text"/>
	<br/>
    View:
    <input type="radio" name="viewMode" id="viewSimple" checked="checked"> simple 
    <input type="radio" name="viewMode" id="viewObjects"> objects
    <br/>
	Results per page: 
	<select id="pageSize"> 
	<option value="5" selected="selected">5</option>
	<option value="10">10</option>
	<option value="15">15</option>
	</select>
</div>
</td></tr>
</table>
</s:form>

<div id="cabioNav" style="display: none"></div>
<div class="results" id="objectDetails"></div>
<!-- div class="results" id="searchResults" style="width:300;height:500;overflow:auto"></div -->
<div class="results" id="searchResults"></div>
</body>

<script language="javascript">
jQuery(document).ajaxError(caBioCommon.restError);

jQuery(document).ready(function(){

    caBioCommon.createDropBox("#adv_link");
    
    jQuery.historyInit(caBioCommon.loadFromHash);
    
    // override enabledUI function to add search form toggling
    caBioCommon.enabledUI = function (enabled) {
        if (enabled) {
            jQuery("#searchText").removeAttr("disabled");
            jQuery("#searchButton").removeAttr("disabled");
            jQuery("#searchButton").attr("value","Search");
            document.body.style.cursor = "default";
        }
        else {
            jQuery("#searchText").attr("disabled","disabled");
            jQuery("#searchButton").attr("disabled","disabled");
            jQuery("#searchButton").attr("value","Loading...");
            document.body.style.cursor = "wait";
        }
    };
});


jQuery(function() {
    jQuery("#searchText").suggest("suggest",{
         minchars:1
    });
});

</script>
</html>
    