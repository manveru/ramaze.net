class Controller < Ramaze::Controller
  map nil
  helper :xhtml, :user, :formatting, :aspect, :maruku, :ultraviolet
  engine :Haml

  def mkd(file)
    maruku(File.read("view/#{file}.mkd"))
  end
end

require 'controller/main'
require 'controller/css'
