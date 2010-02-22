/**
 * Functions for fetching and displaying object details for a single object.
 * Requires the following modules loaded:
 *    jquery.history.js
 *    cabio_common.js 
 */
var caBioObjectDetails = function() {

	// An image that can be clicked to drill down to another object detail screen 
    var drillDownImg = '/cabioportlets/images/arrow_right.gif';
    
    // Fully-qualified name of the current object 
    var className = '';
    
    // Id of the current object
    var objectId = '';
    
    // Previous object details screens (accumulated through drill downs)
    var history = [];
    
    /** 
     * Make a link to an external data source given a URL template with 
     * a placeholder (%%) that can be replaced with a value.
     */
    function makeExternalLink (value, hrefTemplate) {
    	if (!hrefTemplate) return value || '';
		var href = hrefTemplate.replace(new RegExp("%%","gi"), value);
    	return '<span class="link-extenal"><a href="'+href+'" target="_blank">'+value+'</a></span>';
    }
    
    /**
     * Make a link to another object details page, for a related object.
     */
    function makeDetailLink (linkClassName, linkId) {
    	 return '<a href="javascript:caBioObjectDetails.loadDetails(\''+
    	 		linkClassName+'\','+linkId+')"><img src="'+drillDownImg+'" border="0"></a>';
    }
    
    /**
     * Callback for the JSON that comes back for an object detail request.
     */
    function processObjectDetails (r) {

    	// Is the user coming from a search or a detail page?
    	if (jQuery("#caBioDetails").is(":hidden")) {
            jQuery("#caBioSearch").hide();
    	}
    	else {
    		history.push(jQuery("#caBioDetails").html());
    	}
    	
        var caBioNavBack = '<div class="caBioNavBack"><a href="javascript:caBioObjectDetails.restoreResults()">&#171; Back</a></div>';
        jQuery("#caBioDetails>.caBioNav").empty().append(caBioNavBack);
        jQuery("#caBioDetails").show();

        if (r.exceptionClass) {
            var h = '<div class="error">'+r.exceptionClass+': '+r.exceptionMessage+'</div>';
            jQuery("#objectDetails").empty().append(h);
        }
        else {  	
            var outer = '<div id="objectAttributes"></div><div id="objectAssociations"></div><div id="objectLinks"></div>';
            jQuery("#objectDetails").empty().append(outer);
	        var h = '<h3>'+r.label+'</h3><table class="properties">';
	        h += '<tr><th class="propertyName">Property</th><th>Value</th><th width="9"></th></tr>';
	        
	        for(i in r.attributes) {
	        	var attr = r.attributes[i];
                var name = attr.name || "";
                var value = attr.value || "";
                var link = attr.link;
                var assocPath = attr.path;
                var assocClass = attr.className;
                
                if (assocClass) {
                
                	var anchor = name.replace(new RegExp("\\s","g"), '_');
                	var linkAnchor = anchor+'_link';
                	var boxAnchor = anchor+'_box';
                	
                	var future = jQuery('<div id="'+boxAnchor+'" class="height-limited">'+caBioCommon.getLoadingImage()+'</div>');
                    var assoc = jQuery('<div class="assoc"><h3><a id="'+linkAnchor+'">'+name+'</a></h3></div>');
                    future.appendTo(assoc);
                    assoc.appendTo("#objectAssociations");

                    caBioCommon.createDropBox('#'+linkAnchor,'#'+boxAnchor);
                    
                    // Uses a closure so that we have access to the div
                    // where the result should be placed in the future when 
                    // this function is actually called.
                    var processAssociation = (function(future) {
                    	return function(a) {
	
	                        var cdata = a['columnNames'];
	                        var rdata = a['rows'];
	                        var count = parseInt(a['count']);
	                    	var v = '';
	                    	
	                        if (count > 0) {
	                        	v = '<table class="properties"><tr>';
	                            for(var ci in cdata) {
	                            	v += '<th>'+cdata[ci].value+'</th>';
	                            }
	                            v += '<th width="9"></th></tr>';
	                            for(var ri in rdata) {
	                            	v += '<tr>';
	                                for(var ci in cdata) {
	                                    var pv = rdata[ri][cdata[ci].value];
	    				                v += '<td>'+makeExternalLink(pv,cdata[ci].link)+'</td>';
	                                }
	                                v += '<td>'+makeDetailLink(a.className, rdata[ri].id)+'</td>';
	                                v += '</tr>';
	                            }
	                            v += '</table>';
	                            if (count > rdata.length) {
	                            	v += "<br/><b>Only the first "+rdata.length+" out of "+
	                                    count+" results are shown here. "+
	                                    "To download the entire result set, click on the "+ 
	                                    "<i>caBIO Object Graph Browser</i> link below.</b>"
	                            }
	                        }
	                        else {
	                        	v = 'No data';
	                        }
	                        
	                        future.empty().append(v);
                    	}
                    })(future);

                    jQuery.ajax({ 
                        type: "GET", dataType: "json", url: DETAILS_URL,
                        data: 'className='+className+'&id='+objectId+
                              '&path='+assocPath+'&assocClass='+assocClass,
                        success: processAssociation
                    });
                }
                else {
                    var v = caBioCommon.highlight(value, caBioCommon.searchWords);
                    var d = attr.drillId ? makeDetailLink(attr.drillClassName, attr.drillId):'';
                    h += '<tr><td class="propertyName">'+name+'</td>';
                    h += '<td><div class="height-limited">'+makeExternalLink(v, link)+'</div></td>';
                    h += '<td>'+d+'</td></tr>';
                }
	        }
	        h += '</table>';
	        
            jQuery("#objectAttributes").append(h);

	        var links = '<h3>External Links</h3><div class="externalLinks"><ul>';
	        links += '<li><span class="link-extenal"><a href="'+GETHTML_URL+r.className+'&'+r.className+'[@id='+r.id+']" target="_blank">';
	        links += 'Open this record in the caBIO Object Graph Browser</a></span></li>';
	        links += '</ul></div>';
            jQuery("#objectLinks").append(links);
	        
        }
        caBioCommon.enabledUI(true);
    }
    
    return {
    
    doObjectDetails : function(cn, id) {
    	className = cn;
    	objectId = id;
        caBioCommon.enabledUI(false);
        jQuery.ajax({ 
            type: "GET", dataType: "json", url: DETAILS_URL,
            data: 'className='+className+'&id='+objectId,
            success: processObjectDetails
        })
    },
    
    details : function(hash) {
        h = hash.split("_");
        caBioObjectDetails.doObjectDetails(h[0],parseInt(h[1]));
    },
    
    /** 
     * Go back to the search results. Called from an object details screen.
     */
    restore : function () {
    	if (history.length > 0) {
    		// Go back to the previous object details screen
    		html = history.pop();
            jQuery("#caBioDetails").html(html);
    	}
    	else {
    		// No object details history left, so hide object details and restore the search
            jQuery("#caBioSearch").show();
            jQuery("#caBioDetails").hide();
    	}
    },
    
    loadDetails : function (cn, id) {
        jQuery.historyLoad("caBioObjectDetails_details_"+cn+"_"+id);
    },
    
    restoreResults : function (className, id) {
        jQuery.historyLoad("caBioObjectDetails_restore_");
    }
    
    };
}();
        