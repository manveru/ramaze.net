$KCODE = 'u'

require 'rubygems'
require 'ramaze'
require 'haml' # not sure why i need this.
require 'maruku'

require 'controller/init'

THEME = 'espresso_libre'

Ramaze::Global.content_type = 'text/html; charset=utf-8'

#  private
#   def source(name)
#     file = "source/#{name}"
#     ultraviolet(fille, :style => THEME)
#   end

#   def uv(name = THEME)
#     css = ultraviolet_css(name)
#     respond File.open(css)
#   end
