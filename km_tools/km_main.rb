#----------------------------------------------------------------------------------------#
# 
# Version: 1.3.3
# Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
# 
#----------------------------------------------------------------------------------------#

require 'sketchup.rb'

module KM_Tools

	#----------------------------------------------------------------------------------------#
	# 
	# These are event listeners that trigger updates.
	# 
	#----------------------------------------------------------------------------------------#

	#Update on Model Change
	class ModelUpdate < Sketchup::ModelObserver
		def initialize(tool)
			@tool = tool
		end
		def onTransactionCommit(selection)
			@tool.get_object_info
		end
		def onTransactionUndo(selection)
			@tool.get_object_info
		end
		def onTransactionRedo(selection)
			@tool.get_object_info
		end
		def onExplode(selection)
			@tool.get_object_info
		end
	end
	class SelectionUpdate < Sketchup::SelectionObserver
		def initialize(tool)
			@tool = tool
		end
		def onSelectionBulkChange(selection)
			@tool.get_object_info
		end
		def onSelectionAdded(selection)
		 	@tool.get_object_info
		end
		def onSelectionCleared(selection)
		 	@tool.get_object_info
		end
	end

	#----------------------------------------------------------------------------------------#
	# 
	# Dimension Tool Class, now all together! Working Much much better!
	# 
	#----------------------------------------------------------------------------------------#
	class Dimension_Tool
		
		@@info_window_open = false
		@@my_dialog = UI::WebDialog.new('Entity Dimensions', false, 'Selection Info', 240, 210, 200, 200, false)

		def initialize
			#----------------------------------------------------------------------------------------#
			# Menu Window Commands
			#----------------------------------------------------------------------------------------#
			ui_menu = UI.menu('Window').add_submenu('KM_Tools')
			ui_toolbar = UI::Toolbar.new('KM Tools')
			command1 = UI::Command.new('Entity_Dimensions'){
				display_info_window
			}
			command1.small_icon = 'Resources/Images/km_dim_tool_24.png'
			command1.large_icon = 'Resources/Images/km_dim_tool_54.png'
			command1.tooltip = 'Entity Dimensions'
			command1.status_bar_text = 'Entity Dimensions'
			command1.menu_text = 'Entity Dimensions'
			ui_toolbar.add_item(command1)
			ui_menu.add_item(command1)
			#----------------------------------------------------------------------------------------#
			# Create the WebDialog instance
			@@info_window_open = false

			# Find and show our html file
			html_path = get_file('km_entity_dimensions.html', 'html')
			@@my_dialog.set_file(html_path)
			@@my_dialog.set_on_close{
				@@info_window_open = false
			}
			@@my_dialog.add_action_callback("get_data") do |web_dialog, data|
				data = JSON.parse(data);
				data.each do |key, value|
					value.sub!('&quot;', '"')
				end
				data = inch_to_f(data)
				# Scale and Translate Command
				if data['command'] == 'apply'
					Sketchup.active_model.start_operation('apply transformation', 'true')
					perform_transformation(data)
					get_object_info
					Sketchup.active_model.commit_operation
				# Duplicate Command
				elsif data['command'] == 'copy'
					Sketchup.active_model.start_operation('copy & transform', 'true')
						prompts = ["How many copies? "]
 						defaults = ["1"]
 						input = UI.inputbox(prompts, defaults, "Copy selected entity.")
 						if(input)
 							data_orig = {}
 							data_trans = {}
 							data_diff = {}
 							data.each do |key, value|
 								if key.index('data-')
 									data_orig.merge!(key => value)
 								elsif ! key.index('command')
 									data_trans.merge!(key => value)
 								end
 							end
 							data_trans.each do |key, value|
 								diff = value.to_f - data_orig["data-#{key}"].to_f
 								data_diff.merge!(key => diff)
 							end
 							for i in 1..(input[0].to_i)
 								copy_selected_object()
 								perform_transformation(data)
 								data.each do |key, value|
 									data[key] = value.to_f + data_diff[key].to_f
 								end
 							end
							get_object_info
						end
					Sketchup.active_model .commit_operation
				# Reset Command
				elsif data['command'] == 'reset'
					get_object_info
				end
			end
			updateObserver = ModelUpdate.new(self)
		    Sketchup.active_model.add_observer(updateObserver)
		    selectionObserver = SelectionUpdate.new(self)
    		Sketchup.active_model.selection.add_observer(selectionObserver)

		end #initialize

		#----------------------------------------------------------------------------------------#
		# 
		# This Updates the info window
		# 
		#----------------------------------------------------------------------------------------#
		def get_object_info
			
			# Get Selection
			selection = Sketchup.active_model.selection

			# Set CSS and JS Locations
			css = get_file('Resources/css/styles.css')
			js = get_file('Resources/js/scripts.js')

			if selection.length == 1
				selection = selection.first
				# Start HTML
				html = %Q{
					<!html lang="en">
					<head>
						<title>Entity Dimensions</title>
						<meta charset="utf8" />
						<link rel="stylesheet" type="text/css" href="#{css}">
					</head>
					<body class="entity_dimensions">
				}
				# Get Element Name
				if defined? selection.definition.name
					name = selection.definition.name
				elsif ! defined? selection.typename
					name = "Select at least one object."
				else
					name = selection.typename
				end
				html += %Q{<h1 id="name" data-name="#{name}">#{name}</h1>}

				# Get Absolute Dimensions
				if name == 'Edge' || name == 'Face'
					absolute_dims = get_absolute_dimensions(selection)

					# Get Model Unit Settings
					unit_length = Sketchup.active_model.options["UnitsOptions"]["LengthPrecision"]

					# Get Bounding Box Dimensions
					if absolute_dims[0] > 0.0001 then html += html_input('width',"%.#{unit_length}f\"" % absolute_dims[0], false) end
					if absolute_dims[1] > 0.0001 then html += html_input('depth',"%.#{unit_length}f\"" % absolute_dims[1], false) end
					if absolute_dims[2] > 0.0001 then html += html_input('height',"%.#{unit_length}f\"" % absolute_dims[2], false) end

					html += %Q{</body></html>}
					@@my_dialog.set_html(html)
				else
					html += %Q{<form name="info_form" id="info_form">}
					absolute_dims = get_absolute_dimensions(selection)
					relativePos = get_relative_position(selection)

					# Get Model Unit Settings
					unit_length = Sketchup.active_model.options["UnitsOptions"]["LengthPrecision"]

					# Get Bounding Box Dimensions
					html += html_input('width',"%.#{unit_length}f\"" % absolute_dims[0])
					html += html_input('depth',"%.#{unit_length}f\"" % absolute_dims[1])
					html += html_input('height',"%.#{unit_length}f\"" % absolute_dims[2])

					# Get x, y ,z Coordinates
					if (selection.typename == 'Group') || (selection.typename == 'ComponentInstance')
						html += html_input('x',"%.#{unit_length}f\"" % relativePos[0])
						html += html_input('y',"%.#{unit_length}f\"" % relativePos[1])
						html += html_input('z',"%.#{unit_length}f\"" % relativePos[2])
					end
					html += %Q{
						<button name="reset" id="reset">Reset</button>
						<button name="copy" id="copy">copy</button>
						<button name="apply" id="apply">Apply</button>
						</form>}
					html += %Q{<script type="text/javascript" src="#{js}"></script></body></html>}
					@@my_dialog.set_html(html)
				end
			elsif selection.length > 1
				# Start HTML
				html = %Q{
					<!html lang="en">
					<head>
						<title>Entity Dimensions</title>
						<meta charset="utf8" />
						<link rel="stylesheet" type="text/css" href="#{css}">
					</head>
					<body class="entity_dimensions">
					<h1 id="name">Selection</h1>
				}

				# Count the number of objects
				html += html_input('Selected:', Sketchup.active_model.selection.length.to_s + ' entities', false)

				html += %Q{</body></html>}
				@@my_dialog.set_html(html)
			else
				html = %Q{
					<!html lang="en">
						<head>
							<title>Entity Dimensions</title>
							<meta charset="utf8" />
							<link rel="stylesheet" type="text/css" href="#{css}">
						</head>
						<body class="entity_dimensions">
							<h1 class="notice">Please select<br/>at least<br/>one entity</h1>
						<body>
					</html>
				}
				@@my_dialog.set_html(html)
			end

		end #get_object_info

		#----------------------------------------------------------------------------------------#
		# 
		# This updates the info Window
		# 
		#----------------------------------------------------------------------------------------#
		def display_info_window
			@@my_dialog.show_modal
			get_object_info
		end #display_info_window

		#----------------------------------------------------------------------------------------#
		# 
		# This method gets absolute dimensions instead of Sketchup's width depth height
		# 
		#----------------------------------------------------------------------------------------#
		def get_absolute_dimensions(selection)
			corners = get_corners(selection)
			xArray, yArray, zArray = [], [], []
			corners.each do |coord|
				xArray.push coord[0]
				yArray.push coord[1]
				zArray.push coord[2]
			end
			xArray.sort!
			yArray.sort!
			zArray.sort!

			xLen = xArray[-1] - xArray[0]
			yLen = yArray[-1] - yArray[0]
			zLen = zArray[-1] - zArray[0]

			dimensions = [xLen, yLen, zLen]
			return dimensions
		end

		#----------------------------------------------------------------------------------------#
		# 
		# This method gets absolute an object's position relative to the current view axis
		# In the futre this should accept a point instead of an object so that the user can
		# set the position based on a side or corner. Still a work in progress.
		# Does not currently work with rotated origins, just translated ones.
		# 
		#----------------------------------------------------------------------------------------#
		def get_relative_position(selection)
			view_origin = Sketchup.active_model.axes.origin
			selection_position = selection.transformation.origin
			relative_position = [
				selection_position[0] - view_origin[0],
				selection_position[1] - view_origin[1],
				selection_position[2] - view_origin[2]
			]
			return relative_position
		end

		#----------------------------------------------------------------------------------------#
		# 
		# This performs the actual transformation
		# 
		#----------------------------------------------------------------------------------------#
		def perform_transformation(data)
			# Get Location Data
			selection = Sketchup.active_model.selection.first
			object_position = get_relative_position(selection)

			# Don't trust sketchup's built in height, width, depth, using my own
			dimensions = get_absolute_dimensions(selection)
			origin = Geom::Point3d.new object_position[0], object_position[1], object_position[2]

			xscale = data['width'] / dimensions[0]
			yscale = data['depth'] / dimensions[1]
			zscale = data['height'] / dimensions[2]

			# Scale the object
			transformation = Geom::Transformation.scaling origin, xscale, yscale, zscale
			selection.transform!(transformation)

			# Translation Math
			new_x = - object_position[0] + data['x']
			new_y = - object_position[1] + data['y']
			new_z = - object_position[2] + data['z']

			vector = Geom::Vector3d.new new_x, new_y, new_z

			# Translate the Object
			transformation = Geom::Transformation.translation vector
			selection.transform!(transformation)
		end

		#----------------------------------------------------------------------------------------#
		# 
		# This method turns strings in the input data into numbers
		# 
		#----------------------------------------------------------------------------------------#
		def inch_to_f(data)
			data.each do |key, value|
				if value.index('"')
					data["#{key}"] = value.chomp('"').to_f
				end
			end
			return data
		end

		#----------------------------------------------------------------------------------------#
		# 
		# Copies the selected object and then selects it
		# 
		#----------------------------------------------------------------------------------------#
		def copy_selected_object()
			model = Sketchup.active_model
			entities = model.active_entities
			group = entities.add_group Sketchup.active_model.active_entities.first
			copy = group.copy
			group.explode
			copy.explode
			model.selection.clear
			model.selection.add entities[-1]
		end

		#----------------------------------------------------------------------------------------#
		# 
		# This method gets object corners
		# 
		#----------------------------------------------------------------------------------------#
		def get_corners(selection)
			bounds = selection.bounds
			corners = []
			for i in 0..7
				corners[i] = bounds.corner(i)
			end
			return corners
		end

		#----------------------------------------------------------------------------------------#
		# 
		# The following Methods are helpers and shortcuts.
		# 
		#----------------------------------------------------------------------------------------#
		# Copies Text to the Clipboard (OSX)
		def pbcopy(input)
			str = input.to_s
			IO.popen('pbcopy', 'w') { |f| f << str }
			str
		end #pbcopy

		# Returns an HTML Label and Input field as a String
		def html_input(name, value, editable = true)
			if editable
				value.to_s.sub!('"','&quot;')
				html = %Q{
					<label for="#{name}">#{name.capitalize}:</label>
					<input name="#{name}" id="#{name}" value="#{value}" data-#{name}="#{value}"/>
				}
				return html
			else
				value.to_s.sub!('"','&quot;')
				html = %Q{
					<label for="#{name}">#{name.capitalize}:</label>
					<span id="#{name}">#{value}</span>
				}
				return html
			end
		end
		
		# Fetches Files
		def get_file(file, type = '')
			case type
				when 'html'
					return Sketchup.find_support_file(file, "Plugins/#{$KM_folder}/Resources/html/")
				when 'image'
					return Sketchup.find_support_file(file, "Plugins/#{$KM_folder}/Resources/images/")
				else
					return Sketchup.find_support_file(file, "Plugins/#{$KM_folder}/")
			end
		end #get_file
		
		# Adds Cursors
		def set_cursor(url , x = 0, y = 0)
			cursor_path = get_image(url)
			@km_object_info_cursor = UI.create_cursor(cursor_path, x, y)
			UI.set_cursor(@km_object_info_cursor)
		end #set_cursor

	end #Dimension_Tool
	dimension_tool = Dimension_Tool.new

end #KMTools
file_loaded(__FILE__)