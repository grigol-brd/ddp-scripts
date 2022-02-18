#!/usr/bin/env bash

# stop script if error occurs at any point
set -e

function main {
  NAME=$0
  STUDY=$1; shift
  SUBS=$1; shift

  if [[ -z $STUDY ]]; then
    echo ""
    echo "Error: study name argument is required" | GREP_COLOR='01;31' grep . --color=always
    exit 1
  fi

  if [[ -z $SUBS || ($SUBS != "subs.conf" && $SUBS != "substitutions.conf") ]]; then
    echo ""
    echo "Error: substitutions file name argument is required (\`subs.conf\` or \`substitutions.conf\`)" | GREP_COLOR='01;31' grep . --color=always
    exit 1
  fi

  . ./env.sh $STUDY


  RUN_PEPPER_SERVER_CMD="java -Dconfig.file=./output-config/application.conf -jar ./dss-server/target/DataDonationPlatform.jar"

  RUN_STUDY_BUILDER_CMD="java -Dconfig.file=./output-config/application.conf -jar ${STUDY_BUILDER_CLI_DIR}/target/StudyBuilder.jar --vars ./output-config/vars.conf ./studies/${STUDY}/study.conf --substitutions ./studies/${STUDY}/${SUBS}"

  

  while true; do
    case "$1" in
      --build-pepper)
        build_pepper
        break
        ;;
      --run-pepper)
        run_pepper
        break
        ;;
      --render-pepper)
        render_pepper_config
        break
        ;;
      --build-study)
        build_study
        break
        ;;
      --run-study)
        run_study
        break
        ;;
      --render-study)
        render_study_config
        break
        ;;
      --clean-db)
        clean_db
        break
        ;;
      --all)
        clean_db
        build_pepper
        build_study
        run_pepper
        break
        ;;
      --all-no-db)
        build_pepper
        build_study
        run_pepper
        break
        ;;
      --help|-h)
        print_usage
        exit 0
        ;;
      *)
        print_usage
        exit 0
        ;;
    esac
  done
}



function clean_db {
  $SCRIPTS_DIR/empty-database.sh

  echo 'database clearing complete'
}


function build_pepper {
  render_pepper_config

  cd $PEPPER_APIS_DIR

  mvn -DskipTests clean install -pl dss-server -am

  logfile="tmp.log"
  match="ddp startup complete"
  
  $RUN_PEPPER_SERVER_CMD > "$logfile" 2>&1 &

  pid=$!

  while sleep 10
  do
    if fgrep --quiet "$match" "$logfile"
    then
      kill -SIGkill $pid
      cat $logfile
      break
    else cat $logfile
    fi
  done
}


function build_study {
  render_study_config

  cd $PEPPER_APIS_DIR

  mvn -DskipTests clean install -pl studybuilder-cli -am

  cd $STUDY_BUILDER_CONFIGS_DIR

  $RUN_STUDY_BUILDER_CMD | prefix_logs 'Study Builder'
}


function run_pepper {
  cd $PEPPER_APIS_DIR

  $RUN_PEPPER_SERVER_CMD | prefix_logs 'Pepper'
}


function run_study {
  cd $STUDY_BUILDER_CONFIGS_DIR

  $RUN_STUDY_BUILDER_CMD | prefix_logs 'Study Builder'
}


function render_pepper_config {
  cd $PEPPER_APIS_DIR

  ./api-build.sh v1 dev . --config

  $SCRIPTS_DIR/configure-pepper.sh
}


function render_study_config {
  cd $STUDY_BUILDER_CONFIGS_DIR

  ./render.sh v1 dev $STUDY

  $SCRIPTS_DIR/configure-study-builder.sh
}


function prefix_logs {
  sed -e "s/^/[${1}] /;"
}


function print_usage {
  cat << EOM
A script to help automate a few different steps of the build process.

USAGE:
  $NAME <study_name> <substitutions_config_file> <OPTION>

OPTIONS:
  --all-no-db                     used when running build process for the very first time (does pepper build, study build, and pepper startup)
  --all                           does same stuff as '--all' but plus clearing database before running any build process
  --build-pepper                  run just pepper build process
  --build-study                   run just study build process for the given study
  --run-pepper                    only start up pepper server
  --run-study                     only run study builder
  --render-pepper                 only renders configuration for pepper server
  --render-study                  only renders configuration for study builder
  --clean-db                      cleans database

EOM
}


main "$@"; exit
