require 'enju_core'
require 'inherited_resources'
require 'paper_trail'
require 'paperclip'
require 'paperclip-meta'
require 'state_machine'
require 'validates_timeliness'
require 'has_scope'
require 'dynamic_form'
#require 'simple_form'
require 'resque_mailer'
require 'library_stdnums'
require 'lisbn'
require 'nkf'
begin
  require 'charlock_holmes/string'
rescue LoadError
end

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
