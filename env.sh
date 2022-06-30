#!/usr/bin/env bash


# set these absolute path directories according to locations on your machine
#
export STUDY_SERVER_DIR="D:\documents\QUANTORI\projects\ddp-study-server"
export ANGULAR_DIR="D:\documents\QUANTORI\projects\ddp-angular"
export SCRIPTS_DIR="D:\documents\QUANTORI\projects\scripts-ddp-main"
#
# ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^ ^
# | | | | | | | | | | | | | | | | | | | | | | | |
# | | | | | | | | | | | | | | | | | | | | | | | |


if [[ ! -d $STUDY_SERVER_DIR || ! -d $ANGULAR_DIR || ! -d $SCRIPTS_DIR ]]; then
  echo "Please make sure directory paths are correct in 'env.sh' file" | GREP_COLOR="01;31" grep . --color=always
  exit 1
fi


export STUDY_KEY=$1

if [[ -z $STUDY_KEY ]]; then
  echo "Error: Study key unknown. Please provide one."
  exit 1
fi


export PEPPER_APIS_DIR="${STUDY_SERVER_DIR}/pepper-apis"
export STUDY_BUILDER_CLI_DIR="${PEPPER_APIS_DIR}/studybuilder-cli"


export CLIENT_ID="D1TNXhZChtMSUTGVFs1C2ow2kFGfMJrL"
export CLIENT_SECRET="75YX_LMk5SAvJSXYJd6z7HWFOE8s9FH3BVIfgvKNViPI2YOwDHdTCHAbhGbzo-D3"

# trailing slash is a MUST! it won't be appended automatically by the pepper
export AUTH0_DOMAIN="https://ddp-dev.auth0.com/"
