#!/bin/bash
# Proper header for a Bash script.

bundle install
rake db:migrate
rake test
