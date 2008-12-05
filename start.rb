$KCODE = 'u'

require 'ramaze'
require 'maruku'

require 'controller/init'

THEME = 'espresso_libre'


#   def reset
#     respond File.open('view/css/reset.css')
#   end

#   def ruby
#     respond File.open('view/css/ruby.css')
#   end
#end

# Ramaze::Rewrite[/^(.*)\.css$/] = '%s'
Ramaze::Global.content_type = 'text/html; charset=utf-8'
Ramaze.start :run_loose => ($0 != __FILE__), :adapter => :thin, :port => 7000

#  private
#   def source(name)
#     file = "source/#{name}"
#     ultraviolet(fille, :style => THEME)
#   end

#   def uv(name = THEME)
#     css = ultraviolet_css(name)
#     respond File.open(css)
#   end
