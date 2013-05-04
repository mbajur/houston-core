source 'http://rubygems.org'

gem 'rails', '3.2.13'
gem 'activerecord-postgres-hstore' # remove when Rails 4.0

gem 'pg'

gem 'addressable', :require => 'addressable/uri'
gem 'redcarpet'
gem 'bundler' # used to parse Gemfiles
gem 'cancan'
gem 'childprocess'
gem 'default_value_for'
gem 'devise',           '~> 2.2.3'
gem 'devise_invitable', '~> 1.1.6'
gem 'devise_ldap_authenticatable', :git => 'https://github.com/houstonmc/devise_ldap_authenticatable.git'
gem 'faraday'
gem 'foreman'
gem 'foreman-export-initscript', :git => 'git://github.com/LewisJA/foreman-export-initscript.git'
gem 'gemoji'
gem 'googlecharts'
gem 'hpricot'
gem 'nokogiri'
gem 'premailer' # for inlining CSS in HTML emails
gem 'remotable', '>= 0.2.2', :git => 'git://github.com/boblail/remotable.git'
gem 'resque'
gem 'rugged', '0.17.0.b7' # for speaking Git
gem 'yajl-ruby', :require => 'yajl/json_gem'
gem 'whenever' # a DSL for writing CRON jobs

gem 'backbone-rails'
gem 'd3js-rails'
gem 'font-awesome-rails'
gem 'handlebars_assets', '0.8.2'
gem 'jquery-rails'
gem 'sass-rails',   '~> 3.2.3' # Sass is required in production (see layouts/email.html.erb)
gem 'sugar-rails'
gem 'twitter-bootstrap-rails'

# Tooling
gem 'airbrake' # exception notification
gem 'newrelic_rpm'



# Modules
#
# Here modules are dynamically included in the Gemfile
#
require './lib/configuration.rb' # Loads Houston's configuration
Houston.config.modules.each do |mod|
  gem *mod.gemspec
end



# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'therubyracer' # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'less-rails' # For Twitter Bootstrap
  gem 'uglifier', '>= 1.0.3'
  
  # gem 'turbo-sprockets-rails3', '>= 0.3.6'
end

group :development do
  gem 'unicorn-rails'
  gem 'letter_opener'
  # gem 'rack-mini-profiler'
  
  # Better error messages
  gem 'better_errors'
  gem 'meta_request'
end

group :development, :test do
  gem 'minitest'
  gem 'turn', :require => false # for prettier tests
  gem 'rr'
  
  # For Jenkins
  gem 'simplecov', :require => false
  gem 'simplecov-json', :require => false, :git => 'git://github.com/houstonmc/simplecov-json.git'
  gem 'ci_reporter', :require => false
  
  gem 'pry' # for debugging
end
