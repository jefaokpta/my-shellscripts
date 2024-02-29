#!/bin/bash

dynos=$(heroku apps)

for dyno in $dynos; do
  echo "Checking $dyno"
  heroku config -a $dyno | grep -i "CONTROL_NUMBER"
done