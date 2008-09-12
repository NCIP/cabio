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
        
        
        
    };
}();
        