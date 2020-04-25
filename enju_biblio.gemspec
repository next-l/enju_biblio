$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "enju_biblio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_biblio"
  s.version     = EnjuBiblio::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["nabeta@fastmail.fm"]
  s.homepage    = "https://github.com/next-l/enju_biblio"
  s.summary     = "enju_biblio plugin"
  s.description = "Bibliographic record module for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/{log,storage,solr,tmp}/**/*"]

  s.add_dependency "enju_library", "~> 0.5.0.beta.1"
  s.add_dependency "marc"
  s.add_dependency "simple_form", '~> 5.0'
  s.add_dependency "dynamic_form"
  s.add_dependency "library_stdnums"
  s.add_dependency "lisbn"
  s.add_dependency "faraday"
  s.add_dependency "rdf-turtle"
  s.add_dependency "rdf-vocab"

  s.add_development_dependency "enju_leaf", "~> 3.0.0.beta.1"
  s.add_development_dependency "enju_message", "~> 0.5.0.beta.1"
  s.add_development_dependency "enju_subject", "~> 0.5.0.beta.1"
  s.add_development_dependency "enju_ndl", "~> 0.5.0.beta.1"
  s.add_development_dependency "enju_oai", "~> 0.5.0.beta.1"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 4.0"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "vcr", "~> 5.0"
  s.add_development_dependency "sunspot_solr", "~> 2.5"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "webmock"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "resque"
  s.add_development_dependency "coveralls", '~> 0.8.23'
  s.add_development_dependency "capybara"
  s.add_development_dependency "selenium-webdriver"
  s.add_development_dependency "puma"
  s.add_development_dependency "annotate"
end
