//----------------------------------------------------------------------------------------
// 
// Version: 1.2.6
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

	// Reset Variables
	reset_entity_name = document.getElementById('entity_name').getAttribute('data-name');
	reset_width = document.getElementById('width').getAttribute('data-width');
	reset_depth = document.getElementById('depth').getAttribute('data-depth');
	reset_height = document.getElementById('height').getAttribute('data-height');
	reset_x = document.getElementById('x').getAttribute('data-x');
	reset_y = document.getElementById('y').getAttribute('data-y');
	reset_z = document.getElementById('z').getAttribute('data-z');
	
	// Reset Values
	document.getElementById('entity_name').innerHTML = reset_entity_name;
	document.getElementById('width').value = reset_width; 
	document.getElementById('depth').value = reset_depth;
	document.getElementById('height').value = reset_height;
	document.getElementById('x').value = reset_x;
	document.getElementById('y').value = reset_y;
	document.getElementById('z').value = reset_z;
}

// Apply Dimensions Function
function applyDimensions(event){
	event.preventDefault();
}