#!/usr/bin/env bash

# stop script if error occurs at any point
set -e

function main {
  # colors
  RED=31; GREEN=32;

  NAME=$0
  STUDY=$1;
  SUBS=$2;

  if [[ -z $STUDY ]]; then
    echo "Error: study name argument is required" | color_red
    exit 1
  fi

  if [[ -z $SUBS || ($SUBS != "subs.conf" && $SUBS != "substitutions.conf") ]]; then
    echo "Error: substitutions file name argument is required (\`subs.conf\` or \`substitutions.conf\`)" | color_red
    exit 1
  fi

  shift; shift # remove positional arguments

  if [[ $# == 0 ]]; then
    echo 'At least one option argument is required. Use -h to see usage' | color_red
  fi


  # load env variables
  source ./env.sh $STUDY


  RUN_PEPPER_SERVER_CMD="java -Dconfig.file=./output-config/application.conf -jar ./dss-server/target/DataDonationPlatform.jar"

  RUN_STUDY_BUILDER_CMD="java -Dconfig.file=./output-config/application.conf -jar ${STUDY_BUILDER_CLI_DIR}/target/StudyBuilder.jar --vars ./output-config/vars.conf ./studies/${STUDY}/study.conf --substitutions ./studies/${STUDY}/${SUBS}"
  if [[ $STUDY_KEY == 'basil' ]]; then
    RUN_STUDY_BUILDER_CMD="${RUN_STUDY_BUILDER_CMD} --process-translations PROCESS_IGNORE_TEMPLATES_WITH_TRANSLATIONS"
  fi

  RUN_STUDY_BUILDER_INVALIDATE_CMD="${RUN_STUDY_BUILDER_CMD} --invalidate"
  

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h|--help)
        print_usage
        exit 0
        ;;
      --build-pepper)
        build_pepper
        shift
        ;;
      -cp|--compile-pepper)
        compile_pepper
        shift
        ;;
      -rp|--run-pepper)
        run_pepper
        shift
        ;;
      -ip|--init-pepper)
        init_pepper
        shift
        ;;
      --render-pepper)
        render_pepper_config
        shift
        ;;
      --build-study)
        build_study
        shift
        ;;
      -cs|--compile-study)
        compile_study
        shift
        ;;
      -rs|--run-study)
        run_study
        shift
        ;;
      --render-study)
        render_study_config
        shift
        ;;
      -i|--invalidate)
        invalidate_study
        shift
        ;;
      -ra|--render-all)
        render_study_config
        render_pepper_config
        shift
        ;;
      -cd|--clean-db)
        clean_db
        shift
        ;;
      --all)
        clean_db
        build_pepper
        build_study
        run_pepper
        shift
        ;;
      --all-no-db)
        build_pepper
        build_study
        run_pepper
        shift
        ;;
      --all-no-build)
        clean_db
        render_pepper_config
        init_pepper
        render_study_config
        run_study
        run_pepper
        shift
        ;;
      -q|--all-quick)
        invalidate_study
        run_study
        run_pepper
        shift
        ;;
      --build-osteo-old)
        build_osteo_old
        shift
        ;;
      --patch-osteo-v2)
        run_patch_osteo_v2
        shift
        ;;
      *)
        unknown_option $1
        shift
        ;;
    esac
  done
}



function clean_db {
  cd $SCRIPTS_DIR

  ./empty-database.sh || true # '||true' ignores error's if command fails

  echo 'database clearing complete'
}


function build_pepper {
  render_pepper_config
  compile_pepper
  init_pepper
}


function build_study {
  render_study_config
  compile_study
  run_study
}


function compile_pepper {
  cd $PEPPER_APIS_DIR

  mvn -DskipTests clean install -pl dss-server -am
}


function compile_study {
  cd $PEPPER_APIS_DIR

  mvn -DskipTests clean install -pl studybuilder-cli -am
}

# when running pepper for the first time it needs to do db migration before we run study builder
function init_pepper {
  cd $PEPPER_APIS_DIR

  logfile="tmp.log"
  match="ddp startup complete"
  
  # run in the background and output logs into a file
  # so we can listen logs for specific string to know process has finished and stop it
  $RUN_PEPPER_SERVER_CMD > "$logfile" 2>&1 &

  pid=$!

  # listen for specific string in logs
  while sleep 3
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


function run_pepper {
  cd $PEPPER_APIS_DIR

  $RUN_PEPPER_SERVER_CMD | prefix_logs 'Pepper' $GREEN
}


function invalidate_study {
  cd $STUDY_BUILDER_CONFIGS_DIR

  $RUN_STUDY_BUILDER_INVALIDATE_CMD
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


function build_osteo_old {
  OSTEO_OLD_BRANCH='osteo-old'

  cd $STUDY_SERVER_DIR

  CURRENT_BRANCH=$(git branch --show-current)

  git checkout $OSTEO_OLD_BRANCH

  clean_db
  build_pepper
  build_study

  git checkout ${CURRENT_BRANCH:-'develop'}

  run_pepper
}


function run_patch_osteo_v2 {
  compile_study

  cd $STUDY_BUILDER_CONFIGS_DIR

  TASK='OsteoV2Updates'
  RUN_PATCH_CMD="${RUN_STUDY_BUILDER_CMD} --run-task ${TASK}"

  $RUN_PATCH_CMD | prefix_logs 'Study Builder Patching'

  run_pepper
}


function prefix_logs {
  sed -e "s/^/[${1}] \x1b[${2:-0}m/;"
}


function color_red {
  GREP_COLOR='01;31' grep . --color=always
}


function unknown_option {
  echo "Unknown option '$1', skipping it" | color_red
  echo "               ^^^^^" | color_red
}


function print_usage {
  cat << EOM
A script to help automate a few different steps of the build process.

USAGE:
  $NAME <study_name> <substitutions_config_file> <OPTION> [OPTION] ...

  $NAME singular substitutions.conf --run-pepper

  NOTE: Order of OPTIONs matter, necessary steps will be run in the same order as options were provided

OPTIONS:
  --all
    clear the whole db, render required configs, compile and run pepper server and study builder

  --all-no-db
    same steps as '--all' but skips database clearing

  --all-no-build
    same steps as '--all' but skips maven compilations and uses previously built .jar files. Useful when there are no changes in java code

  --all-quick
    invalidate given study, run pepper and study server. Useful when there's been only .conf file changes and need to see reflect quick

  --build-pepper
    compile and run pepper

  --build-study
    compile and run study builder

  --run-pepper
    start up pepper server

  --run-study
    run study builder

  --render-pepper
    render configuration for pepper server

  --render-study
    render configuration for study builder

  --clean-db
    clear the whole db
EOM
}


main "$@"; exit
