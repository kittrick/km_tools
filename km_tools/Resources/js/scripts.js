//----------------------------------------------------------------------------------------
// 
// Version: 1.3.9
// Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
// 
//----------------------------------------------------------------------------------------

// Button Actions
$("reset").addEventListener("click", resetDimensions);
$("apply").addEventListener("click", applyDimensions);
$("copy").addEventListener("click", applyCopy);

var inputs = document.getElementsByTagName("input");
var newInputs = [];

// Get all inputs excluding checkboxes
for(var i = 0; i < inputs.length; i++){
  if(inputs[i].type != "checkbox"){
    newInputs.push(inputs[i]);
  }
}
// Listen for Text Input
for(var i = 0; i < newInputs.length; i++){
  newInputs[i].addEventListener("focus", linkInputs);
  newInputs[i].addEventListener("blur", formatUnit);
}
// Add action on unchecked checkbox
for(var i = 0; i < inputs.length; i++){
  if(inputs[i].type == 'checkbox'){
    inputs[i].addEventListener("change",unCheck)
  }
}

// Reset Dimensions Function
function resetDimensions(event){
  event.preventDefault();

  // Reset Variables
  reset_entity_name = $("name").getAttribute("data-name");
  reset_width = $("width").getAttribute("data-width");
  reset_depth = $("depth").getAttribute("data-depth");
  reset_height = $("height").getAttribute("data-height");
  reset_x = $("x").getAttribute("data-x");
  reset_y = $("y").getAttribute("data-y");
  reset_z = $("z").getAttribute("data-z");
  reset_x_rotation = $("x_rotation").getAttribute("data-x_rotation");
  reset_y_rotation = $("y_rotation").getAttribute("data-y_rotation");
  reset_z_rotation = $("z_rotation").getAttribute("data-z_rotation");
  
  // Reset Values
  $("name").innerHTML = reset_entity_name;
  $("width").value = reset_width; 
  $("depth").value = reset_depth;
  $("height").value = reset_height;
  $("x").value = reset_x;
  $("y").value = reset_y;
  $("z").value = reset_z;
  $("x_rotation").value = reset_x_rotation;
  $("y_rotation").value = reset_y_rotation;
  $("z_rotation").value = reset_z_rotation;
  sendToSKP("reset");
}

// Apply Dimensions Function
function applyDimensions(event){
  event.preventDefault();
  sendToSKP("apply");
}

// Apply Duplicate Function
function applyCopy(event){
  event.preventDefault();
  sendToSKP("copy");
}

// What to do when a link box is unchecked
function unCheck(event){
  if(! this.checked){
    $(this.id.replace("link_","")).setAttribute("style","background: #fff;");
    $(this.id.replace("link_","")).setAttribute("data-linked", "false");
  }
}

// Formats input Fields
function formatUnit(event){
  value = this.value;
  if(this.id.indexOf("rotation") > 0){
    var reg = new RegExp('^([\\.\\-\+\(\)\*\/\°\ ]|[0-9])+$')
    if(!reg.test(value)){
      name = this.getAttribute("name");
      this.value = this.getAttribute("data-" + name);
    } else if(value.length > 0){
      value = value.replace(/°/g,"");
      value = eval(value);
      this.value = value + "°"; 
    }
  } else {
    var reg = new RegExp('^([\\.\\-\+\(\)\*\'\"\/\ ]|[0-9])+$');
    if(!reg.test(value)){
      name = this.getAttribute("name");
      value = this.getAttribute("data-" + name);
    } else if(value.length > 0){
        // Replace all foot inch notes with an extra plus sign
        var footInch = new RegExp(/\'([0-9]|[\\.])/g);
        value = value.replace(footInch,"'+$1");

        // Remove all inch marks
        value = value.replace(/"/g,"");

        // Find all foot marks and multiply that number by 12
        var reg = new RegExp(/([0-9][\\.]?)+[\']/g);
        value = value.replace(reg, function(m, v){
          m = m.replace("\'",'');
          m = 12 * m;
          return m;
        });
        
        // Replace with evaluated solution
        value = eval(value);
        this.value = value + "\"";
    }
  }
}

// Controls inputs based on linked attributes
function linkInputs(event){
  if($("link_" + this.id).checked){
    $(this.id).setAttribute("style", "background: #fff;");
    var parent = this.parentElement;
    var children = parent.children;
    var siblings = [];
    for(i = 0; i < children.length; i++){
      if(children[i].tagName != "LABEL" && children[i].type != "checkbox" && children[i].id != this.id){
        siblings.push(children[i]);
      }
    }
    for(i = 0; i < siblings.length; i++){
      if($('link_'+siblings[i].id).checked){
        constrain($(siblings[i].id), this);
      }
    }
  }
}

// Constrain Linked Text Inputs
function constrain(target, source){
  var replacementChar = target.parentElement.id == "rotation"? "°" : "\"";
  target.setAttribute("style","background: #eee;");
  target.setAttribute("data-linked","true");
  target.setAttribute("data-original",target.value.replace(replacementChar,""));
  source.setAttribute("data-source", source.value.replace(replacementChar,""));
  source.addEventListener("blur", updateLinked);
  source.addEventListener("blur", function(){
    this.removeAttribute("data-source");
  });
}

// Update Linked inputs to match their parent
function updateLinked(){
  var replacementChar = this.parentElement.id == "rotation"? "°" : "\"";
  if(this.getAttribute("data-source").length > 0){
    siblings = this.parentElement.children;
    for(var i = 0; i < siblings.length; i++){
      if(siblings[i].getAttribute("data-linked") == "true"){
        if(this.parentElement.id == "size"){
          var ratio = parseFloat(this.value.replace(replacementChar,"")) / parseFloat(this.getAttribute("data-source"));
          siblings[i].value = parseFloat((parseFloat(siblings[i].getAttribute("data-original")) * ratio).toPrecision(10)) + replacementChar;
        } else {
          var difference = parseFloat(this.value.replace(replacementChar,"")) - parseFloat(this.getAttribute("data-source"));
          siblings[i].value = parseFloat((parseFloat(siblings[i].getAttribute("data-original")) + difference).toPrecision(10)) + replacementChar;
        }
      }
    }
  }
}

// Send data to Sketchup
function sendToSKP(command){
  var inputs = newInputs;
  var data = "{";
  data += "\"command\": \"" + command + "\",";
  for(var i = 0; i < inputs.length; i++){
    value = inputs[i].value.replace("\"","&quot;");
    value = value.replace("°","&deg;");
    data += "\"" + inputs[i].getAttribute("name") + "\" : \"" + value + "\",";
  }
  for(var i = 0; i < inputs.length; i++){
    value = inputs[i].getAttribute("data-"+inputs[i].getAttribute("name"))
    value = value.replace("\"","&quot;");
    value = value.replace("°","&deg;");
    data += "\"data-"+inputs[i].getAttribute("name")+"\" : ";
    data += "\""+value+"\",";
  } 
  data = data.substring(0, data.length -1);
  data += "}";
  query = "skp:get_data@" + data;
  window.location.href = query;
}

function $(id){
  return document.getElementById(id);
}