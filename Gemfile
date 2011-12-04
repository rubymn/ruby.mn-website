source :rubygems

gem 'rails',   '3.1.3'
gem 'pg',      '~> 0.11.0'
gem 'unicorn', '~> 4.0.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails', '~> 3.1.1'
  gem 'uglifier',     '>= 1.0.3'
  gem 'compass',      '~> 0.12.alpha'
end

gem 'sass-rails',     '~> 3.1.4'
gem 'jquery-rails',   '~> 1.0.0'
gem "recaptcha",      '~> 0.3.1', :require => "recaptcha/rails"
gem "haml",           '~> 3.1.3'
gem 'rdiscount',      '~> 1.6.8'
gem "paperclip",      '~> 2.4.5'
gem 'rails_autolink', '~> 1.0.4'
gem 'dynamic_form',   '~> 1.1.4'
gem 'gravatarify',    '~> 3.0.0'
gem 'kaminari',       '~> 0.12.4'

group :development do
  gem 'haml-rails',         '0.3.4'
  gem 'rails3-generators',  '0.17.4'
end

group :test do
  gem 'shoulda',            '3.0.0.beta2'
  gem 'shoulda-matchers',   '1.0.0.beta3'
  gem 'turn',               '~> 0.8.3',   :require => false
  gem 'minitest',           '~> 2.7.0'
  gem 'mocha',              '~> 0.10.0'
  gem 'rdoc'
  gem 'guard',              '~> 0.6.1'
  gem 'guard-test',         '~> 0.3.0'
  gem 'guard-bundler',      '~> 0.1.3'
  gem 'rb-fsevent',         '~> 0.4.3.1', :require => false
  gem 'rb-fchange',         '~> 0.0.5',   :require => false
end

group :test, :development do
  gem 'factory_girl',       '~> 2.2.0'
  gem 'factory_girl_rails', '~> 1.3.0'
  gem 'faker',              '~> 1.0.1'
  gem 'progress_bar',       '~> 0.4.0'
end

group :production do
  gem 'rack-cache',   '~> 1.1'
  gem 'rack-contrib', '~> 1.1.0'
  gem 'dalli',        '~> 1.1.3'
end
