require 'enju_core'
require 'inherited_resources'
require 'paper_trail'
require 'paperclip'
require 'state_machine'
require 'validates_timeliness'
require 'has_scope'
require 'dynamic_form'
require 'simple_form'
require 'resque_mailer'
require 'library_stdnums'
require 'charlock_holmes/string' rescue nil

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
