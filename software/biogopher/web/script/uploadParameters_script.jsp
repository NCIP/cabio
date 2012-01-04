function doUpload( form ){
    if( form.uploadedFile.value != null && form.uploadedFile.value != "" ){
	form.nextStep.value = "upload";
	form.submit();
    }
}
