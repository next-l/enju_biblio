require 'enju_seed'
require 'paper_trail'
require 'paperclip'
require 'paperclip-meta'
require 'validates_timeliness'
require 'dynamic_form'
require 'simple_form'
require 'resque_mailer'
require 'library_stdnums'
require 'lisbn'
require 'statesman'
require 'faraday'
require 'nkf'
begin
  require 'charlock_holmes/string'
rescue LoadError
end
require "protected_attributes" if Rails::VERSION::MAJOR == 4

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
