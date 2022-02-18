#!/usr/bin/env bash

if [[ -z $STUDY_KEY ]]; then
  echo "Error: No study key provided for angular project"
  exit 1
fi

# update pepperConfig.js
REGISTER="true"
LOGGING="false"
PEPPER_URL="http://localhost:5555"

FILE_TO_UPDATE="${ANGULAR_DIR}/ddp-workspace/projects/ddp-${STUDY_KEY}/output-config/pepperConfig.js"

sed -i "s|doLocalRegistration:.*|doLocalRegistration: ${REGISTER},|g" ${FILE_TO_UPDATE}
sed -i "s|doCloudLogging:.*|doCloudLogging: ${LOGGING},|g" ${FILE_TO_UPDATE}
sed -i "s|doGcpErrorReporting:.*|doGcpErrorReporting: ${LOGGING},|g" ${FILE_TO_UPDATE}

sed -i "s|DDP_ENV\['basePepperUrl'\] =.*|DDP_ENV\['basePepperUrl'\] = \"${PEPPER_URL}\";|g" ${FILE_TO_UPDATE}
sed -i "s|DDP_ENV\['auth0ClientId'\] =.*|DDP_ENV\['auth0ClientId'\] = \"${CLIENT_ID}\";|g" ${FILE_TO_UPDATE}


if [[ -n $AUTH0_DOMAIN ]]; then
  AUTH0_DOMAIN_ONLY=$(echo ${AUTH0_DOMAIN:0:-1} | sed 's|https\?:\/\/||g') # extract only domain without schema: https://test.com/ ==> test.com

  sed -i "s|DDP_ENV\['auth0Domain'\] =.*|DDP_ENV\['auth0Domain'\] = \"${AUTH0_DOMAIN_ONLY}\";|g" ${FILE_TO_UPDATE}
  sed -i "s|DDP_ENV\['auth0Audience'\] =.*|DDP_ENV\['auth0Audience'\] = \"${AUTH0_DOMAIN_ONLY}\";|g" ${FILE_TO_UPDATE}
fi
