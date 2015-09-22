VAGRANT BOX:
For a Vagrant box customized to this project, go to https://github.com/jhsu802701/vagrant-debian-jessie-rvm-rubymn .  Because Ruby 2.1.6 and Rails 3.2 are pre-installed, the process of setting up this project after you install or reinstall this box is much quicker.

DEVELOPMENT SETUP:
Just enter the following commands:
1.  git clone https://github.com/rubymn/ruby.mn-website.git
2.  cd ruby.mn-website
3.  Enter the command "sh test_app.sh".

DATABASE SEEDING
- Running "rake db:seed" provides an admin user (username of "admin1" and 
password of "railsrocks") and a VERIFIED user (username of "007" and password 
of "railsrocks").

NOTES
- recaptcha removed from user validation. Optionally add this back in if invalid/spam user signups really are a problem.
- WARNING: ignoring activemailer delivery errors in production. This is because the new site is in a test mode. If merged back into the main site, will probably want to flip this back. This setting is in config/environments/production.rb.
- If running rake gives you the error message "ERROR: encoding UTF8 does not match locale en_US Detail: The chosen LC_CTYPE setting requires encoding LATIN1.", 
then you need to execute the following commands to correct this:
sudo -u postgres pg_dumpall > /tmp/postgres.sql
sudo pg_dropcluster --stop 9.1 main
sudo pg_createcluster --locale en_US.UTF-8 --start 9.1 main
sudo -u postgres psql -f /tmp/postgres.sql
