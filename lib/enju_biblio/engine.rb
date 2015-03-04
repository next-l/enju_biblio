require 'paper_trail'
require 'validates_timeliness'
require 'dynamic_form'
require 'simple_form'
require 'library_stdnums'
require 'lisbn'
require 'statesman'
require 'faraday'
require 'nkf'
require "mini_magick"
require "refile/rails"
require "refile/image_processing"
begin
  require 'charlock_holmes/string'
rescue LoadError
end

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
