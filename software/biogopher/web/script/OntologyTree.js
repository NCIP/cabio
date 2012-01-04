var ontologyBrowserWindow = null;
function openOntologyBrowser( renderer, beanName, rootId, eventHandler ){
    var targetURL = 
	renderer + '?treeClass=gov.nih.nci.caBIOApp.ui.OntologyTree' +
	'&treeParams=beanName:' + beanName + ';rootId:' + rootId + ';eventHandler:' + eventHandler +
	'&skin=default';
    ontologyBrowserWindow = window.open( targetURL, 'ontBrowser', 'width=810,height=500,resizable,scrollbars' );
}

