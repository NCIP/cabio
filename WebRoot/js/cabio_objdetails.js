/**
 * Functions for fetching and displaying object details for a single object.
 * Requires the following modules loaded:
 *    jquery.history.js
 *    cabio_common.js 
 */
var caBioObjectDetails = function() {

    var searchResults = '';
    
    function processObjectDetails (r) {
    
        var searchText = jQuery("#searchText").val();
        jQuery("#searchResults").hide();
     
        if (r.exceptionClass) {
            var h = '<div class="summary">Error retrieving object</div>';
            h += '<div class="error">'+r.exceptionMessage+'</div>';
            jQuery("#objectDetails").empty().append(h).show();
        }
        else {  	
	        var h = '<div>'
	        h += '<div class="summary"><a class="back" href="javascript:caBioObjectDetails.restoreResults()">&#171; Return to results</a></div>';
	        h += '<table class="properties"><tr><th colspan="2" class="header">'+r.label+'</th></tr>';
	        for(i in r.attributes) {
                var k = r.attributes[i].name || "";
                var val = r.attributes[i].value || "";
                var v = '';
                if (k === 'PubMED Id') {
                    v = '<span class="link-extenal"><a href="http://www.ncbi.nlm.nih.gov/pubmed/'+val+'" target="_blank">'+val+'</a></span>';
                }
                else {
                    v = caBioCommon.highlight(caBioCommon.escapeXML(val), caBioCommon.searchWords);
                }
                
                h += '<tr><td>'+k+'</td><td><div class="value">';
                h += v+"</div></td></tr>";
	        }
	        h += '</table><div class="externalLinks"><h3>External Links</h3><ul>';
            h += '<li><span class="link-extenal"><a href="'+GETHTML_URL+r.className+'&'+r.className+'[@id='+r.id+']" target="_blank">';
            h += 'Open this record in the caBIO Object Graph Browser</a></span></li>';
            h += '</ul></div></div>';
	        jQuery("#objectDetails").empty().append(h).show();
	        
        }
        caBioCommon.enabledUI(true);
    }
    
    return {
    
    doObjectDetails : function(className, id) {
        caBioCommon.enabledUI(false);
        jQuery.ajax({ 
            type: "GET", dataType: "json", url: DETAILS_URL,
            data: 'className='+className+'&id='+id,
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
        jQuery("#objectDetails").empty();
        jQuery("#searchResults").show();
    },
    
    loadDetails : function (className, id) {
        jQuery.historyLoad("caBioObjectDetails_details_"+className+"_"+id);
    },
    
    restoreResults : function (className, id) {
        jQuery.historyLoad("caBioObjectDetails_restore_");
    }
    
    };
}();
        