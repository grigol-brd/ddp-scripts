#!/usr/bin/env bash

# update application.conf
DB_PASS="pass"
DB_URL="jdbc:mysql://127.0.0.1:3306/pepperlocal?user=root\&password=${DB_PASS}\&useSSL=false\&allowPublicKeyRetrieval=true\&serverTimezone=Europe/Moscow\&sessionVariables=innodb_strict_mode=on,sql_mode='TRADITIONAL'"
CACHE_FILE_PATH="./output-config/redisson-jcache.yaml"
REDIS_URL="redis://localhost:6379"

FILE_TO_UPDATE="${PEPPER_APIS_DIR}/output-config/application.conf"

sed -i "s|\"dbUrl\":.*|\"dbUrl\": \"${DB_URL}\",|g" ${FILE_TO_UPDATE}
sed -i "s|\"doLiquibase\":.*|\"doLiquibase\": true, \"doLiquibaseInStudyServer\": true,|g" ${FILE_TO_UPDATE}
sed -i "s|\"restrictRegisterRoute\":.*|\"restrictRegisterRoute\": false,|g" ${FILE_TO_UPDATE}
sed -i "s|\"ipAllowList\":.*|\"ipAllowList\": [\"0.0.0.0\", \"127.0.0.1\",|g" ${FILE_TO_UPDATE}
sed -i "s|\"jcacheConfigurationFile\":.*|\"jcacheConfigurationFile\": \"${CACHE_FILE_PATH}\",|g" ${FILE_TO_UPDATE}
sed -i "s|\"redisServerAddress\":.*|\"redisServerAddress\": \"${REDIS_URL}\",|g" ${FILE_TO_UPDATE}

if [[ -n $AUTH0_DOMAIN ]]; then
    sed -i "s|\"domain\":.*|\"domain\": \"${AUTH0_DOMAIN}\",|g" ${FILE_TO_UPDATE}
fi


# update redis file
FILE_TO_UPDATE="${PEPPER_APIS_DIR}/output-config/redisson-jcache.yaml"

sed -i "s|address:.*|address: \"${REDIS_URL}\"|g" ${FILE_TO_UPDATE}
