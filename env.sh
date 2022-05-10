#!/usr/bin/env bash


# set these absolute path directories according to locations on your machine <=====

export STUDY_SERVER_DIR="D:\developer\broad\ddp-study-server"
export ANGULAR_DIR="D:\developer\broad\ddp-angular"
export SCRIPTS_DIR="D:\developer\broad\scripts-ddp"

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


function read_vault_key {
  vault kv get -field=$1 secret/pepper/dev/v1/local/conf
}


# We usually have auth0 LocalDev app credentials stored in vault for local configurations
export CLIENT_ID=$(read_vault_key auth0ClientId)
export CLIENT_SECRET=$(read_vault_key auth0ClientSecret)


if [[ -z $CLIENT_ID || -z $CLIENT_SECRET ]]; then
  echo "Error: failed to read auth0 credentials from vault. Please make sure you have access to vault."
  exit 1
fi


# trailing slash is a MUST! it won't be appended automatically by the pepper
export AUTH0_DOMAIN="https://ddp-dev.auth0.com/"
