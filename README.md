# KM Tools
A set of tools for Sketchup to assist in production design.

## Installation
Simply download the `km_tools.x.x.x.rbz` plugin, open `Sketchup > Preferences` and navigate to
the `Extensions` settings. Choose `Install Extension` and add the km_tools plugin!

This plugin is in active development and has only been tested on a Mac. Use at your own discretion!

## History
### Version 1.3.7
	Removed global variables so I can add this extension to the Extension Warehouse.
### Version 1.3.6
	Added math evaluation to input fields, making quick math much easier!
### Version 1.3.5
	Finally fixed a huge bug with the copy function!
	Removed unnecessary icon files.
### Version 1.3.4
	Updated a lot of the math relating to rotations, which are much more stable now. I am still
	trying to figure out how to get relative dimensions.
### Version 1.3.3
	Updated how distance is calculated from the axis resulting in more predictable transformations.
	Added functionality to the copy function allowing the user to specify the number of copies.
### Version 1.3.2
	Rearranged the transformation method for more predictable (correct) results.
### Version 1.3.1
	Added a packaged version to the repository for easy download.
### Version 1.3.0
	Added information about selected objects, faces, and edges.
### Version 1.2.9
	The plugin is now working very well and is fairly stable. The Copy function sometimes
	results in unpredictable duplication and still needs some modification.
### Version 1.2.8
	First attempts at allowing the user to select the transformation axis, very complicated, still WIP.
### Version 1.2.7
	Big updates in how the html window is written, much more flexible.
	The HTML window now parses inch and foot data when the user enters input.
	Sketchup now receives JSON data from the apply button, although it doesn't yet take action.
### Version 1.2.6
	Made the "Reset" button work good!
### Version 1.2.5
	Combined the Menu and Entity Dimension classes which solves a lot of my variable issues!
	The info window now updates when an entity is moved or scaled!
### Version 1.2.4
	Cleaned up the main logic functions, still wrapping my head around ruby and sketchup.
### Version 1.2.3
	Cleaned up helper functions
	Added model update listener, currently a work in progress
	Added selection info to the entity info window
### Version 1.2.2
    Changed the functionality from a tool to an information window.
    Added HTML and CSS files for information window, not currently hooked up to Sketchup Data.
### Version 1.2.1
    Added a new helper class and fixed a bug with cursor icons.
### Version 1.2
    Updated License Information and cleaned up folder structure. Added to github.
### Version 1.1
    Bare bones of the plugin, added toolbar and menu functionality, cleaned up the code a
    bit. I'm still new to ruby and I have to figure out how this plugin will actually
    interact with the UI and the model. The goal is to create a tool that will allow the user
    to scale a selected object to specified absolute dimensions instead of scaling based on
    a relative percentage.

## Credits
Developed by Kit MacAllister

## License
Copyright (c) 2016 Kit MacAllister

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the "Software"),
to deal in the Software without restriction, including without limitation
the rights to use, copy, modify, merge, publish, distribute, sublicense,
and/or sell copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
IN THE SOFTWARE.
