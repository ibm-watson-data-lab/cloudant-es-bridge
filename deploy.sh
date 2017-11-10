#!/bin/bash

# don't deploy without env variables
if [[ -z "${CLOUDANT_HOST}" ]]; then
  echo "Environment variable CLOUDANT_HOST is required"
  exit 1
fi
if [[ -z "${CLOUDANT_USERNAME}" ]]; then
  echo "Environment variable CLOUDANT_USERNAME is required"
  exit 1
fi
if [[ -z "${CLOUDANT_PASSWORD}" ]]; then
  echo "Environment variable CLOUDANT_PASSWORD is required"
  exit 1
fi
if [[ -z "${CLOUDANT_DB}" ]]; then
  echo "Environment variable CLOUDANT_DB is required"
  exit 1
fi
if [[ -z "${ELASTIC_URL}" ]]; then
  echo "Environment variable ELASTIC_URL is required"
  exit 1
fi

# create a package called 'leaderboard' with our credentials 
wsk package create esbridge --param elasticurl "$ELASTIC_URL" -p username "$CLOUDANT_USERNAME" -p password "$CLOUDANT_PASSWORD" -p host "$CLOUDANT_HOST"

# deploy our stream action to the package
wsk action create esbridge/onchange onchange.js

# now the changes feed config
# create a Cloudant connection
wsk package bind /whisk.system/cloudant esbridgeCloudant -p username "$CLOUDANT_USERNAME" -p password "$CLOUDANT_PASSWORD" -p host "$CLOUDANT_HOST"

# a trigger that listens to our database's changes feed
wsk trigger create esbridgeTrigger --feed /_/esbridgeCloudant/changes --param dbname "$CLOUDANT_DB" 

# a rule to call our action when the trigger is fired
wsk rule create esbridgeRule esbridgeTrigger esbridge/onchange


