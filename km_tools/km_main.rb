#----------------------------------------------------------------------------------------#
# 
# Version: 1.2.8
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
	end
	class SelectionUpdate < Sketchup::SelectionObserver
		def initialize(tool)
			@tool = tool
		end
		def onSelectionBulkChange(selection)
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
		@@my_dialog = UI::WebDialog.new("Entity Dimensions", false, "Selection Info", 240, 210, 200, 200, false)

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
				perform_transformation(data)
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

				# Add Transformation Anchors
				transformation_anchors

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
				html += %Q{<form name="info_form" id="info_form">}

				# Get Bounding Box Dimensions
				html += html_input('width',selection.bounds.width.to_s)
				html += html_input('depth',selection.bounds.depth.to_s)
				html += html_input('height',selection.bounds.height.to_s)

				# Get x, y ,z Coordinates
				if (selection.typename == 'Group') || (selection.typename == 'ComponentInstance')
					html += html_input('x',selection.transformation.origin[0].to_s)
					html += html_input('y',selection.transformation.origin[1].to_s)
					html += html_input('z',selection.transformation.origin[2].to_s)
				end
				html += %Q{<button name="reset" id="reset">Reset</button><button name="apply" id="apply">Apply</button></form>}
				html += %Q{<script type="text/javascript" src="#{js}"></script></body></html>}
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
							<h1 class="notice">Please select a single object.</h1>
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
		# This Method applies the requested transformation to the selected object or component.
		# 
		#----------------------------------------------------------------------------------------#
		def perform_transformation(data)
			@selection = Sketchup.active_model.selection.first
			if data.key?('width') && data.key?('depth') && data.key?('height')
				xscale = (data['width'].sub '"', '').to_f / @selection.bounds.width.to_f
				yscale = (data['depth'].sub '"', '').to_f / @selection.bounds.depth.to_f
				zscale = (data['height'].sub '"', '').to_f / @selection.bounds.height.to_f
			end
			transformation = Geom::Transformation.scaling xscale, yscale, zscale
			@selection.transform!(transformation)
		end

		#----------------------------------------------------------------------------------------#
		# 
		# This method adds transformation Anchors
		# 
		#----------------------------------------------------------------------------------------#
		def transformation_anchors
			@selection = Sketchup.active_model.selection.first
			bounds = @selection.bounds
			corners = []
			for i in 0..7
				corners[i] = bounds.corner(i)
			end
			corners.each do |coords|
				#drawCube(coords)
			end
			puts corners
			puts "\n"*3
		end

		#This related function draws cubes at the anchor points
		def drawCube(coord)
			model = Sketchup.active_model
			entities = model.entities
			# Plane 1
			pt1 = [coord[0]-1, coord[1]-1, coord[2]]
			pt2 = [coord[0]+1, coord[1]-1, coord[2]]
			pt3 = [coord[0]-1, coord[1]+1, coord[2]]
			pt4 = [coord[0]+1, coord[1]+1, coord[2]]
			face1 = entities.add_face pt1, pt2, pt4, pt3
			face1.material = "red"

			# Plane 2
			pt1 = [coord[0], coord[1]+1, coord[2]+1]
			pt2 = [coord[0], coord[1]-1, coord[2]+1]
			pt3 = [coord[0], coord[1]+1, coord[2]-1]
			pt4 = [coord[0], coord[1]-1, coord[2]-1]
			face2 = entities.add_face pt1, pt2, pt4, pt3
			face2.material = "green"
			
			# Plane 3
			pt1 = [coord[0]+1, coord[1], coord[2]+1]
			pt2 = [coord[0]-1, coord[1], coord[2]+1]
			pt3 = [coord[0]+1, coord[1], coord[2]-1]
			pt4 = [coord[0]-1, coord[1], coord[2]-1]
			face3 = entities.add_face pt1, pt2, pt4, pt3
			face3.material = "blue"

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
		def html_input(name, value)
			value.sub!('"','&quot;')
			html = %Q{
				<label for="#{name}">#{name.capitalize}:</label>
				<input name="#{name}" id="#{name}" value="#{value}" data-#{name}="#{value}"/>
			}
			return html
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