<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="JS_Utils.js" %>

function doAdd( form ){    
    form.nextStep.value = "add";
    form.submit();
}
function doDelete( form ){
    
    a = getSelectedCheckboxesWithName( form, "selectedSpreadsheetNames" );
    if( a.length > 0 ){
	form.nextStep.value = "delete";
	form.submit();
    }
}
function doDone( form ){
    a = getSelectedCheckboxesWithName( form, "selectedSpreadsheetNames" );
    if( a.length < 2 ){  
	form.nextStep.value = "finish";
	form.submit();
    }else{
	alert( "Select only one spreadhseet at a time." );
    }
}
function doDownload( form ){

    a = getSelectedCheckboxesWithName( form, "selectedSpreadsheetNames" );
    if( a.length > 0 ){
	form.nextStep.value = "download";
	form.submit();
    }
}
