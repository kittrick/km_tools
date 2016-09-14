//----------------------------------------------------------------------------------------
// 
// Version: 1.3.8
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
  reset_x_rotation = document.getElementById("x-rotation").getAttribute("data-x-rotation");
  reset_y_rotation = document.getElementById("y-rotation").getAttribute("data-y-rotation");
  reset_z_rotation = document.getElementById("z-rotation").getAttribute("data-z-rotation");
  
  // Reset Values
  document.getElementById("name").innerHTML = reset_entity_name;
  document.getElementById("width").value = reset_width; 
  document.getElementById("depth").value = reset_depth;
  document.getElementById("height").value = reset_height;
  document.getElementById("x").value = reset_x;
  document.getElementById("y").value = reset_y;
  document.getElementById("z").value = reset_z;
  document.getElementById("x-rotation").value = reset_x_rotation;
  document.getElementById("y-rotation").value = reset_y_rotation;
  document.getElementById("z-rotation").value = reset_z_rotation;
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
          console.log(m);
          m = m.replace("\'",'');
          m = 12 * m;
          return m;
        });
        
        // Replace with evaluated solution
        value = eval(value);
        console.log(value)
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
  console.log(query)
  window.location.href = query;
}