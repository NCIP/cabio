/**
 * Functions for fetching and displaying object details for a single object.
 * Requires the following modules loaded:
 *    jquery.history.js
 *    cabio_common.js 
 */
var caBioObjectDetails = function() {

    var searchResults = '';
    var savedNav = '';

    function pubmedLink (pubmedId) {
        return '<span class="link-extenal"><a href="http://www.ncbi.nlm.nih.gov/pubmed/'+pubmedId+'" target="_blank">'+pubmedId+'</a></span>';
    }
    
    function processObjectDetails (r) {

        savedNav = jQuery("#cabioNav").html();
        var navback = '<div id="navback"><a href="javascript:caBioObjectDetails.restoreResults()">&#171; Return to results</a></div>';
        jQuery("#cabioNav").empty().append(navback);
        jQuery("#cabioSummary").hide();
        jQuery("#searchResults").hide();

        var h = '<div>'
                 
        if (r.exceptionClass) {
            h += '<div class="error">'+r.exceptionMessage+'</div>';
            jQuery("#objectDetails").empty().append(h).show();
        }
        else {  	
	        h += '<table class="properties"><tr><th colspan="2" class="header">'+r.label+'</th></tr>';
	        for(i in r.attributes) {
                var k = r.attributes[i].name || "";
                var val = r.attributes[i].value || "";
                var v = '';
                if (k === 'PubMED Id') {
                    v = pubmedLink(val);
                }
                else {
                    if (typeof(val) == 'object') {
                        var cdata = val['columnNames'];
                        var rdata = val['rows'];
                        var count = parseInt(val['count']);
                        if (count > 0) {
	                        v = '<table class="nested"><tr>';
	                        for(var ci in cdata) {
	                            v += '<th>'+cdata[ci]+'</th>';
	                        }
	                        v += '</tr>';
	                        for(var ri in rdata) {
	                            v += '<tr>';
	                            for(var ci in cdata) {
	                                var pv = rdata[ri][cdata[ci]];
					                if (cdata[ci] === 'PubMED Id') {
					                    pv = pubmedLink(pv);
					                }
                                    v += '<td>'+(pv||'')+'</td>';
	                            }
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
                    }
                    else {
                        v = caBioCommon.highlight(val, caBioCommon.searchWords);
                    }
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
        jQuery("#cabioNav").empty().append(savedNav);
        jQuery("#cabioSummary").show();
        jQuery("#searchResults").show();
        jQuery("#objectDetails").empty();
    },
    
    loadDetails : function (className, id) {
        jQuery.historyLoad("caBioObjectDetails_details_"+className+"_"+id);
    },
    
    restoreResults : function (className, id) {
        jQuery.historyLoad("caBioObjectDetails_restore_");
    }
    
    };
}();
        