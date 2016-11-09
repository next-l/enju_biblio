$:.push File.expand_path("../lib", __FILE__)

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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/log/*"] - Dir["spec/dummy/solr/{data,pids,default,development,test}/*"] - Dir["spec/dummy/tmp/*"]

  s.add_dependency "enju_seed", "~> 0.2.0.beta.6"
  s.add_dependency "shrine"
  s.add_dependency "marc"
  s.add_dependency "paper_trail", "~> 5.2"
  s.add_dependency "validates_timeliness", "~> 4.0"
  s.add_dependency "simple_form", "~> 3.3"
  s.add_dependency "dynamic_form"
  s.add_dependency "library_stdnums"
  s.add_dependency "lisbn"
  s.add_dependency "statesman"
  s.add_dependency "faraday"
  s.add_dependency "cocoon"
  s.add_dependency "image_processing"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 3.5"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "vcr", "~> 3.0"
  s.add_development_dependency "sunspot_solr", "2.2.0"
  #s.add_development_dependency "enju_leaf", "~> 1.2.0.beta.1"
  #s.add_development_dependency "enju_subject", "~> 0.2.0.beta.1"
  #s.add_development_dependency "enju_inventory", "~> 0.2.0.beta.1"
  #s.add_development_dependency "enju_bookmark", "~> 0.2.0.beta.1"
  #s.add_development_dependency "enju_event", "~> 0.2.0.beta.1"
  #s.add_development_dependency "enju_manifestation_viewer", "~> 0.2.0.beta.1"
  #s.add_development_dependency "enju_circulation", "~> 0.2.0.beta.1"
  #s.add_development_dependency "enju_ndl", "~> 0.2.0.beta.1"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "webmock"
  s.add_development_dependency "sunspot-rails-tester"
  s.add_development_dependency "annotate"
  s.add_development_dependency "rspec-activemodel-mocks"
  s.add_development_dependency "redis-rails"
  s.add_development_dependency "resque-scheduler", "~> 4.3"
  s.add_development_dependency "codeclimate-test-reporter", "~> 1.0.0"
end
