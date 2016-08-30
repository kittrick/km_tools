#----------------------------------------------------------------------------------------#
### Credits:
# Developed by Kit MacAllister
#
### Version: 1.3.2
#
### License:
# Copyright (c) 2016 Kit MacAllister
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included
# in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
# OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
# IN THE SOFTWARE.
#
#----------------------------------------------------------------------------------------#
require 'sketchup.rb'
require 'extensions.rb'

module KM_Tools

	name = 'KM_Tools'
	version = '1.2.4'
	$KM_folder = 'km_tools'
	sdate = '08/23/2016'
	creator = 'Kit MacAllister'
	description = 'Assorted Sketchup Tools Created by Kit MacAllister'

	file__ = __FILE__
	file__ = file__.force_encoding('UTF-8') if defined?(Encoding)
	file__ = file__.gsub(/\\/, '/')

	path = File.join(File.dirname(file__), $KM_folder, "km_main.rb") 
	ext = SketchupExtension.new('KM_Tools', path) 
	ext.creator = creator 
	ext.version = version + ' - ' + sdate 
	ext.copyright = 'MIT Open Source - ' + creator + ' - © 2016' 
	ext.description = description
	Sketchup.register_extension ext, true

	def KM_Tools.get_name ; name ; end
	def KM_Tools.get_date ; sdate ; end
	def KM_Tools.get_version ; version ; end

	def KM_Tools.register_plugin_for_KMTools 
		{	
			:name => name,
			:author => creator,
			:version => version,
			:date => sdate,	
			:description => description,
		}
	end #def

end #Module KMTools 