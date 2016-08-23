#----------------------------------------------------------------------------------------#
# 
# Version: 1.2.1
# Copyright (c) Kit MacAllister 2016, MIT Open Source License. See README.md file for details.
# 
#----------------------------------------------------------------------------------------#

require 'sketchup.rb'
module KM_Tools

	module Menu
		unless file_loaded?(__FILE__)
			#----------------------------------------------------------------------------------------#
			@menu = UI.menu('Plugins').add_submenu('KM_Tools')
			@toolbar = UI::Toolbar.new('KM Tools')
			command1 = UI::Command.new('KM Dimension Tool'){
				unless defined? km_object_info_command
					km_dim_tool = KM_Dimension_Tool.new
					Sketchup.active_model.select_tool(km_dim_tool)
				end
			}
			command1.small_icon = 'Resources/Images/km_dim_tool_24.png'
			command1.large_icon = 'Resources/Images/km_dim_tool_54.png'
			command1.tooltip = 'Object Dimension Tool'
			command1.status_bar_text = 'Object Dimension Tool'
			command1.menu_text = 'Object Dimension Tool'
			@toolbar.add_item(command1)
			@menu.add_item(command1)
			#----------------------------------------------------------------------------------------#
		end
	end #Menu

	class Helper
		#----------------------------------------------------------------------------------------#
		# Global Methods
		#----------------------------------------------------------------------------------------#
		def pbcopy(input)
			str = input.to_s
			IO.popen('pbcopy', 'w') { |f| f << str }
			str
		end
		def set_cursor(url , x=0, y=0)
			cursor_path = Sketchup.find_support_file(url, "Plugins/#{$KM_folder}/Resources/images/")
			@km_object_info_cursor = UI.create_cursor(cursor_path, x, y)
			UI.set_cursor(@km_object_info_cursor)
		end
	end #Helpers

	class KM_Dimension_Tool
		#----------------------------------------------------------------------------------------#
		# A window that allows the user to set an objects absolute dimensions
		#----------------------------------------------------------------------------------------#
		def set_dims(width, depth, height, object)
			# prompts = ['Width:', 'Depth:', 'Height:']
			# defaults = [width.to_s, depth.to_s, height.to_s]
			# input = UI.inputbox(prompts, defaults, 'Set Object Dimensions:')
			# xscale = input[0].to_f / width.to_f
			# yscale = input[1].to_f / depth.to_f
			# zscale = input[2].to_f / height.to_f
			# scale = Geom::Transformation.scaling xscale, yscale, zscale
			# object.transform!(scale)
			dlg = UI::WebDialog.new("ObjectDimensions", true, "ObjectDimensions", 739, 641, 150, 150, true);
			dlg.set_url Sketchup.find_support_file("km_scale_tool.html", "Plugins/#{$KM_folder}/Resources/")
			dlg.show
		end
		def activate
			Sketchup.set_status_text 'KM_Object Info: Activated', SB_PROMPT
			@helper = Helper.new
      	end
      	def deactivate(view)
      		Sketchup.set_status_text 'KM_Object Info: Deactivated', SB_PROMPT
      	end
      	def onSetCursor
      		@helper.set_cursor('km_dim_tool_24.png')
      	end
      	def onLButtonUp(flags, x, y, view)
			ph = view.pick_helper
			ph.do_pick(x, y)
			entities = ph.all_picked
			if flags != 1048840
				if entities.length > 0
					(entities).each do |i|
						if(defined? i.bounds)
		      				@width, @depth, @height = i.bounds.width, i.bounds.depth, i.bounds.height
		      			end
		      			@object = i
	      			end
					set_dims(@width, @depth, @height, @object)
				end
			else
				if entities.length > 0
					messageString, dimString = '', ''
		      		(entities).each do |i|
		      			if (defined? i.name) && (i.name.length > 0)
							messageString += "#{i.name}\n\t"
						else
							messageString += "#{i.typename}\n\t"
						end
						if(defined? i.bounds)
			      			dimString += "#{i.bounds.width.to_s}Wx#{i.bounds.depth.to_s}Dx#{i.bounds.height.to_s}H"
			      		end
		      			messageString += dimString
		      		end
		      		messageString += "\n\nCopy dimensions to clipboard?"
		      		result = UI.messagebox messageString, MB_OKCANCEL
		      		if result == IDOK
		      			helper.pbcopy(dimString)
		      			Sketchup.set_status_text 'KM_Object Info: Dimensions copied to clipboard.', SB_PROMPT
		      		else
		      			Sketchup.set_status_text 'KM_Object Info: Dimensions not copied to clipboard.', SB_PROMPT
		      		end
		      	end
			end
      	end
      	def onMouseMove(flags, x, y, view)
			ph = view.pick_helper
			ph.do_pick(x, y)
			entities = ph.all_picked
			if entities.length > 0
	      		if flags == 1048840
	      			@helper.set_cursor('km_dim_info_24.png')
	  			else
	  				@helper.set_cursor('km_dim_plus_24.png')
	  			end
				messageString, dimString = '', ''
	      		(entities).each do |i|
	      			if (defined? i.name) && (i.name.length > 0)
						messageString += "#{i.name}: "
					else
						messageString += "#{i.typename}: "
					end
					if(defined? i.bounds)
	      				dimString += "#{i.bounds.width.to_s}Wx#{i.bounds.depth.to_s}Dx#{i.bounds.height.to_s}H"
	      			end
	      			messageString += dimString
	      		end
	      		Sketchup.set_status_text messageString, SB_PROMPT
	      	else
	      		Sketchup.set_status_text "KM_Object Info: No entities detected.", SB_PROMPT
	      	end
      	end
      	def onKeyDown(key, repeat, flags, view)
      		if key = VK_COMMAND
  				@helper.set_cursor('km_dim_info_24.png')
      		end
      	end
	end
end #KMTools
file_loaded(__FILE__)