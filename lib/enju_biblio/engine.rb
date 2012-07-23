require 'enju_core'
require 'inherited_resources'
require 'paper_trail'
require 'paperclip'
require 'state_machine'
require 'validates_timeliness'
require 'enju_oai'
require 'has_scope'
require 'enju_ndl'
require 'dynamic_form'
require 'simple_form'
require 'resque_mailer'

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
