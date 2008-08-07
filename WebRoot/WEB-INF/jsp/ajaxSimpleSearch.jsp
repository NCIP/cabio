<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<style type="text/css">
div.results {
    max-width: 450px;
}

div.result {
    margin-top: 10px;
}

div.result h2 {
    font-size: 11pt;
    font-weight: normal;
    margin: 0px;
}

div.result span.desc {
    display: block;
    font-size: 10pt;
}

div.result span.className {
    display: block;
    font-size: 10pt;
    color: #226600;
}

div.summary {
    width: 100%;
    padding: 2px;
    background: #ddf;
    border-top: 1px solid #99b;
    margin-top: 20px;
    margin-bottom: 20px;
}

div.pages {
    width: 100%;
    padding: 2px;
    margin-top: 20px;
}

div.error {
    margin-top: 20px;
    color: red;
}

table.properties {
	margin-top: 5px;
    border-collapse: collapse;
}

table.properties th {
    font-weight: normal;
    text-align: left;
	vertical-align: top;
    width: 30%;
    border: 1px solid #aaa;
	padding: 2px;
}

table.properties th.header {
	font-size: 110%;
}

table.properties td {
    font-weight: normal;
    border: 1px solid #aaa;
	padding: 2px;
}

table.properties div.value {
	max-height: 250px;
	overflow: auto;
}

a#adv_link {
    text-decoration: none;
}

div#adv_box {
    margin-left: 10px;
    margin-top: 2px;
    padding: 3px;
    display: none;
}

div.pathwayDiagram {
    display: none;
}

#modalOverlay {
  	background-color: #000;
  	cursor:wait;
}

#modalContainer {
	top: 15%;
  	left: 50%;
  	margin-left: -300px;
  	background-color:#000;
}


</style>

<script type="text/javascript" src="<c:url value="/js/jquery.history.js"/>"></script>
<script type="text/javascript" src="<c:url value="/js/jquery.simplemodal-1.1.1.js"/>"></script>

<!-- 
<script type="text/javascript" src="everything_unpacked.js"></script>
<script type="text/javascript" src="jquery.history.js"></script>
<script type="text/javascript" src="jquery.simplemodal-1.1.1.js"></script>
 -->
 

<script language="javascript">

jQuery(document).ajaxError(function(e, req, settings){
    
    caBioSimpleSearch.enabledUI(true);
    
    r = req.responseText
    if (r.match(/caCORE HTTP Servlet Error/)) {
        // Yes, this is next part is very fragile, but 
        // the SDK's error handling doesn't leave us with much choice
        error = r.split('\r\n')[3]
    }
    else {
        error = 'Unknown error'
    }

    sr = jQuery("#searchResults")
    sr.empty()
    sr.append('<div class="error">'+error+'</div>')

    // log the error if possible
    if (window.console && window.console.error) {
        document.body.style.cursor = "default";
        console.error(arguments);
    }
});

jQuery(document).ready(function(){
    caBioSimpleSearch.showAdvOptions();
    jQuery.historyInit(caBioSimpleSearch.loadFromHash);
});

</script>

<script language="javascript">
    
var caBIO_DomainFormats = {
    "gov.nih.nci.cabio.domain.Agent":{
        "title":["EVSId"],
        "desc":["name","comment"]
    },
    "gov.nih.nci.cabio.domain.Anomaly":{
        "title":["description"]
    },
    "gov.nih.nci.cabio.domain.ClinicalTrialProtocol":{
        "title":["title"],
        "desc":["leadOrganizationId","leadOrganizationName"]
    },
    "gov.nih.nci.cabio.domain.DiseaseOntology":{
        "title":["EVSId"],
        "desc":["name"]
    },
    "gov.nih.nci.cabio.domain.Evidence":{
        "title":["sentence"],
        "desc":["comments"],
        "ids":["pubmedId"]
    },
    "gov.nih.nci.cabio.domain.Gene":{
        "title":["symbol"],
        "desc":["fullName"]
    },
    "gov.nih.nci.cabio.domain.GeneAlias":{
        "title":["name"],
        "desc":["type"]
    },
    "gov.nih.nci.cabio.domain.GeneOntology":{
        "title":["name"]
    },
    "gov.nih.nci.cabio.domain.Histopathology":{
        "title":["grossDescription"],
        "desc":["comments"]
    },
    "gov.nih.nci.cabio.domain.Library":{
        "title":["name"],
        "desc":["keyword"]
    },
    "gov.nih.nci.cabio.domain.Microarray":{
        "title":["manufacturer","name"],
        "desc":["description"]
    },
    "gov.nih.nci.cabio.domain.OrganOntology":{
        "title":["name"]
    },
    "gov.nih.nci.cabio.domain.Pathway":{
        "title":["name", "displayValue"],
        "desc":["description"]
    },
    "gov.nih.nci.cabio.domain.Protein":{
        "title":["primaryAccession","name"],
        "desc":["keywords"]
    },
    "gov.nih.nci.cabio.domain.ProteinAlias":{
        "title":["name"]
    },
    "gov.nih.nci.cabio.domain.Protocol":{
        "title":["name"],
        "desc":["type"]
    },
    "gov.nih.nci.cabio.domain.ProtocolAssociation":{
        "title":["CTEPNAME"],
        "desc":["diseaseCategory"]
    },
    "gov.nih.nci.cabio.domain.Tissue":{
        "title":["name", "displayValue"],
        "desc":["description"]
    },
    "gov.nih.nci.cabio.domain.Vocabulary":{
        "title":["coreTerm"],
        "desc":["generalTerm"]
    }
}

</script>

<script language="javascript">

var caBioSimpleSearch = function() {

	var proxyUrl = "/cabioportlets/proxy";
	//proxyUrl = "/cgi-bin/proxy.py";
	
	var downBlueImg = "<c:url value='/images/down_arrow_blue.png'/>";
	var downGreyImg = "<c:url value='/images/down_arrow_grey.png'/>";
	//downBlueImg = "down_arrow_blue.png";
	//downGreyImg = "down_arrow_grey.png";
	
	var PAGE_SIZE = 5;
	var MAX_TITLE_LEN = 60;
	var MAX_DESC_LEN = 150;
	var GETHTML_URL = "http://cabioapi.nci.nih.gov/cabio41/GetHTML?query=";

	// Current state
	var currPage = 1;
	var searchWords = [];
	var searchString = '';
	var searchResults = '';
	
	/**
	 * Utililty function to check for Adobe SVG viewer
	 */
	function isASVInstalled() {
		try {
			var asv = new ActiveXObject("Adobe.SVGCtl");
			return true;
		}
		catch(e) { }
		return false;
	}

	/**
	 * Concatenate the values of the specified attributes.
	 * @param p hash of attribute names -> values
	 * @param f array of attribute names
	 */
	function concatFields(p, f) { 
	    var r = ''
	    i = 0
	    for(k in f) {
	        if (p[f[k]] != undefined) {
	            if (i++>0) r+=", "
	            r += p[f[k]]
	        }
	    }
	    return r
	}
	
	/**
	 * Escape the given XML (or HTML) so that it can be shown on the web page.
	 */
	function escapeXML(xml) {
	    return xml.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;")
	}
	
	/** 
	 * Truncate the given label to the specified length, 
	 * ending with a bold ellipsis.
	 * @param label the label to truncate
	 * @param len the maximum length for labels
	 */
	function trunc(label, len) {
	    if (label.length > len) {
	        return label.substring(0, len-3) + "<b>...</b>"
	    }
	    return label
	}
	
	/**
	 * Highlight occurances of text in the given label.
	 */
	function highlight(label, wordList) {
	    h = label
	    for(var i=0; i<wordList.length; i++) {
	        h = h.replace(new RegExp("("+wordList[i]+")","gi"), "<b>$1</b>")
	    }
	    return h
	}
	
	function doSearch(page) {
	
	    currPage = page
	        
	    var searchText = jQuery.trim(jQuery("#searchText").val())
	    
	    if (searchText == '') {
	    	jQuery("#searchResults").empty()
	        return
	    }
	   
	    searchString = searchText
	    searchWords = searchString.replace(new RegExp("\\s+")," ").split(" ")
	
	    if (jQuery("#matchall").is(":checked")) {
	        searchString = "+"+searchWords.join(" +")
	    }
	    var exclude = jQuery.trim(jQuery("#exclude").val()).replace(
	    				new RegExp("\\s+")," ").split(" ").join(" -")
	    if (exclude) searchString += " -"+exclude
	
	    caBioSimpleSearch.enabledUI(false)
	    var sh = jQuery("#searchHibernate").is(":checked") ? '[@queryType=HIBERNATE_SEARCH]' : ''
	    
	    var data = 'query=SearchQuery&SearchQuery[@keyword='+
	              searchString+']'+sh+'&pageSize='+
	              PAGE_SIZE+'&pageNumber='+page
	              
	    //jQuery("#debug").append(proxyUrl+"?"+data)
	    
	    jQuery.ajax({ 
	        type: "GET", dataType: "xml", url: proxyUrl, data: data,
	        success: processResults
	    })
	}
	
	function processResults(xml) {
	
	    jQuery("#searchResults").empty()
	    
	    qr = jQuery("queryResponse",xml)
	    if (qr.length == 0) {
	        r = '<div class="summary">No results found for <b>'+searchString+'</b></div>'
	        jQuery("#searchResults").append(r)
	    }
	    else {
	        numPages = parseInt(jQuery("pages",qr).attr("count"))
	        numRecords = parseInt(jQuery("recordCounter",qr).text())
	        startRecord = parseInt(jQuery("start",qr).text())
	        endRecord = parseInt(jQuery("end",qr).text())
	
	        summary = '<div class="summary">Results <b>'+startRecord+'</b> - <b>'
	                +endRecord+'</b> of <b>'+numRecords+'</b> for <b>'+searchString+'</b></div>'
	        jQuery("#searchResults").append(summary)
	
	        jQuery("class", qr).each(function(){
	
	            var r = processClassNode(this)
	
	            var f = jQuery("#searchFormat").is(":checked") ? 
	                caBIO_DomainFormats[r.className] : undefined
	
	            var title = '';
	            var desc = '';
	            
	            if (f != undefined) {
	                title = highlight(trunc(concatFields(r.properties, f['title']), MAX_TITLE_LEN), searchWords)
	                desc = highlight(trunc(concatFields(r.properties, f['desc']), MAX_DESC_LEN), searchWords)
	            }
	            else {
	                for(k in r.properties) {
	                    if ((k.substring(0,1) != '_') && (k != 'id')) {
	                        desc += k+': '+highlight(trunc(escapeXML(r.properties[k]), MAX_DESC_LEN), searchWords)+"<br/>"
	                    }
	                }
	            }
	
	            if (title == '') title = r.className+'#'+r.id
	
	            detailsUrl = GETHTML_URL+r.className+'&'+r.className+'[@id='+r.id+']'
	
	            h = '<div class="result"><h2><a href="javascript:caBioSimpleSearch.loadDetails(\''+r.className+'\','+r.id+')">'
	            h += title+'</a></h2><span class="desc">'+desc+'</span>'
	            h += '<span class="className">'+r.className+'</span>' 
	            h += '</div>'
	            jQuery("#searchResults").append(h)
	            
	        })
	
	        if (numPages > 1) {
	
	            var rp = ''
	            var i
	            for(i=1; i<=numPages; i++) {
	                if (i == currPage) {
	                    rp += ' '+i
	                }
	                else if ((i > currPage-6) && (i < currPage+6)) {
	                    rp += ' <a href="javascript:loadSearch('+i+')">'+i+'</a>'   
	                }
	            }
	
	            prev = (currPage > 1)?"<a href='javascript:caBioSimpleSearch.changePage(-1)'>Previous</a>&nbsp;":""
	            next = (currPage < numPages)?"<a href='javascript:caBioSimpleSearch.changePage(1)'>Next</a>":""
	
	            pages = '<div class="pages">'+prev+rp+' &nbsp;'+next+'</div>'
	            jQuery("#searchResults").append(pages)
	        }
	    }
	    
	    caBioSimpleSearch.enabledUI(true);
	}
	
	function doObjectDetails(className, id) {
	
	    searchResults = jQuery("#searchResults").html()
	    
	    caBioSimpleSearch.enabledUI(false)
	    jQuery.ajax({ 
	        type: "GET", dataType: "xml", url: proxyUrl,
	        data: 'query='+className+'&'+className+'[@id='+id+']',
	        success: processObjectDetails
	    })
	}
	
	function processObjectDetails(xml) {
	
	    var searchText = jQuery("#searchText").val()
	    jQuery("#searchResults").empty()
	 
	    qr = jQuery("queryResponse",xml)
	    if (qr.length == 0) {
	        r = '<div class="summary">Object not found</div>'
	        jQuery("#searchResults").append(r)
	    }
	    else {	
	        jQuery("class", qr).each(function(){
	
	            var r = processClassNode(this);
	
	            h = '<div class="result"><table class="properties">'
	            h += '<tr><th colspan="2" class="header"><span class="link-extenal">'
	            h += '<a href="'+GETHTML_URL+r.className+'&'+r.className+'[@id='+r.id+']">'
	            h += r.className+'#'+r.id+'</a></span></th></tr>'
	            for(k in r.properties) {
	                if ((k.substring(0,1) !== '_') && (k != 'id')) {
	                    var val = r.properties[k]
	                    var v = '';
	                    if (!jQuery.browser.msie && val.substring(0,5)==='<?xml') {
	                    
	                    	val = val.replace(
	                    		new RegExp('\n','g'),' ').replace( // convert new lines to spaces
		                    	new RegExp("'",'g'),"\\'").replace( // escape single quotes
		                    	new RegExp('&','g'),'&amp;') // escape ampersands
	                    	
	                    	//jQuery("#debug").empty()
	                    	//jQuery("#debug").append(escapeXML(val))
	                    
	    					v = '<div id="pathway_'+r.id+'" class="pathwayDiagram" onclick="jQuery.modal.close()">'
	    					v += '<object width="600" height="500" name="svg" codebase="http://www.adobe.com/svg/viewer/install/" '
	    					v += 'classid="clsid:78156a80-c6a1-4bbf-8e6a-3cd390eeb4e2" '
	    					v += "data='data:image/svg+xml,"+val+"' " +'type="image/svg+xml"></object>'
                            v += '</div>'
                            jQuery("body").append(v)

                            v = '<input type="submit" value="View Image" onclick="caBioSimpleSearch.showPathway('+r.id+')"/>'

	                    }
	                    else {
		                    v = escapeXML(val)
	                    }
	                    
	                    h += '<tr><th>'+k+'</th><td><div class="value">'
	                    h += highlight(v, searchWords)+"</div></td></tr>"
	                }
	            }
	            h += '</table></div>'
	            jQuery("#searchResults").append(h)
	            
	        })
	    }
	    caBioSimpleSearch.enabledUI(true);
	}
	
	/**
	 * Process a <class> node and return an object with the following properties:
	 * - className: the fully-qualified class name
	 * - id: the primary key of the object
	 * - properties: a hashmap of object attribute values
	 */
	function processClassNode(classNode) {
	    if (jQuery(classNode).attr('name') == 'gov.nih.nci.search.SearchResult') {
	        return processSearchResult(classNode)
	    }
	    return processDomainObject(classNode)
	}
	
	/**
	 * Process a SearchResult <class> node.
	 */
	function processSearchResult(classNode) {
	
	    props = jQuery("field[@name='properties']", classNode).text();
	
	    // get rid of the surrounding {}'s
	    props = props.substring(1,props.length-1)
	    // create property hashmap
	    p = {}
	    re = /,(?=( \w+\=))/
	    ar = props.split(re)
	    re = /(\w+)\=(.*)/
	    for(i=0; i<ar.length; i++) {
	        vals = re.exec(ar[i])
	        key = vals[1]
	        value = vals[2]
	        if (value != '') {
	            p[key] = value
	        }
	    }
	    
	    result = new Object()
	    result.className = jQuery("field[@name='className']", classNode).text()
	    result.id = jQuery("field[@name='id']", classNode).text()
	    result.properties = p
	    return result
	}
	
	/**
	 * Process a domain object <class> node.
	 */
	function processDomainObject(classNode) {
	
	    // create property hashmap
	    p = {}
	    jQuery("field", classNode).each(function() {
	        if (jQuery(this).attr('xlink:type') == undefined) {
	            key = jQuery(this).attr('name')
	            p[key] = jQuery(this).text()
	        }
	    })
	
	    result = new Object()
	    result.className = jQuery(classNode).attr('name')
	    result.id = jQuery("field[@name='id']", classNode).text()
	    result.properties = p
	    return result
	}
	
	/**** public API ****/
	
	return {
		
	loadSearch : function (page) {
        jQuery.historyLoad("caBioSimpleSearch_search_"+page)
	},
	
	loadDetails : function (className, id) {
        jQuery.historyLoad("caBioSimpleSearch_details_"+className+"_"+id)
	},
	
	loadFromHash : function (hash) {
		
	    if (hash) {
	    	re = /^(\w+?)_(\w+?)_(.*)/
	    	h = hash.match(re)
	    	if (h.length < 4) {
	    		console.error("[loadFromHash] invalid hash: "+hash);
	    		return
	    	}
            window[h[1]][h[2]](h[3])
	    }
	
	},
	
    search : function(hash) {
        doSearch(parseInt(hash))
    },
    
    details : function(hash) {
    	h = hash.split("_");
        doObjectDetails(h[0],parseInt(h[1]))
    },
    
	/**
	 * Change the current page by the given number of pages (may be negative).
	 */
	changePage : function (inc) {
	    currPage += inc;
	    caBioSimpleSearch.loadSearch(currPage)
	},
	
	/**
	 * Called when the page is loaded to add an image to the advanced options.
	 */
	showAdvOptions : function () {
    	jQuery("#adv_link").html('<img src="'+downBlueImg+'" border="0"/> Advanced Options');
	},

	/** 
	 * Go back to the search results. Called from an object details screen.
	 */
	restoreSearch : function () {
	    jQuery("#searchResults").empty().append(searchResults)
	},
	
	/**
	 * Toggle the "Advanced Options" drop down box.
	 */
	toggleOptions : function () {
	    ab = jQuery("#adv_box")
	    if (ab.is(":hidden")) {
	    	ab.css("display","block")
	        jQuery("#adv_link>img").attr('src',downGreyImg)
	    }
	    else {
	    	ab.css("display","none")
	        jQuery("#adv_link>img").attr('src',downBlueImg)
	    }
	},
	
	/**
	 * Enable or disable the UI while processing something.
	 */
	enabledUI : function (enabled) {
		if (enabled) {
		    jQuery("#searchText").removeAttr("disabled")
		    jQuery("#searchButton").removeAttr("disabled")
		    jQuery("#searchButton").attr("value","Search")
		    document.body.style.cursor = "default";
		}
		else {
		    jQuery("#searchText").attr("disabled","disabled")
		    jQuery("#searchButton").attr("disabled","disabled")
		    jQuery("#searchButton").attr("value","Loading...")
		    document.body.style.cursor = "wait";
		}
	},
	
	/**
	 * Show a pathway diagram in a modal dialog (Firefox only).
	 */
	showPathway : function (id) {
		jQuery("#pathway_"+id).modal({
            overlay: 60,
            close: false,
            onShow: function(dialog) { 
                dialog.overlay.one("click", function () {
                    jQuery.modal.close();
                });
            },
        
        });
		return false;
	}

	};
}();

</script>

<input id="searchText" type="text" value="blood"/>
<input type="submit" value="Search" id="searchButton" onclick="caBioSimpleSearch.loadSearch(1)"/>
<br/>

<a id="adv_link" href="javascript:caBioSimpleSearch.toggleOptions()">Advanced Options</a>
<div id="adv_box">
	Match:
	<input type="radio" name="match" id="matchany" checked="checked"> any 
	<input type="radio" name="match" id="matchall"> all 
	<br/>
	Exclude: <input id="exclude" type="text"/>
	<br/>
	<input type="checkbox" id="searchFormat" checked="checked"/> Domain-specific formatting
	<br/>
	<input type="checkbox" id="searchHibernate"/> Map to objects (slower)
</div>

<div class="results" id="searchResults"
	xmlns="http://www.w3.org/1999/xhtml" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xlink="http://www.w3.org/1999/xlink">
</div>

<div id="debug"></div>
