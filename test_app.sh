#!/bin/bash
# Proper header for a Bash script.

APP_DB_NAME_DEV='rubymn_dev'
APP_DB_NAME_TEST='rubymn_test'
APP_DB_USER='rubymn_user'
APP_DB_PASS='rubymn_password'

# Set up PostgreSQL
echo '---------------------'
echo 'Setting up PostgreSQL'

sudo -u postgres psql -c"CREATE ROLE $APP_DB_USER WITH CREATEDB LOGIN PASSWORD '$APP_DB_PASS';"
sudo -u postgres psql -c"CREATE DATABASE $APP_DB_NAME_DEV WITH OWNER=$APP_DB_USER;"
sudo -u postgres psql -c"CREATE DATABASE $APP_DB_NAME_TEST WITH OWNER=$APP_DB_USER;"

echo '--------------'
echo 'bundle install'
bundle install

echo '---------------------------'
echo 'bundle exec rake db:migrate'
bundle exec rake db:migrate

echo '---------------------'
echo 'bundle exec rake test'
bundle exec rake test
