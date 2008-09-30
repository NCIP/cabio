/**
 * Common functions for the caBIO portlets. 
 */
var caBioCommon = function() {

    var downBlueImg = "/cabioportlets/images/down_arrow_blue.png";
    var downGreyImg = "/cabioportlets/images/down_arrow_grey.png";

    return {
    
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
        h = label;
        for(var i=0; i<wordList.length; i++) {
            h = h.replace(new RegExp("("+wordList[i]+")","gi"), "<b>$1</b>");
        }
        return h;
    }
        
    };
}();
        