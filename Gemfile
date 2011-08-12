source 'http://rubygems.org'

gem 'rake'
gem 'sequel', '>=3.0.0'
gem 'simple-rss', '>=1.2.2'
gem 'sinatra', '>=1.0', :require => false
gem 'erubis', '>=2.6.6'
gem 'foreman'
gem 'thin'

group :production do
  gem 'pg'
end
 
group :development, :test do
  gem 'sqlite3'
end

group :test do
  gem 'rspec', '>=2.4.0'
  gem 'rack-test'
  gem 'awesome_print'
  gem 'simplecov', '>=0.4.0', :require => false
  gem 'nokogiri'
end
