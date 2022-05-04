#!/usr/bin/env bash

# stop script if error occurs at any point
set -e


BASH_PRFILE=~/.bash_profile
GITHUB_TOKEN_FILE=~/.github-token
CI_TOKEN_FILE=~/.circleci-token


function setup_windows {
    powershell ./setup-win.ps1
}


function setup_unix {
    if [[ -z $VAULT_ADDR ]]; then
        echo "export VAULT_ADDR=https://clotho.broadinstitute.org:8200" >> $BASH_PRFILE
        echo "Set VAULT_ADDR"
    fi

    if [[ -z $GOOGLE_APPLICATION_CREDENTIALS ]]; then
        echo "export GOOGLE_APPLICATION_CREDENTIALS=./output-build-config/housekeeping-service-account.json" >> $BASH_PRFILE
        echo "Set GOOGLE_APPLICATION_CREDENTIALS"
    fi
}


case $(uname -o | tr '[:upper:]' '[:lower:]') in
    msys*)
        echo "Configuring for Windows"
        setup_windows
        ;;
    *)
        echo "Configuring for Unix"
        setup_unix
        ;;
esac


while getopts "c:g:" arg; do
    case $arg in
        c)
            if [[ -f $CI_TOKEN_FILE ]]; then
                rm $CI_TOKEN_FILE
            fi

            echo $OPTARG >> $CI_TOKEN_FILE

            echo '--------------------'
            echo 'Updated CI token file'
            echo '--------------------'
            ;;
        g)
            if [[ -f $GITHUB_TOKEN_FILE ]]; then
                rm $GITHUB_TOKEN_FILE
            fi

            echo $OPTARG >> $GITHUB_TOKEN_FILE

            vault login -method=github -address=https://clotho.broadinstitute.org:8200 token=$(cat $GITHUB_TOKEN_FILE)
            ;;
    esac
done

echo "Setup complete"
