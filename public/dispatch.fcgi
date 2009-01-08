#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'start_common')

# FCGI doesn't like you writing to stdout
Ramaze::Log.loggers = [ Ramaze::Logger::Informer.new( File.join(__DIR__, '..', 'ramaze.fcgi.log') ) ]
Ramaze::Global.adapter = :fcgi

#Ramaze.start :sourcereload => false, :adapter => :fcgi, :load_engines => [:Ezamar, :Haml]
Ramaze.start :adapter => :fcgi, :load_engines => [:Ezamar, :Haml]

