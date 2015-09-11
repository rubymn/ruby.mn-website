#!/bin/bash
# Proper header for a Bash script.

rake db:migrate:reset
rake db:seed
