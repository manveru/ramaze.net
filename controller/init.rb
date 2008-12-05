class Controller < Ramaze::Controller
  map nil
  helper :xhtml, :user, :formatting, :aspect, :maruku, :ultraviolet
  engine :Haml
end

require 'controller/main'
require 'controller/css'
