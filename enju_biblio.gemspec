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

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"] - Dir["spec/dummy/{log,private,solr,tmp}/**/*"] - Dir["spec/dummy/db/*.sqlite3"]
  s.post_install_message = <<-END
New migration file(s) are included in enju_biblio-0.3.10. Please run the following command after the installation:
enju_biblio-0.3.10では新しいマイグレーションファイルが含まれています。インストール後に以下のコマンドを実行してください:

$ bundle exec rake enju_biblio_engine:install:migrations

END

  s.add_dependency "enju_library", "~> 0.3.8.rc.2"
  s.add_dependency "marc"
  s.add_dependency "simple_form", '~> 5.0'
  s.add_dependency "dynamic_form"
  s.add_dependency "library_stdnums"
  s.add_dependency "lisbn"
  s.add_dependency "faraday"
  s.add_dependency "responders"

  s.add_development_dependency "enju_leaf", "~> 1.3.4.rc.2"
  s.add_development_dependency "enju_subject", "~> 0.3.1"
  s.add_development_dependency "enju_inventory", "~> 0.3.0"
  s.add_development_dependency "enju_bookmark", "~> 0.3.0"
  s.add_development_dependency "enju_message", "~> 0.3.1"
  s.add_development_dependency "enju_event", "~> 0.3.3"
  s.add_development_dependency "enju_ndl", "~> 0.3.2"
  s.add_development_dependency "enju_oai", "~> 0.3.0"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails", "~> 4.0"
  s.add_development_dependency "factory_bot_rails"
  s.add_development_dependency "vcr", "~> 6.0"
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
  s.add_development_dependency "rails", "~> 5.2"
end
