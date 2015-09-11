#!/bin/bash
# Proper header for a Bash script.

gem install mailcatcher
mailcatcher --ip 0.0.0.0
echo 'View mail at http://localhost:1080/'
# Send mail through smtp://localhost:1025
