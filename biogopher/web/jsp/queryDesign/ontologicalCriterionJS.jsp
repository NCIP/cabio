<script language="javascript" src="/ncicb/EvsTree.js"></script>
<script language="javascript">
 function invokeOntologyBrowser( form ){
  var species = form.selectedSpeciesName.value;
   window.open( 'ontPropTst.jsp', 'ont', 'status,resizable,dependent,scrollbars,width=700,height=500,screenX=100,screenY=100' );

 }
 function addOntologicalValue(){
  var form = document.designQueryForm;
  if( form.valueToAdd.value != null && form.valueToAdd.value.length > 0 ){
   updateCriterion( form, "add" );
  }
 }
</script>

