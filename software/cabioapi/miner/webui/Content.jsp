<%@taglib prefix="s" uri="/struts-tags" %>

<script>
	<!-- transport: "XMLHTTPTransport" -->
    function treeNodeSelected(nodeId) {
        alert("Clicked on node: " + nodeId);
        dojo.io.bind({
            url: "<s:url value='Criteria.action' />?nodeId="+nodeId,
            load: function(type, data, evt) {
                var displayDiv = dojo.byId("displayId");
                displayDiv.innerHTML = data;
		    	setFocus('firstInputField')
            },
            mimeType: "text/html"
        });
    };

    dojo.event.topic.subscribe("treeSelected", this, "treeNodeSelected"); 
</script>
<script>
	function setFocus(fieldName)
	{
		try {
			document.getElementById( fieldName ).focus();
		} catch(e) {
			return true;
		}
	}// setFocus()    
</script>
<table summary="" cellpadding="0" cellspacing="0" border="0" height="500px" width="100%">              
<!--_____ main content begins _____-->
              <tr>
                <td valign="top">
                  <!-- target of anchor to skip menus --><a name="content" />
                  <table summary="" cellpadding="0" cellspacing="0" border="0" class="contentPage" width="100%" height="500px">
						<tr>
							<td valign="top">
								<table cellpadding="0" cellspacing="0" border="1" bordercolor="white" class="contentBegins">
									<tr>
										<td colspan="2">																														
											To view the search criteria for a class, expand a package listed below and select a class.  To search for records, provide valid search criteria and click the Submit button.  For any date attributes, please use the syntax: mm-dd-yyyy. 
										</td>
									</tr>
									<tr>
										<td valign="top" style="border:0px; border-right:1px; border-style:solid; border-color:black;">
											<div style="overflow:auto; height:350px; float:left; margin: 7px;">
											<s:tree 
											    theme="ajax"
											    rootNode="%{classTreeRootNode}" 
											    childCollectionProperty="children" 
											    nodeIdProperty="id"
											    nodeTitleProperty="name"
											    treeSelectedTopic="treeSelected">
											</s:tree> 
											</div>														
											<img width="400" height="1"/>														
										</td>
										<td valign="top" id="displayId" >
										</td>														
									</tr>														
								</table>
							</td>
						</tr>
					</table>
                </td>
              </tr>
<!--_____ main content ends _____-->
</table>              
