require 'enju_library'
require 'dynamic_form'
require 'simple_form'
require 'library_stdnums'
require 'lisbn'
require 'faraday'
require 'nkf'
require 'rdf/turtle'
require 'rdf/vocab'
begin
  require 'charlock_holmes/string'
rescue LoadError
end

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
