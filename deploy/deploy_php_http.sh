#!/bin/bash
set -eu

if [ "$#" -ne 2 ]; then
  echo ""
  echo "  Insufficient arguments."
  echo "  Usage: $0 <dirname to be deployed> <name on Cloud Functions>"
  echo ""
  exit 1
fi

WORK_DIR=_deploy
TARGET_DIR=$1
export FUNC_NAME=$2
# remove "/" on the right side
FUNC_NAME=`php -r '$result=getenv("FUNC_NAME"); echo substr($result, -1) === "/" ? rtrim($result, "/") : $result;'`

echo "Checking ${TARGET_DIR}"
# pushd ${FUNC_NAME}

# Check existance of .gcloudignore
if ! test -f ".gcloudignore"; then
    echo ".gcloudignore doesn't exist. Please create it."
    exit 1
fi

# # Check existance of specific deploy.sh
# if test -f "deploy.sh"; then
#     echo "Specific deploy.sh for this app exists. Please run it instead of this shell."
#     exit 1
# fi

# check existance of config.sample.json & config.json
if test -f "configs/config.json.sample"; then
    if test ! -f "configs/config.json"; then
        echo "Config.json.sample exists. Please make config.json for this app."
        exit 1
    fi
fi
# popd

echo "Starting to deploy ${FUNC_NAME}"

rm -rf ./${WORK_DIR}
mkdir -p ${WORK_DIR}

rsync -vaL --exclude-from=./_cf-common/deploy/rsync_exclude.conf ./${TARGET_DIR} ./${WORK_DIR}/
pushd ${WORK_DIR}

echo "-------- deploying http --------"
gcloud functions deploy ${FUNC_NAME} \
    --gen2 \
    --runtime=php82 \
    --region=us-west1 \
    --source=. \
    --entry-point=main \
    --trigger-http \
    --allow-unauthenticated \
    --max-instances 1

popd
rm -rf ./${WORK_DIR}
