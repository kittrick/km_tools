#----------------------------------------------------------------------------------------#
# Permission to use, copy, modify, and distribute this software for 
# any purpose and without fee is hereby granted, provided the above
# copyright notice appear in all copies.
#
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.
#----------------------------------------------------------------------------------------#
#
# Version 1.1:
#	Bare bones of the plugin, added toolbar and menu functionality, cleaned up the code a
# 	bit. I'm still new to ruby and I have to figure out how this plugin will actually
# 	interact with the UI and the model. The goal is to create a tool that will allow the user
# 	to scale a selected object to specified absolute dimensions instead of scaling based on
# 	a relative percentage.
#
#----------------------------------------------------------------------------------------#
require 'sketchup.rb'
require 'extensions.rb'

module KM_Tools

	@name = 'KM_Tools'
	@version = '1.1'
	$KM_folder = 'km_tools'
	@sdate = '17 Aug 16'
	@creator = 'Kit MacAllister'
	@description = 'Assorted Sketchup Tools Created by Kit MacAllister'

	file__ = __FILE__
	file__ = file__.force_encoding('UTF-8') if defined?(Encoding)
	file__ = file__.gsub(/\\/, '/')

	path = File.join(File.dirname(file__), $KM_folder, "km_main.rb") 
	ext = SketchupExtension.new('KM_Tools', path) 
	ext.creator = @creator 
	ext.version = @version + ' - ' + @sdate 
	ext.copyright = @creator + ' - © 2016' 
	ext.description = @description
	Sketchup.register_extension ext, true

	def KM_Tools.get_name ; @name ; end
	def KM_Tools.get_date ; @sdate ; end
	def KM_Tools.get_version ; @version ; end

	def KM_Tools.register_plugin_for_KMTools 
		{	
			:name => @name,
			:author => @creator,
			:version => @version,
			:date => @sdate,	
			:description => @description,
		}
	end #def

end #Module KMTools

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