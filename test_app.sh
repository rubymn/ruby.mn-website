#!/bin/bash
# Proper header for a Bash script.

#!/bin/bash

# Set up PostgreSQL
echo '---------------------'
echo 'Setting up PostgreSQL'
PG_VERSION="$(ls /etc/postgresql)"
PG_HBA="/etc/postgresql/$PG_VERSION/main/pg_hba.conf"

# Change the settings in the pg_hba.conf file
sudo bash -c "echo '# Database administrative login by Unix domain socket' > $PG_HBA"
sudo bash -c "echo 'local   all             postgres                                peer' >> $PG_HBA"
sudo bash -c "echo 'local   all             all                                     peer' >> $PG_HBA"
sudo bash -c "echo 'host    all             all             127.0.0.1/32            md5'  >> $PG_HBA"
sudo bash -c "echo 'host    all             all             ::1/128                 md5'  >> $PG_HBA"

sudo /etc/init.d/postgresql restart # Restart PostgreSQL

sudo -u postgres psql -c"CREATE ROLE $USER WITH CREATEDB LOGIN PASSWORD '';"
sudo -u postgres psql -c"CREATE DATABASE rubymn_dev WITH OWNER=$USER;"
sudo -u postgres psql -c"CREATE DATABASE rubymn_test WITH OWNER=$USER;"

echo '--------------'
echo 'bundle install'
bundle install

echo '---------------------------'
echo 'bundle exec rake db:migrate'
bundle exec rake db:migrate

echo '---------'
echo 'rake test'
rake test
