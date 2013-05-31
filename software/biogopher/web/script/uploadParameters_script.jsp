<%--L
   Copyright SAIC

   Distributed under the OSI-approved BSD 3-Clause License.
   See http://ncip.github.com/cabio/LICENSE.txt for details.
L--%>

function doUpload( form ){
    if( form.uploadedFile.value != null && form.uploadedFile.value != "" ){
	form.nextStep.value = "upload";
	form.submit();
    }
}
