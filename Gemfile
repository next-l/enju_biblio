source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

# Declare your gem's dependencies in enju_biblio.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
#gem 'enju_loc', github: 'next-l/enju_loc'
gem 'enju_oai', github: 'next-l/enju_oai'
gem 'enju_bookmark', github: 'next-l/enju_bookmark'
gem 'sassc-rails'
gem 'paper_trail'
gem 'jbuilder'
gem 'sprockets', '~> 3.7'
group :test do
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'webdrivers'
end
