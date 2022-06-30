#!/usr/bin/env bash


docker container stop broad_elastic
# docker container stop broad_mysql
# docker container stop broad_cache
docker container rm broad_elastic
# docker container rm broad_mysql
# docker container rm broad_cache

rm -r -f ../elastic_data
if [ ! -d "../elastic_data" ]; then
    mkdir ../elastic_data
fi

docker-compose -f docker-compose-es.yml up -d 
sleep 60
curl -k -u elastic:111111 -XDELETE "http://localhost:9200/_security/role/pepper_backend"
curl -k -u elastic:111111 -XDELETE "http://localhost:9200/_security/user/pepper_backend"
curl -k -u elastic:111111 -XPOST "http://localhost:9200/_security/role/pepper_backend" -H 'Content-Type: application/json' -d'{"indices":[{"names":["sample-*"],"privileges":["read","write"]}]}'
curl -k -u elastic:111111 -XPOST "http://localhost:9200/_security/user/pepper_backend" -H 'Content-Type: application/json' -d'{"roles":["pepper_backend"],"full_name":"Pepper","email":"zurab.bokuchava@quantori.com","password":"pGwcVyYFj2VuRy2Fa5dG0dXR"}'



# export SCRIPTS_DIR="D:\documents\QUANTORI\projects\ddp-study-server\pepper-apis\docs\specification"
# $SCRIPTS_DIR/build.sh docker quantori/broad_docs
# docker run -d --name broad_docs quantori/broad_docs