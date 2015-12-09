class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  include EnjuLeaf::Controller
  include EnjuBiblio::Controller
  enju_library
  enju_inventory
  enju_event
  enju_subject
end
