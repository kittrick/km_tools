#----------------------------------------------------------------------------------------#
# 
# Version: 1.2.6
# Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
# 
#----------------------------------------------------------------------------------------#

require 'sketchup.rb'

module KM_Tools

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
			updateObserver = ModelUpdate.new(self)
		    Sketchup.active_model.add_observer(updateObserver)
		    selectionObserver = SelectionUpdate.new(self)
    		Sketchup.active_model.selection.add_observer(selectionObserver)

		end #initialize

		def get_object_info
			selection = Sketchup.active_model.selection.first
			if !defined? selection.name.length && selection.name.length > 0
				entity_name = selection.name
			elsif !defined? selection.definition && selection.definition.length > 0
				entity_name = selection.definition
			else
				entity_name = selection.typename
			end
			js_command = "document.getElementById('entity_name').innerHTML = '#{entity_name}';"
			js_command += "document.getElementById('entity_name').setAttribute('data-name','#{entity_name}');"

			entity_width = selection.bounds.width.to_s
			entity_depth = selection.bounds.depth.to_s
			entity_height = selection.bounds.height.to_s
			js_command += "document.getElementById('width').value = '#{entity_width}';"
			js_command += "document.getElementById('width').setAttribute('data-width','#{entity_width}');"
			js_command += "document.getElementById('depth').value = '#{entity_depth}';"
			js_command += "document.getElementById('depth').setAttribute('data-depth','#{entity_depth}');"
			js_command += "document.getElementById('height').value = '#{entity_height}';"
			js_command += "document.getElementById('height').setAttribute('data-height','#{entity_height}');"

			if (selection.typename == 'Group') || (selection.typename == 'ComponentInstance')
				entity_x = selection.transformation.origin[0].to_s
				entity_y = selection.transformation.origin[1].to_s
				entity_z = selection.transformation.origin[2].to_s
			else
				entity_x = 0
				entity_y = 0
				entity_z = 0
			end
			js_command += "document.getElementById('x').value = '#{entity_x}';"
			js_command += "document.getElementById('x').setAttribute('data-x','#{entity_x}');"
			js_command += "document.getElementById('y').value = '#{entity_y}';"
			js_command += "document.getElementById('y').setAttribute('data-y','#{entity_y}');"
			js_command += "document.getElementById('z').value = '#{entity_z}';"
			js_command += "document.getElementById('z').setAttribute('data-z','#{entity_z}');"
			@@my_dialog.execute_script(js_command)
		end #get_object_info

		def display_info_window
			@@my_dialog.show_modal
			get_object_info
		end #display_info_window

		# Copies Text to the Clipboard (OSX)
		def pbcopy(input)
			str = input.to_s
			IO.popen('pbcopy', 'w') { |f| f << str }
			str
		end #pbcopy
		
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