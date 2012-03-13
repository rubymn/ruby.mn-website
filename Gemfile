source :rubygems

gem 'rails',   '3.2.2'
gem 'pg',      '~> 0.12.0'
gem 'unicorn', '~> 4.2.0'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'coffee-rails',  '~> 3.2.2'
  gem 'uglifier',      '>= 1.2.0'
  gem 'compass-rails', '~> 1.0.0'
end

gem 'sass-rails',     '~> 3.2.2'
gem 'jquery-rails',   '~> 2.0.0'
gem "recaptcha",      '~> 0.3.1', :require => "recaptcha/rails"
gem "haml",           '~> 3.1.3'
gem 'rdiscount',      '~> 1.6.8'
gem "paperclip",      '~> 2.4.5'
gem 'rails_autolink', '~> 1.0.4'
gem 'dynamic_form',   '~> 1.1.4'
gem 'gravatarify',    '~> 3.0.0'
gem 'kaminari',       '~> 0.13.0'
gem 'chronic',        '~> 0.6.6'

group :development do
  gem 'haml-rails',         '0.3.4'
  gem 'rails3-generators',  '0.17.4'
end

group :test do
  gem 'shoulda',            '~> 3.0.1'
  gem 'test-unit',          '~> 2.4.8'
  gem 'mocha',              '~> 0.10.0'
  gem 'rdoc'
  # gem 'guard',              '~> 0.6.1'
  # gem 'guard-test',         '~> 0.3.0'
  # gem 'guard-bundler',      '~> 0.1.3'
  gem 'rb-fsevent',         '~> 0.4.3.1', :require => false
  gem 'rb-fchange',         '~> 0.0.5',   :require => false
end

group :test, :development do
  gem 'factory_girl_rails', '~> 1.5.0'
  gem 'faker',              '~> 1.0.1'
  gem 'progress_bar',       '~> 0.4.0'
end

group :production do
  gem 'rack-cache',   '~> 1.2'
  gem 'rack-contrib', '~> 1.1.0'
  gem 'dalli',        '~> 1.1.5'
end
