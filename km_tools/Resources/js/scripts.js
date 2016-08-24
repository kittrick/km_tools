//----------------------------------------------------------------------------------------
// 
// Version: 1.2.5
// Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
// 
//----------------------------------------------------------------------------------------

// Button Actions
document.getElementById('reset').addEventListener('click',resetDimensions);
document.getElementById('apply').addEventListener('click',applyDimensions);

// Set Default Vars so I know when things aren't working
reset_entity_name = '#Undefined';
reset_width = '#Undefined';
reset_depth = '#Undefined';
reset_height = '#Undefined';
reset_x = '#Undefined';
reset_y = '#Undefined';
reset_z = '#Undefined';

// Reset Dimensions Function
function resetDimensions(event){
	event.preventDefault();
	document.getElementById('entity_name').innerHTML = reset_entity_name;
	document.getElementById('width').setAttribute('value', reset_width);
	document.getElementById('depth').setAttribute('value', reset_depth);
	document.getElementById('height').setAttribute('value', reset_height);
	document.getElementById('x').setAttribute('value', reset_x);
	document.getElementById('y').setAttribute('value', reset_y);
	document.getElementById('z').setAttribute('value', reset_z);
}

// Apply Dimensions Function
function applyDimensions(event){
	event.preventDefault();
}