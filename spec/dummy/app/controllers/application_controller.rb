class ApplicationController < ActionController::Base
  include Pundit
  protect_from_forgery

  include EnjuLeaf::Controller
  include EnjuBiblio::Controller
  include EnjuLibrary::Controller
  include EnjuEvent::Controller
  include EnjuSubject::Controller
  enju_inventory
end
