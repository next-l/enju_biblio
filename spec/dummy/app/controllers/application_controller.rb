class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  include EnjuLeaf::Controller
  include EnjuBiblio::Controller
  include EnjuLibrary::Controller
  enju_inventory
  enju_event
  enju_subject
end
