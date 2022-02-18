#!/usr/bin/env bash

# update application.conf
DB_PASS="pass"
DB_URL="jdbc:mysql://127.0.0.1:3306/pepperlocal?user=root\&password=${DB_PASS}\&useSSL=false\&allowPublicKeyRetrieval=true\&serverTimezone=Europe/Moscow\&sessionVariables=innodb_strict_mode=on,sql_mode='TRADITIONAL'"

FILE_TO_UPDATE="${STUDY_BUILDER_CONFIGS_DIR}/output-config/application.conf"

sed -i "s|\"dbUrl\":.*|\"dbUrl\": \"${DB_URL}\",|g" ${FILE_TO_UPDATE}


if [[ $STUDY_KEY == 'singular' ]]; then
    sed -i "s|\"defaultTimezone\":\(.*\)|\"defaultTimezone\":\1\n\
    \"fileUploads\": {\n\
        \"uploadsBucket\": \"ddp-dev-file-uploads\",\n\
        \"scannedBucket\": \"ddp-dev-file-scanned\",\n\
        \"quarantineBucket\": \"ddp-dev-file-quarantine\",\n\
        \"maxFileSizeBytes\": 1.048576e+07,\n\
        \"maxSignedUrlMins\": 5,\n\
        \"removalExpireTime\": 1,\n\
        \"removalExpireUnit\": \"DAYS\",\n\
        \"removalBatchSize\": 100,\n\
        \"enableScanResultHandler\": true,\n\
        \"scanResultSubscription\": \"cf-file-scan-result-hkeep-sub\",\n\
        \"signerServiceAccount\": {\n\
            \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\",\n\
            \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\",\n\
            \"client_email\": \"ddp-file-uploader@broad-ddp-dev.iam.gserviceaccount.com\",\n\
            \"client_id\": \"109909558964788304382\",\n\
            \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/ddp-file-uploader%40broad-ddp-dev.iam.gserviceaccount.com\",\n\
            \"private_key\": \"-----BEGIN PRIVATE KEY-----\\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZmTBZg+ywTtwV\\\nsJvxZqvCz0SdgfPO1yxher2pCPZKjXrLK7uWifEgx0EvfRFwEcsPeSCBEId08jUC\\\n7EqNup/2wiVWpBJ1PDpCzXyI24P9WI2d9kDoSXXzwG/2I8zHg5zMPar4waEzEwcp\\\nNnEzHfcdmLXVP59HeYJAr62vMyQK/lnPkFMpYtvLdwLZbrW7zpSsJDn5veitiPLO\\\ncN7IuloVcJwEwJbPnV0Vb3t2XzoM0HYp7tKIBQQloesqiUM/kBmwxiJ5dwhfvV+k\\\nqLVuJs4Jk10/r81QRbVnbi1FDTh3sEuUY5zHdj4PO5fdtcEtzNSVj+96RzCNEU9B\\\nhNZB4mSHAgMBAAECggEAPB9nepKWMkkcAu13jR2IPCAPlqvIeH1nZNy7oo/cgEAz\\\nAZYjvoBOP2tfS6xkB/8fAfaCz6Jds1wfff5qDGIxvVAvd2OPyg4CLCXtClEKsD9a\\\nZ6t9qq8emYQJD0riHHKbDKNS6j440BoxomMqGj0vfolJG6jkuwCICLP7g2m8QQTF\\\nIbpbVZEn8dkzkEaF2Ix37YUhqlOlHZjayEIiUBL5doLLazghTvR8Kc/XicD8Vidb\\\nPjYqG+cKF1Ok1se9sRKIlhF+eHyqTZu09qDYRBmu/6WnE1cxt84QjOzdJvvvkHNg\\\nws0tHq585wUw43zKOptynG39LNddoyOB3H07j4R3UQKBgQDUF4CUPNu94FG3cfp4\\\n1AChc67nI8UEJaaqI64gcwVFfDdDWgmM1zkm15+OT/RKP41k6qjKyzDOxpqWC6rm\\\nalS2OfmSpM5JkQ8/F4Mu7DCwMFu4MarWOE3OYJDbHkcga4MtakSnAmw8dK12KmJ0\\\ngGbjsoq9koaYjRaYaGjlAh8EfwKBgQC5ZaMj2IOrPGVgtIsoxDcMOAnfyhf+b0uN\\\nV/4vSfLlqS2r1aQAydcDVXkh71EKGJGzWxoT+LvCWH6sfEeHuds9sjw3HVPNpNYy\\\nz2lL0di03NA7SzXDewFowiH3z10n3GfdNQyHa2iYN4JjCdbo7gwvQkbuy8E/Y2l8\\\nI8DwtnJ7+QKBgQCSyCEodmXtps1nE+6wqKg3FIS7WroDALuzjDX6JyBC0pC8gBeT\\\n7W+UPi4io5sBt7H3YZ+nmbARqslZhoGkLXqrErxyjLRnnYjbtT4Iv1WC2jTf6R++\\\nWgEfDx2xR+cZvM5wI9eXbcnSnT1fRj4VOrf6ZZo3UKzt7tbwa3IM68bjqQKBgQCu\\\nn+YO4GP8yPFwKf4dUtvKvYnHaVI6TFgsdOItZojL+xLSlHNabsMAF+T1qrV5PfUW\\\nq8ufXhx0DOibzJ+PXub7cMM44n3J5+X9i9FRIgHtMUNNZiTo0BZetuRJxt6mqfqG\\\np+36K5gkL7y3TlBHq9h8NwAa8n4+F4QG8qJL2H1y+QKBgBYl4AECBfUJqvNoOExI\\\neCF6C/wXESxLzoezZgv4jFkDrstq/5L1D5RoTZ5lVMW9NggaJ93icpaW36jLTsCA\\\nXMJuA6Q80Ffw4GS7xgIxwTvfpW3oWZ/na7eBBEHPgr8n+RcUSJNkpiuPloCjky+Z\\\n4hf2HHreSornIjnxc/hpUPTs\\\n-----END PRIVATE KEY-----\\\n\",\n\
            \"private_key_id\": \"25d9464f0eaa2a99194f38e2f8ef52f49d2a043a\",\n\
            \"project_id\": \"broad-ddp-dev\",\n\
            \"token_uri\": \"https://oauth2.googleapis.com/token\",\n\
            \"type\": \"service_account\"\n\
        }\n\
    },|g" ${FILE_TO_UPDATE}
fi


# update vars.conf
FILE_TO_UPDATE="${STUDY_BUILDER_CONFIGS_DIR}/output-config/vars.conf"

sed -i "s|\"clientId\":.*|\"clientId\": \"${CLIENT_ID}\",|g" ${FILE_TO_UPDATE}
sed -i "s|\"clientSecret\":.*|\"clientSecret\": \"${CLIENT_SECRET}\",|g" ${FILE_TO_UPDATE}

if [[ -n $AUTH0_DOMAIN ]]; then
    sed -i "s|\"domain\":.*|\"domain\": \"${AUTH0_DOMAIN}\",|g" ${FILE_TO_UPDATE}
fi

