#----------------------------------------------------------------------------------------#
# 
# Version: 1.2.3
# Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
# 
#----------------------------------------------------------------------------------------#

require 'sketchup.rb'
# This is an example of an observer that watches the
# component placement event.
class ModelUpdate < Sketchup::ModelObserver
	def onTransactionCommit(model)
		KM_Tools::Entity_Dimensions.get_object_info
	end
end

# Attach the observer.
Sketchup.active_model.add_observer(ModelUpdate.new)

module KM_Tools

	class Menu
		def initialize
			#----------------------------------------------------------------------------------------#
			@menu = UI.menu('Window').add_submenu('KM_Tools')
			@toolbar = UI::Toolbar.new('KM Tools')
			command1 = UI::Command.new('Entity Dimensions'){
				@entity_dimensions = Entity_Dimensions.new
				@entity_dimensions.info_window
			}
			command1.small_icon = 'Resources/Images/km_dim_tool_24.png'
			command1.large_icon = 'Resources/Images/km_dim_tool_54.png'
			command1.tooltip = 'Entity Dimensions'
			command1.status_bar_text = 'Entity Dimensions'
			command1.menu_text = 'Entity Dimensions'
			@toolbar.add_item(command1)
			@menu.add_item(command1)
			#----------------------------------------------------------------------------------------#
		end
	end #Menu

	#Initialize Menu
	menu = Menu.new

	class Helper
		
		#----------------------------------------------------------------------------------------#
		# Global Methods
		#----------------------------------------------------------------------------------------#
		
		def pbcopy(input)
			str = input.to_s
			IO.popen('pbcopy', 'w') { |f| f << str }
			str
		end #pbcopy
		
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
		
		def set_cursor(url , x=0, y=0)
			cursor_path = get_image(url)
			@km_object_info_cursor = UI.create_cursor(cursor_path, x, y)
			UI.set_cursor(@km_object_info_cursor)
		end #set_cursor

	end #Helpers

	class Entity_Dimensions
		
		#Class Vars
		@@info_window_open = false
		
		def initialize
			@helper = Helper.new
			# Create the WebDialog instance
			@my_dialog = UI::WebDialog.new("Entity Dimensions", false, "Selection Info", 240, 210, 200, 200, false)

			# Attach an action callback
			# my_dialog.add_action_callback("get_data") do |web_dialog,action_name|
			# UI.messagebox("Ruby says: Your javascript has asked for " + action_name.to_s)
			# end

			# Find and show our html file
			html_path = @helper.get_html('km_entity_dimensions.html')
			@my_dialog.set_file(html_path)
			@my_dialog.set_on_close{
				@@info_window_open = false
			}
		end #initialize

		def get_object_info(target = @my_dialog)
			selection = Sketchup.active_model.selection.first
			unless defined? selection.name
				entity_name = selection.name
			else
				entity_name = selection.typename
			end
			entity_width = selection.bounds.width.to_s
			entity_depth = selection.bounds.depth.to_s
			entity_height = selection.bounds.height.to_s
			entity_x = selection.transformation.origin[0].to_s
			entity_y = selection.transformation.origin[1].to_s
			entity_z = selection.transformation.origin[2].to_s
			js_command = "document.getElementById('entity_name').innerHTML = '#{entity_name}';"
			js_command += "document.getElementById('width').setAttribute('value','#{entity_width}');"
			js_command += "document.getElementById('depth').setAttribute('value','#{entity_depth}');"
			js_command += "document.getElementById('height').setAttribute('value','#{entity_height}');"
			js_command += "document.getElementById('x').setAttribute('value','#{entity_x}');"
			js_command += "document.getElementById('y').setAttribute('value','#{entity_y}');"
			js_command += "document.getElementById('z').setAttribute('value','#{entity_z}');"
			target.execute_script(js_command)
		end #get_object_info

		def info_window
			if !@@info_window_open
				@my_dialog.show_modal(){
					@@info_window_open = true
					get_object_info(@my_dialog)
				}
			end
		end #info_window

	end #Entity_Dimensions

end #KMTools