# KM Tools
A set of tools for Sketchup to assist in production design.

## Installation
Simply add the plugin to your sketchup plugin directory, found typically under:

`Users/<yourname>/Library/Application Support/Sketchup <year>/SketchupPlugins`

Where `<yourname>` is your username and `<year>` is the version of Sketchup you have installed.

This plugin is in active development and has only been tested on a Mac. Use at your own discretion!

## History
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
