$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "enju_biblio/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "enju_biblio"
  s.version     = EnjuBiblio::VERSION
  s.authors     = ["Kosuke Tanabe"]
  s.email       = ["tanabe@mwr.mediacom.keio.ac.jp"]
  s.homepage    = "https://github.com/next-l/enju_biblio"
  s.summary     = "enju_biblio plugin"
  s.description = "Bibliographic record module for Next-L Enju"

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/log/*"] - Dir["spec/dummy/solr/{data,pids}/*"]

  s.add_dependency "enju_core", "~> 0.1.1.pre6"
  s.add_dependency "paperclip", "~> 3.5"
  s.add_dependency "paperclip-meta"
  s.add_dependency "aws-sdk"
  s.add_dependency "marc"
  s.add_dependency "inherited_resources"
  s.add_dependency "paper_trail"
  s.add_dependency "state_machine"
  s.add_dependency "validates_timeliness"
  s.add_dependency "simple_form"
  s.add_dependency "dynamic_form"
  s.add_dependency "library_stdnums"
  s.add_dependency "resque_mailer"
  s.add_dependency "lisbn"
  # s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "factory_girl_rails"
  s.add_development_dependency "vcr"
  s.add_development_dependency "sunspot_solr", "~> 2.1"
  s.add_development_dependency "enju_leaf", "~> 1.1.0.rc7"
  s.add_development_dependency "enju_subject", "~> 0.1.0.pre21"
  s.add_development_dependency "enju_inventory", "~> 0.1.11.pre8"
  s.add_development_dependency "enju_bookmark", "~> 0.1.2.pre12"
  s.add_development_dependency "enju_event", "~> 0.1.17.pre13"
  s.add_development_dependency "enju_manifestation_viewer", "~> 0.1.0.pre11"
  s.add_development_dependency "enju_export", "~> 0.1.1.pre4"
  s.add_development_dependency "enju_circulation", "~> 0.1.0.pre31"
  s.add_development_dependency "enju_ndl", "~> 0.1.0.pre27"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "fakeweb"
  s.add_development_dependency "sunspot-rails-tester"
end
