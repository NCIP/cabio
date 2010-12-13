
   function selectCriterion( id ){
    var form = document.designQueryForm;
    form.nextStep.value = "selectCriterion";
    form.selectedCriterionId.value = id;
    form.submit();
   }
   function editCriterion( id ){
    var form = document.designQueryForm;
    form.nextStep.value = "editCriterion";
    form.selectedCriterionId.value = id;
    form.submit();
   }
   function showHelp(){
    //figure out what help should be displayed
    alert( 'Howdy Pardner!' );
   }
   function finish(){
    var form = document.designQueryForm;
    form.nextStep.value ="finish";
    form.submit();
   }
   function getNumPops(){
     return "0";
   }
   function toggleMerge( id, shouldMerge ){
    var opStr = 'should not';
    if( shouldMerge ){
     opStr = 'should';
    }
    var doToggleMerge = confirm( 'You have indicated that this criterion ' + 
                                 opStr + ' be the merge criterion. Proceed?' );
    if( doToggleMerge ){
      var form = document.designQueryForm;
      form.nextStep.value = "toggleMerge";
      form.selectedCriterionId.value = id;
      form.submit();  
    }
   }
