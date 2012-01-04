/**
 * Common functions for the caBIO portlets. 
 */
var caBioCommon = function() {
    
    // Pager: max number of pages to show in each direction from the current page
    var NUM_PAGES_SHOWN = 8;
    
    // Drop down arrows
    var downBlueImg = "images/down_arrow_blue.png";
    var downGreyImg = "images/down_arrow_grey.png";

    var ie = (document.all) ? true : false;

    /**
     * Process a SearchResult <class> node.
     */
    function processSearchResult(classNode) {
    
        props = jQuery("field[@name='properties']", classNode).text();
    
        // get rid of the surrounding {}'s
        props = props.substring(1,props.length-1);
        // create property hashmap
        p = {};
        re = /,(?=( \w+\=))/;
        ar = props.split(re);
        re = /(\w+)\=(.*)/;
        for(i=0; i<ar.length; i++) {
            vals = re.exec(ar[i]);
            key = vals[1];
            value = vals[2];
            if (value != '') {
                p[key] = value;
            }
        }
        
        result = new Object();
        result.className = jQuery("field[@name='className']", classNode).text();
        result.id = jQuery("field[@name='id']", classNode).text();
        result.properties = p;
        return result;
    }
    
    /**
     * Process a domain object <class> node.
     */
    function processDomainObject(classNode) {
    
        // create property hashmap
        p = {};
        jQuery("field", classNode).each(function() {
            if (jQuery(this).attr('xlink:type') == undefined) {
                key = jQuery(this).attr('name');
                p[key] = jQuery(this).text();
            }
        })
    
        result = new Object();
        result.className = jQuery(classNode).attr('name');
        result.id = jQuery("field[@name='id']", classNode).text();
        result.properties = p;
        return result;
    }
    
    /**** public API ****/
    
    return {
    
    searchWords : [],
    
    enabledUI : function (enabled) {
        if (enabled) {
            document.body.style.cursor = "default";
        }
        else {
            document.body.style.cursor = "wait";
        }
    },
    
    /**
     * Called when the page is loaded to add an image to a dropdown box.
     */
    createDropBox : function (boxLinkId) {
        h = jQuery(boxLinkId);
        h.css('text-decoration','none');
        h.html('<img src="'+downBlueImg+'" border="0"/> '+h.html());
    },
    
    /**
     * Toggle a drop down box.
     */
    toggleDropBox : function (boxId) {
        ab = jQuery(boxId);
        if (ab.is(":hidden")) {
            ab.css("display","block");
            jQuery(boxId+">img").attr('src',downGreyImg);
        }
        else {
            ab.css("display","none");
            jQuery(boxId+">img").attr('src',downBlueImg);
        }
    },
    
    toggleDropBox2 : function (boxId) {               
        var boxElem = (ie) ? document.all(boxId) :document.getElementById(boxId);
        if (boxElem.style.display=="none"){
           boxElem.style.display="block"        
        }
        else {
           boxElem.style.display="none"
        }
    },
    
    /**
     * Escape the given XML (or HTML) so that it can be shown on the web page.
     */
    escapeXML : function (xml) {
        return xml.split("&").join("&amp;").split("<").join("&lt;").split(">").join("&gt;");
    },
    
    /** 
     * Truncate the given label to the specified length, 
     * ending with a bold ellipsis.
     * @param label the label to truncate
     * @param len the maximum length for labels
     */
    trunc : function (label, len) {
        if (label.length > len) {
            return label.substring(0, len-3) + "<b>...</b>";
        }
        return label;
    },
    
    /**
     * Highlight occurances of text in the given label.
     */
    highlight : function (label, wordList) {
        var h = label;
        for(var i=0; i<wordList.length; i++) {
            var w = jQuery.trim(wordList[i]);
            if (w) {
                h = h.replace(new RegExp("("+w+")","gi"), "<b>$1</b>");
            }
        }
        return h;
    },
    
    /**
     * Tokenize the given string into an array of words and phrases. If you 
     * put a phrase in quotes it will come through as a single token.
     */
    tokenize : function (s) {
        var a = [];
        var curr = "";
        var open = false;
        for(i=0; i<s.length; i++) {
            if (s[i] == '"') {
               if (open) {
                   a[a.length] = curr;
                   curr = "";
               }
               open = !open;
            }
            else if (s[i] == ' ') {
               if (open) {
                    curr += s[i];
               }
               else if (curr) {
                   a[a.length] = curr;
                   curr = "";
               }
            }
            else {
               curr += s[i];
            }
        }
        if (curr) a[a.length] = curr;
        return a;
    },
    
    /**
     * Creates and returns a string of HTML to display a simple pager.
     * @param numPages total number of pages
     * @param currPage current page (1 indexed)
     * @param pkgName Javascript object with a loadSearch method that will be 
     *                called when the user switches pages.
     */
    createPager : function(numPages, currPage, pkgName) {
    
	    var rp = '';
	    var leftpadded = false; 
	    var rightpadded = false;
	    
	    for(i=1; i<=numPages; i++) {
	        if (i == currPage) {
	            rp += ' '+i;
	        }
	        else if (((i > currPage-NUM_PAGES_SHOWN) 
	              && (i < currPage+NUM_PAGES_SHOWN))
	              || (i == 1) || (i == numPages)) {
	            rp += ' <a href="javascript:'+pkgName+'.loadSearch('+i+')">'+i+'</a>';
	        }
	        else if ((i <= currPage-NUM_PAGES_SHOWN) && (i > 1)) {
	            if (!leftpadded) {
	                rp += ' ...';
	                leftpadded = true;
	            }
	        }
	        else if ((i >= currPage+NUM_PAGES_SHOWN) && (i < numPages)) {
	            if (!rightpadded) {
	                rp += ' ...';
	                rightpadded = true;
	            }
	        }
	    }
	    
	    pages = '<div class="pages">';
	    
	    if (currPage > 1) {
	       pages += '<a href="javascript:'+pkgName+'.loadSearch('+(currPage-1)+')">Previous</a>&nbsp; ';
	    }
	    
	    pages += rp;
	    
	    if (currPage < numPages) {
	       pages += '&nbsp; <a href="javascript:'+pkgName+'.loadSearch('+(currPage+1)+')">Next</a>';
	    }
	    
	    pages += '</div>';
	    
        return pages;
    },
    
    /**
     * Process a <class> node returned by the caBIO REST API
     * and return an object with the following properties:
     * @param className the fully-qualified class name
     * @param id the primary key of the object
     * @param properties a hashmap of object attribute values
     */
    processClassNode : function(classNode) {
        if (jQuery(classNode).attr('name') == 'gov.nih.nci.search.SearchResult') {
            return processSearchResult(classNode);
        }
        return processDomainObject(classNode);
    },
    
    /**
     * Process a history hash in the form "namespace_function_parameters" and 
     * parse the hash to execute namespace.function(parameters). The parameters
     * string can be an underscore delimited list of parameters, which the 
     * event callback needs to deal with.
     * This is used in conjunction with jquery.history to achieve back button 
     * functionality with Ajax updates.
     */
    loadFromHash : function (hash) {
        if (hash) {
            re = /^(\w+?)_(\w+?)_(.*)/;
            h = hash.match(re);
            if (h.length < 4) {
                console.error("[loadFromHash] invalid hash: "+hash);
                return;
            }
            window[h[1]][h[2]](h[3]);
        }
    },
    
    restError : function(e, req, settings){
    
	    caBioCommon.enabledUI(true);
	    
	    r = req.responseText;
	    if (r.match(/caCORE HTTP Servlet Error/)) {
	        // Yes, this is next part is very fragile, but 
	        // the SDK's error handling doesn't leave us with much choice
	        error = r.split('\r\n')[3];
	    }
	    else {
	        error = 'Unknown error';
	    }
	
	    sr = jQuery("#searchResults");
	    sr.empty();
	    sr.append('<div class="error">'+error+'</div>');
	
	    // log the error if possible
	    if (window.console && window.console.error) {
	        document.body.style.cursor = "default";
	        console.error(arguments);
	    }
	}

    };
}();
        