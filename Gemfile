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
gem 'enju_seed', github: 'next-l/enju_seed'
gem 'enju_leaf', github: 'next-l/enju_leaf'
gem 'enju_library', github: 'next-l/enju_library'
gem 'enju_subject', github: 'next-l/enju_subject'
gem 'enju_message', github: 'next-l/enju_message'
gem 'enju_ndl', github: 'next-l/enju_ndl'
gem 'enju_oai', github: 'next-l/enju_oai'
gem 'sassc-rails'
gem 'jbuilder'
gem 'webpacker'
group :test do
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter', require: false
  gem 'webdrivers'
end
