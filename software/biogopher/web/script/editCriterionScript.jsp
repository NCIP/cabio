<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

<%@ include file="JS_Utils.js" %>

function doDelete( form, name ){
  a = getSelectedOptionsWithName( form, name );
  if( a.length < 1 ){
    alert( "You have not selected any values to delete." );
  }else{
    form.nextStep.value = "delete";
    form.submit();
  }
}
function doAdd( form ){
  form.nextStep.value = "add";
  form.submit();
}
