require 'inherited_resources'
require 'acts_as_list'
require 'attribute_normalizer'
require 'cancan'
require 'devise'
require 'paper_trail'
require 'sunspot_rails'
require 'will_paginate'
require 'configatron'
require 'paperclip'
require 'state_machine'
require 'addressable/uri'
require 'validates_timeliness'
require 'enju_oai'
require 'has_scope'
require 'enju_ndl'

module EnjuBiblio
  class Engine < ::Rails::Engine
  end
end
