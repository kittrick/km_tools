//----------------------------------------------------------------------------------------
// 
// Version: 1.3.2
// Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
// 
//----------------------------------------------------------------------------------------

// Button Actions
document.getElementById("reset").addEventListener("click",resetDimensions);
document.getElementById("apply").addEventListener("click",applyDimensions);
document.getElementById("copy").addEventListener("click",applyCopy);

var inputs = document.getElementsByTagName("input");

for(var i = 0; i < inputs.length; i++){
  inputs[i].addEventListener("blur",formatUnit);
}

// Reset Dimensions Function
function resetDimensions(event){
  event.preventDefault();

  // Reset Variables
  reset_entity_name = document.getElementById("name").getAttribute("data-name");
  reset_width = document.getElementById("width").getAttribute("data-width");
  reset_depth = document.getElementById("depth").getAttribute("data-depth");
  reset_height = document.getElementById("height").getAttribute("data-height");
  reset_x = document.getElementById("x").getAttribute("data-x");
  reset_y = document.getElementById("y").getAttribute("data-y");
  reset_z = document.getElementById("z").getAttribute("data-z");
  
  // Reset Values
  document.getElementById("name").innerHTML = reset_entity_name;
  document.getElementById("width").value = reset_width; 
  document.getElementById("depth").value = reset_depth;
  document.getElementById("height").value = reset_height;
  document.getElementById("x").value = reset_x;
  document.getElementById("y").value = reset_y;
  document.getElementById("z").value = reset_z;
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

function formatUnit(event){
  value = this.value;
  var reg = new RegExp('^((\-)?([0-9]+)?(\.)?([0-9]+)?(\"|\')?)$');
  if(!reg.test(value)){
    name = this.getAttribute("name");
    this.value = this.getAttribute("data-" + name);
  } else {
    if(value.indexOf("'") > 0){
      value = value.substring(0, value.length - 1);
      value = parseFloat(value);
      value = value * 12;
      value = value + "\"";
      this.value = value;
    }
    if(value.indexOf("\"") < 1){
      this.value = value + "\"";  
    }
  }
}

function sendToSKP(command){
  var inputs = document.getElementsByTagName("input");
  var data = "{";
  data += "\"command\": \"" + command + "\",";
  for(var i = 0; i < inputs.length; i++){
    value = inputs[i].value.replace("\"","&quot;");
    data += "\"" + inputs[i].getAttribute("name") + "\" : \"" + value + "\",";
  }
  data = data.substring(0, data.length -1);
  data += "}";
  query = "skp:get_data@" + data;
  window.location.href = query;
}