$KCODE = 'u'

require 'ramaze'
require 'haml' # not sure why i need this.
require 'maruku'
require 'builder'

require 'controller/init'
require 'vendor/feed_convert'

THEME = 'espresso_libre'

Ramaze::Cache.add(:feed)
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
