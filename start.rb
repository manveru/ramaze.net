require 'ramaze'
require 'maruku'
require 'nokogiri'

require 'controller/init'
require 'vendor/feed_convert'

THEME = 'espresso_libre'

Ramaze::Cache.add(:feed)
# Ramaze::Global.content_type = 'text/html; charset=utf-8'
Ramaze.start(:adapter => :thin, :port => 7000) if __FILE__ == $0
