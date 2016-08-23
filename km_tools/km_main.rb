#----------------------------------------------------------------------------------------#
# 
# Version: 1.2.2
# Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
# 
#----------------------------------------------------------------------------------------#

require 'sketchup.rb'
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
		
		def get_file(file)
			return Sketchup.find_support_file(file, "Plugins/#{$KM_folder}/")
		end #get_file

		def get_html(file)
			return Sketchup.find_support_file(file, "Plugins/#{$KM_folder}/Resources/html/")
		end #get_file
		
		def get_image(file)
			return Sketchup.find_support_file(file, "Plugins/#{$KM_folder}/Resources/images/")
		end #get_file
		
		def set_cursor(url , x=0, y=0)
			cursor_path = get_image(url)
			@km_object_info_cursor = UI.create_cursor(cursor_path, x, y)
			UI.set_cursor(@km_object_info_cursor)
		end #set_cursor

	end #Helpers

	class Entity_Dimensions
		
		def initialize
			@helper = Helper.new
		end #initialize

		def info_window
			# Create the WebDialog instance
			my_dialog = UI::WebDialog.new("Entity Dimensions", false, "Selection Info", 240, 210, 200, 200, false)

			# Attach an action callback
			# my_dialog.add_action_callback("get_data") do |web_dialog,action_name|
			# UI.messagebox("Ruby says: Your javascript has asked for " + action_name.to_s)
			# end

			# Find and show our html file
			html_path = @helper.get_html('km_entity_dimensions.html')
			my_dialog.set_file(html_path)
			my_dialog.show_modal()
		end #info_window

	end #Entity_Dimensions

end #KMTools