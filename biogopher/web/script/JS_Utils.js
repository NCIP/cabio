function getElementsWithType( form, theType ){
  var idx = 0;
  var a = new Array();
  for( var i = 0; i < form.elements.length; i++ ){
    if( form.elements[i].type.toLowerCase() == theType.toLowerCase() ){
      a[idx] = form.elements[i];
      idx++
    }
  }
  return a;
}

function getSelectedCheckboxesWithName( form, theName ){
  var idx = 0;
  var a = new Array();
  var checkboxes = getElementsWithType( form, "checkbox" );
  for( var i = 0; i < checkboxes.length; i++ ){
    if( checkboxes[i].checked && theName == checkboxes[i].name ){
      a[idx] = checkboxes[i];
      idx++;
    }
  }
  return a;
}

function getSelectedOptionsWithName( form, theName ){
  var idx = 0;
  var a = new Array();
  var options = getElementsWithType( form, "option" );
  for( var i = 0; i < options.length; i++ ){
    if( options[i].selected && theName == selected[i].name ){
      a[idx] = selected[i];
      idx++;
    }
  }
  return a;
}
