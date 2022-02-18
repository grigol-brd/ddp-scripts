#!/usr/bin/env bash

# stop script if error occurs at any point
set -e

STUDY=$1
STUDY_GUID=$2

. ./env.sh $STUDY

if [[ -z $STUDY ]]; then
  echo "Error: No study key provided"
  exit 1
fi

if [[ -z $STUDY_GUID ]]; then
  echo "Error: No study guid provided"
  exit 1
fi


cd $ANGULAR_DIR
./build-study.sh v1 dev . $STUDY $STUDY_GUID --config

$SCRIPTS_DIR/configure-client.sh
