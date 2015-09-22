#!/bin/bash
# Proper header for a Bash script.

echo '--------------'
echo 'bundle install'
bundle install

echo '----------------'
echo 'brakeman -Aq -w2'
brakeman -Aq -w2

echo '-----------'
echo 'sandi_meter'
sandi_meter

echo '------------'
echo 'bundle-audit'
bundle-audit

echo '----------'
echo 'gemsurance'
gemsurance
echo 'The Gemsurance Report is in gemsurance_report.html in the root directory.'
